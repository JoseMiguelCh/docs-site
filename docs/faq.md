# FAQ

## Does Pocket Timer need the internet?

No. It never connects to anything.

## Where is my history stored?

In `~/.pocket/history.jsonl`, one line per session or break. Delete the file to start over.

## How is my streak calculated?

Pocket Timer reads `~/.pocket/history.jsonl` and counts the consecutive days, ending today, with at
least one completed session. Breaks don't count. If you missed yesterday and have no session today,
the streak is 0 and starts again with your next session.

The calculation happens on your machine, with no internet. Deleting the history file resets your
streak. See [Your streak](getting-started.md#your-streak) for where it appears.

## Can I change the length of a break?

Yes: `break_minutes = 5` in the [configuration](configuration.md#session-length) file.
