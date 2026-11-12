#!/usr/bin/env bash
# gates/20-paginas-en-indice.sh — toda página nueva de docs/ tiene su `# Título` (uno solo, en la
# primera línea con texto) y está linkeada desde docs/index.md, como piden las convenciones de AGENTS.md.
# "Nueva" = un docs/*.md que está en FACTORY_CHANGED y no existía en FACTORY_BASE.
cd "${FACTORY_ROOT:-.}" || exit 1
base="${FACTORY_BASE:-HEAD}"
index="docs/index.md"
problems=""
checked=0

while IFS= read -r f; do
  case "$f" in
    docs/*/*) continue ;;  # el checker solo lee docs/*.md: las subcarpetas no son páginas
    docs/*.md) ;;
    *) continue ;;
  esac
  [ "$f" = "$index" ] && continue
  [ -f "$f" ] || continue                             # la borraron: no es una página nueva
  git cat-file -e "$base:$f" 2>/dev/null && continue  # ya existía antes de la corrida
  page="${f#docs/}"
  checked=$((checked + 1))

  # Títulos de nivel 1 (`# Algo`), sin contar los `# comentario` dentro de bloques de código.
  titles="$(awk '/^[[:space:]]*(```|~~~)/ { fence = !fence; next } !fence && /^# +[^[:space:]]/ { n++ } END { print n + 0 }' "$f")"
  first="$(grep -m 1 -v '^[[:space:]]*$' "$f")"
  if [ "$titles" -eq 0 ]; then
    problems="$problems- $f no tiene título: la primera línea tiene que ser \`# Título\`."$'\n'
  elif ! grep -qE '^# +[^[:space:]]' <<<"$first"; then
    problems="$problems- $f no empieza con su título: la primera línea con texto tiene que ser \`# Título\`."$'\n'
  elif [ "$titles" -gt 1 ]; then
    problems="$problems- $f tiene $titles títulos \`# \`: va uno solo por página, el resto son secciones \`## \`."$'\n'
  fi

  # Un link a la página en el índice: (page.md), (./page.md) o (page.md#seccion).
  page_re="$(sed 's/[][\.*^$+?(){}|/]/\\&/g' <<<"$page")"
  if [ ! -f "$index" ]; then
    problems="$problems- $f no está linkeada desde el índice: no existe $index."$'\n'
  elif ! grep -qE "\]\((\./)?$page_re(#[^)]*)?\)" "$index"; then
    problems="$problems- $f no está linkeada desde $index. Agrega: - [Título]($page): de qué trata."$'\n'
  fi
done <<<"$FACTORY_CHANGED"

if [ -n "$problems" ]; then
  echo "Las páginas nuevas de docs/ necesitan un título y un link desde el índice:"
  printf '%s' "$problems"
  exit 1
fi
if [ "$checked" -eq 0 ]; then
  echo "No hay páginas nuevas en docs/."
else
  echo "Páginas nuevas OK: $checked, todas con título y linkeadas desde el índice."
fi
