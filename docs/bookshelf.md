# Bookshelf

Home-screen plugin by AndyHazz, used instead of Simple UI and Project: Title.
Repo: https://github.com/AndyHazz/bookshelf.koplugin · Guide: https://andyhazz.github.io/bookshelf-docs/

## Installed

- Version: v6.0.4 (`bookshelf.koplugin.zip`, sha256 `b8ac73bb09dbf202062b721f9d137a0961f2474281bdd8070ca0b070772a8ba6`)
- Needs KOReader v2025.08 or newer (device: v2026.07.2). Updates install from inside KOReader: Bookshelf > Updates.
- Location: `.adds/koreader/plugins/bookshelf.koplugin`
- Needs Cover Browser **enabled**, so `projecttitle` is in `plugins_disabled` instead (Project: Title refuses to run alongside Cover Browser).

## Why Bookshelf over Simple UI

From the 2026-10-27 run of https://github.com/d1-m4ss/kindle_benchmark (emulator, KOReader v2026.07.2): Bookshelf is close to stock KOReader in startup and memory (+5–6 MiB heap); Simple UI is the heaviest tested (66–86 MiB heap, ~8x stock time to close a book). Bookshelf's own shelf pages faster with its page animation turned off.

Night mode is on on this device, which is the likely trigger of the Simple UI crash (`BB_invert_blit_from` with a colour image). Bookshelf has explicit night-mode and B&W handling.

## Setting it as the start screen

`start_with` was left as `filemanager` for the first boot, so a crash can't loop. Once Bookshelf works, set it from the file browser menu, first tab > Start with > bookshelf.

## Undo

- Back to Project: Title: disable Bookshelf and Cover browser, enable Project: Title in Plugin management, restart. (Or restore `settings.reader.lua.pre-bookshelf` on the device.)
- If KOReader won't start: add `["bookshelf"] = true` to `plugins_disabled` and set `start_with` to `"filemanager"` in `settings.reader.lua` over USB.
