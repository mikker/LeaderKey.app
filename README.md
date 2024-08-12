# Leader Key

<img src="https://s3.brnbw.com/icon_512px-512pt-1x-GmtXn5P12OuOxLVY6j7zlps9phhTyicDXIOMnQxAU6dcZ0mgz1CODS2gZOS8HCO3M1KXx8XV2Idc7kFMw3a20yo9xding8bmfF0r.png" width="256" height="256" alt="Leader Key.app" />

**Leader Key is a riff on @raycastapp, @mxstbr's multi-key Karabiner setup, and Vim's `<leader>` key.**

<video src="https://s3.brnbw.com/esavJinFLbAyivBA-ARptueHMEB1zizywvQHqcAoC8SeblkqOwVyWO2oZda9uoAKdzXKCXV71PxqC9ZI6Eg8wQLzTjjhmytzfGi1sy8wts2lMe2bgs5ZP.mp4">

## Why Leader Key?

### Problems with traditional launchers:

1. Typing the name of the thing can be slow and give unpredictable results.
2. Global shortcuts have limited combinations.
3. Leader Key offers predictable, nested shortcuts -- like combos in a fighting game.

### Example Shortcuts:

- `[leader][o][m]` → Launch Messages (`open messages`)
- `[leader][m][m]` → Mute audio (`media mute`)
- `[leader][w][m]` → Maximize current window (`window maximize`)

## Example Configuration

FWIW, here's a recent version of my own config:

```json
{
  "type": "group",
  "actions": [
    { "key": "t", "type": "application", "value": "/Applications/WezTerm.app" },
    {
      "key": "o",
      "type": "group",
      "actions": [
        {
          "key": "1",
          "type": "application",
          "value": "/Applications/1password.app"
        },
        { "key": "a", "type": "application", "value": "/Applications/Arc.app" },
        {
          "key": "c",
          "type": "application",
          "value": "/Applications/Google Chrome.app"
        },
        {
          "key": "s",
          "type": "application",
          "value": "/Applications/Safari.app"
        },
        {
          "key": "e",
          "type": "application",
          "value": "/System/Applications/Mail.app"
        },
        {
          "key": "z",
          "type": "application",
          "value": "/Applications/Slack.app"
        },
        {
          "key": "i",
          "type": "application",
          "value": "/System/Applications/Music.app"
        },
        {
          "key": "n",
          "type": "application",
          "value": "/Applications/Notion.app"
        },
        {
          "key": "t",
          "type": "application",
          "value": "/Applications/WezTerm.app"
        },
        {
          "key": "m",
          "type": "application",
          "value": "/System/Applications/Messages.app"
        },
        {
          "key": "o",
          "type": "application",
          "value": "/Applications/Obsidian.app"
        }
      ]
    },
    {
      "key": "r",
      "type": "group",
      "actions": [
        {
          "key": "e",
          "type": "url",
          "value": "raycast://extensions/raycast/emoji-symbols/search-emoji-symbols"
        },
        { "key": "p", "type": "url", "value": "raycast://confetti" },
        {
          "key": "c",
          "type": "url",
          "value": "raycast://extensions/raycast/system/open-camera"
        },
        {
          "key": "v",
          "type": "url",
          "value": "raycast://extensions/raycast/clipboard-history/clipboard-history"
        }
      ]
    },
    {
      "key": "s",
      "type": "group",
      "actions": [
        {
          "key": "l",
          "type": "url",
          "value": "raycast://extensions/raycast/system/lock-screen"
        },
        {
          "key": "s",
          "type": "url",
          "value": "raycast://extensions/raycast/system/sleep"
        },
        {
          "key": "a",
          "type": "application",
          "value": "/Users/mikker/Applications/DarkMode.app"
        }
      ]
    },
    {
      "key": "w",
      "type": "group",
      "actions": [
        {
          "key": "f",
          "type": "url",
          "value": "raycast://extensions/raycast/window-management/maximize"
        },
        {
          "key": "h",
          "type": "url",
          "value": "raycast://extensions/raycast/window-management/left-half"
        },
        {
          "key": "l",
          "type": "url",
          "value": "raycast://extensions/raycast/window-management/right-half"
        },
        {
          "key": "o",
          "type": "url",
          "value": "raycast://extensions/raycast/window-management/last-two-thirds"
        },
        {
          "key": "n",
          "type": "url",
          "value": "raycast://extensions/raycast/window-management/first-third"
        },
        {
          "key": "-",
          "type": "url",
          "value": "raycast://extensions/raycast/window-management/center"
        },
        {
          "key": "=",
          "type": "url",
          "value": "raycast://extensions/raycast/window-management/maximize-height"
        }
      ]
    }
  ]
}
```

## License

MIT
