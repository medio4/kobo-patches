# kobo-patches

Config, patches and notes for getting Simple UI running on my Kobo without lag or crashes.

## Device

Fill these in from **Settings > Device information** on the Kobo:

| | |
|---|---|
| Model | _TBD_ |
| Firmware version | _TBD_ |
| Simple UI version | _TBD_ |
| Other mods installed | _TBD_ |

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
| Simple UI lags | Investigating | |
| Simple UI crashes | Investigating | |
| Kobo not showing up on Mac in stock firmware | Investigating | |

## Changelog

Record every change made to the device here, with the date, so a bad change can be traced and undone.

- 2026-10-27: Repo created.
