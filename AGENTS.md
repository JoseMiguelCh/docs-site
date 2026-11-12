# Pocket Timer docs

The user documentation of Pocket Timer, a small (fictional) command-line focus timer. The product here
is Markdown pages, not code: the "tests" check that every relative link and `#anchor` resolves.

## Layout
- `docs/`: the pages, all flat (the checker reads only `docs/*.md`, so no subfolders).
  - `index.md`: the home page; links to every page with a one-line description. It mentions an
    installation page that does not exist yet: link to it only once the page exists.
  - `getting-started.md` (`pocket start`, `pocket break`, `pocket today`), `configuration.md` (keys in
    `~/.pocket.toml`), `faq.md`.
  - `allowed-links.txt`: external URLs a human has approved.
- `tools/check_links.py`: the link checker (TEST_CMD).
- `gates/`: the human's checks, run after phase 3. `no-external-links.sh` rejects any `http(s)` URL in
  `docs/` that is not in `docs/allowed-links.txt`.
- `.claude/agents/`: the four phase agents. `factory.sh`, `lib/`, `doctor.sh`, `dashboard/`: the engine.
- `.factory/`: phase state as markdown (`plan.md`, `build.md`, `report.md`, `review.md`). Git-ignored,
  wiped at the start of each run.

## Check (must pass before any PR)
- Run the TEST_CMD from factory.conf exactly as written, from the repo root:
  `python3 tools/check_links.py`. Done means `0 broken link(s)` and exit code 0.
- It checks inline links `[text](page.md#slug)`: the page must exist in `docs/` and the slug must match
  a heading there. It skips reference-style links (`[text][ref]`) and targets with spaces: don't use them.
- Slug = heading in lowercase, punctuation dropped (except `-` and `_`), spaces to `-`:
  `## Where is my history stored?` → `faq.md#where-is-my-history-stored`.
- Renaming a heading breaks every link to it: search `docs/` for the old slug and fix those links too.
- The shell allows only TEST_CMD and `git diff main` (phases 3 and 4), one command per call, no `;`,
  `&&`, `||` or pipes. `rm`, `mv` and `cp` are denied. Read files with the Read tool.

## Writing conventions
- One `# Title` per page, then `##` sections. Short paragraphs, second person ("you"), present tense.
- Commands in backticks: `pocket start`. Config keys as `key = value` with the default value:
  `session_minutes = 25`.
- Every page is linked from `docs/index.md` as `- [Title](page.md): what it covers.`
  Link to sections with `page.md#section-slug`.
- Facts must agree across pages: sessions last 25 minutes, breaks 5, history lives in
  `~/.pocket/history.jsonl`, and Pocket Timer never connects to the internet. Don't invent commands or
  keys that contradict an existing page.
- No external links: the docs ship offline. Only a human adds URLs to `docs/allowed-links.txt`.

## What you must not change
- Only the paths in SCOPE (factory.conf, today `docs/`) may change. Any other changed file stops the run
  with `VERDICT: REJECT`.
- Never edit `factory.sh`, `factory.conf`, `doctor.sh`, `AGENTS.md`, `.gitignore`, `lib/`, `gates/`,
  `dashboard/`, `.claude/`, `tools/` or `docs/allowed-links.txt`.
- Don't rename or delete existing pages or headings unless the plan says so: other pages link to them.
- Each phase writes only its own files: planner `.factory/plan.md`; builder the pages the plan names
  plus `.factory/build.md`; checker `.factory/report.md` (and link fixes in planned pages only);
  reviewer `.factory/review.md`, whose last line is exactly `VERDICT: APPROVE` or `VERDICT: REJECT`.
