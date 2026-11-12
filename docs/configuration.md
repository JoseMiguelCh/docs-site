# Configuration

Pocket Timer reads `~/.pocket.toml` when it starts. Every key is optional.

## Session length

`session_minutes = 25` sets how long a [session](glossary.md#session) runs with `pocket start`. Values from 5 to 120 are accepted.

## Sounds

`sound = "bell"` picks the sound at the end of a session: `bell`, `chime` or `none`.

## Daily goal

`daily_goal = 8` is how many sessions make a full day (see [daily goal](glossary.md#daily-goal) in the glossary). `pocket today` shows your progress toward it.

Back to [the index](index.md).
