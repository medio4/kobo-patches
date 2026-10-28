# kobo-patches

Config, patches and notes for getting Simple UI running on my Kobo without lag or crashes.

## Device

Fill these in from **Settings > Device information** on the Kobo:

| | |
|---|---|
| Model | Kobo Clara BW |
| Firmware version | 4.46.23836 |
| KOReader version | v2026.07.2 |
| Library UI | Bookshelf v6.0.4 (Project: Title v3.8.3 and Simple UI 3.0.1 installed but disabled) |
| Other mods installed | Storefront, Readest, Rakuyomi, X-Ray, FilebrowserPlus (web file transfer) and others |

## Layout

```
config/    Files copied onto the Kobo (mirrors the device's folder layout)
patches/   Patch files, one per change, each with a note on what it fixes
docs/      Troubleshooting notes and install steps
```

`config/` mirrors the root of the Kobo's USB drive, so `config/.adds/...` goes to `KOBOeReader/.adds/...` on the device.

## Before changing anything

1. Connect the Kobo over USB and back up the hidden `.kobo` and `.adds` folders to your computer.
2. Write down the firmware version. Mods are often tied to a specific firmware, and an automatic firmware update can break them.

## Known issues

| Problem | Status | Notes |
|---|---|---|
| Simple UI lags | Replaced | Switched to Bookshelf. See [docs/bookshelf.md](docs/bookshelf.md) |
| Simple UI crashes | Worked around | Onboarding screen crashes on B&W screen; plugin disabled. See [docs/simpleui-onboarding-crash.md](docs/simpleui-onboarding-crash.md) |
| Kobo not showing up on Mac in stock firmware | Investigating | |

## Changelog

Record every change made to the device here, with the date, so a bad change can be traced and undone.

- 2026-10-27: Repo created.
- 2026-10-27: KOReader crash-looping after Simple UI install. Disabled `simpleui` plugin and set `start_with` back to `filemanager` in `settings.reader.lua`. Config snapshot added under `config/` (tokens redacted; `network.lua` and `kosync.lua` left out).
- 2026-10-27: Installed Project: Title v3.8.3 (for KOReader 2026.07.x) into `plugins/projecttitle.koplugin`. Disabled `coverbrowser` (required by Project: Title). Removed empty `Swipe_Animation.koplugin` folder. Settings backed up on device as `settings.reader.lua.pre-projecttitle`.
- 2026-10-27: Switched from Project: Title to Bookshelf v6.0.4 (`plugins/bookshelf.koplugin`). Disabled `projecttitle`, re-enabled `coverbrowser` (Bookshelf needs it). `start_with` left as `filemanager` for the first boot. Settings backed up on device as `settings.reader.lua.pre-bookshelf`.
- 2026-10-27: Added three minimal Bookshelf packs (Minimal, Minimal Grey, Smooth planks) to `settings/bookshelf/ornaments/`. Flat, shadowless planks instead of the wood texture. See docs/bookshelf.md.
- 2026-10-27: Added three art Bookshelf packs (Botanical, Library, Night Sky) to `settings/bookshelf/ornaments/`, with CC0 Cleveland Museum of Art prints and flat planks. See docs/bookshelf.md.
