# Simple UI 3.0.1 crashes KOReader on first launch

**Date:** 2026-10-27
**Device:** Kobo Clara BW (FW 4.46.23836)
**Simple UI:** 3.0.1, installed through the Storefront plugin

## Symptom

After installing Simple UI, KOReader crashed on every launch. After 5 crashes in a row it printed "Too many consecutive crashes, aborting" and dropped back to Nickel.

## Cause

From `.adds/koreader/crash.log` (full excerpt in `crash-logs/2026-10-27-simpleui-onboarding.log`):

```
simpleui[diag]: Onboarding.show called
BB_invert_blit_from: incompatible bb (dst: BB8, src: BBRGB32) in file blitbuffer.c, line 2762!
Uh oh, something went awry... (Crash n°5: 10/27/26 @ 18:16:20)
```

Simple UI's first-run onboarding screen inverts a 32-bit colour image onto the Clara BW's 8-bit greyscale framebuffer, which crashes KOReader's blitbuffer. The install also set `start_with = "homescreen_simpleui"`, so the onboarding screen was shown on every start, and every start crashed.

## Fix applied

Edited `.adds/koreader/settings.reader.lua` on the device over USB:

```lua
["plugins_disabled"] = {
    ["filebrowser"] = true,
    ["simpleui"] = true,          -- added
},
...
["start_with"] = "filemanager",   -- was "homescreen_simpleui"
```

The original was saved on the device as `settings.reader.lua.pre-unbrick` (redacted copy in this folder).

## Re-enabling Simple UI

The plugin is still installed, only disabled. If it's turned back on, the onboarding screen will probably crash again. Options to try:

1. Wait for a fix upstream (https://github.com/doctorhetfield-cmd/simpleui.koplugin) and report the crash there with the log excerpt.
2. Skip onboarding by adding `["simpleui_onboarding_done"] = true` to Simple UI's settings before enabling it. Untested: the home screen may hit the same colour-image problem elsewhere.

Before trying either, make sure you can undo it: the same two edits above get KOReader booting again.
