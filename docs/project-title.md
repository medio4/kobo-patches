# Project: Title

Library/home-screen plugin by joshuacant, used instead of Simple UI.
Repo: https://github.com/joshuacant/ProjectTitle

## Installed

- Version: v3.8.3 (`ProjectTitle-2026-07-01-v3-8-3.zip`, sha256 `c407d3432190c982dda52c99d6e51f89f004203ed7d8935cd27bf8f51c0701d3`)
- Supports KOReader 2026.07, 2026.07.01 and 2026.07.02. The device runs v2026.07.2.
- Location: `.adds/koreader/plugins/projecttitle.koplugin`
- `coverbrowser` is in `plugins_disabled`. Project: Title refuses to load while Cover Browser is enabled.

## Updating KOReader

Each Project: Title release only loads on the KOReader versions it lists. If KOReader is updated to a version it doesn't list, it shows an "Unsupported" message and does nothing (it doesn't crash). Check the releases page for a matching Project: Title version **before** updating KOReader.

## First run

All books are rescanned (it keeps its own cache, `settings/PT_bookinfo_cache.sqlite3`). To do it in one go: home screen > menu icon (top right) > "Extract and cache book information", with the Kobo plugged in to charge.

## Undo

- Disable: Plugin management > uncheck Project: Title, check Cover browser, restart.
- Remove: delete `plugins/projecttitle.koplugin`, remove `["coverbrowser"] = true` from `plugins_disabled` in `settings.reader.lua`.
