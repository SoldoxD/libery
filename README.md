# Soldo GUI Library

A modern GUI library for Roblox executors, written in Luau.

- **Author:** Soldo (Discord: `cyber_modz`)
- **Version:** 2.4.0

---

## Loading

```lua
local GuiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/SoldoxD/libery/refs/heads/main/main"))()
```

---

## Quick Start

```lua
local GuiLibrary = loadstring(game:HttpGet("[...](https://raw.githubusercontent.com/SoldoxD/libery/refs/heads/main/main)"))()

GuiLibrary.Icon = 105049082124083  -- optional default icon for every window

local window = GuiLibrary:CreateWindow("My Script", UDim2.new(0, 620, 0, 420))
local tab    = GuiLibrary:CreateTab(window, "Main")

GuiLibrary:CreateToggle(tab, "God Mode", false, function(state)
    print("God Mode:", state)
end)

GuiLibrary:CreateSlider(tab, "Walk Speed", 1, 200, 16, function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)
```

A complete reference script demonstrating every component is in **`Example.lua`**.

---

## Window

```lua
local window = GuiLibrary:CreateWindow(title, size, iconAsset)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `string` | `"GUI Library"` | Title bar text |
| `size` | `UDim2` | `UDim2.new(0, 600, 0, 400)` | Initial window size |
| `iconAsset` | `number` \| `string` | `nil` | Asset ID shown at the left of the title bar |

If `iconAsset` is omitted, `GuiLibrary.Icon` is used as a fallback.

### Window methods

| Method | Description |
|---|---|
| `window.Show()` | Show with animation |
| `window.Hide()` | Hide with animation |
| `window.Toggle()` | Toggle visibility |
| `window.Minimize()` | Collapse the window to just its title bar |
| `window.Restore()` | Expand a minimized window back to full size |
| `window.ToggleMinimize()` | Toggle minimized/restored (same as the title-bar — button) |
| `window.SetTitle(text)` | Change title at runtime |
| `window.SetIcon(asset)` | Change icon at runtime (`nil`/`false`/`0` removes it) |
| `window.SwitchTab(name)` | Switch to a tab by name |

### Title bar layout

```
[ icon ] [ title text ]               [ FPS ] [ ⚙ ] [ X ]
```

The window is **draggable** from the title bar and **resizable** from the bottom-right grip. Both position and size persist with auto-save.

---

## Tabs

```lua
local tab = GuiLibrary:CreateTab(window, "Tab Name")
```

- First tab is selected automatically.
- Active tab gets a 2 px accent underline + bold text; inactive tabs are plain text labels.
- Switching tabs closes any open dropdown / multi-select list.
- If too many tabs to fit, the bar scrolls horizontally (mouse wheel or drag).

---

## Core Components

All components are added to a tab and stacked vertically in creation order.

### Button

```lua
local btn = GuiLibrary:CreateButton(tab, "Label", function() end)

btn.SetText("New label")
btn.SetCallback(function() end)
btn.SetVisible(false)
btn.GetText()
btn.Instance
```

### Toggle

```lua
local t = GuiLibrary:CreateToggle(tab, "Label", default, function(state) end)
t.GetValue() ; t.SetValue(true)
```

### Slider

```lua
local s = GuiLibrary:CreateSlider(tab, "Label", min, max, default, function(value) end)
s.GetValue() ; s.SetValue(50)
```

### Dropdown

```lua
local d = GuiLibrary:CreateDropdown(tab, "Label", {"A","B","C"}, function(selected) end)
d.GetValue() ; d.SetValue("B")
d.UpdateOptions(newList, keepSelection)
```

### Label

```lua
local l = GuiLibrary:CreateLabel(tab, "Bag: $0")
l.SetText("Bag: $25,000")
l.SetColor(Color3.fromRGB(0,255,0))
l.SetVisible(false)
-- All setters chainable:
l.SetText("Done").SetColor(Color3.fromRGB(74,222,128))
```

### Section

```lua
local sec = GuiLibrary:CreateSection(tab, "Movement")
sec.SetText("Player Settings")
```

### Input

Fires on **Enter** or focus loss. Use `CreateTextbox` (below) for live typing.

```lua
local i = GuiLibrary:CreateInput(tab, "Placeholder", function(text) end)
i.GetValue() ; i.TextBox
```

### Color Picker

Callback fires with `(color, transparency)` — second arg is optional but always passed.

```lua
local cp = GuiLibrary:CreateColorPicker(tab, "Trail",
    Color3.fromRGB(255,80,80),
    function(color, transparency)
        part.Color = color
        part.Transparency = transparency
    end)

cp.GetValue()                                      -- → Color3
cp.GetTransparency()                                -- → 0..1
cp.SetColor(Color3.fromRGB(0,255,0))                -- color only
cp.SetColor(Color3.fromRGB(0,255,0), 0.5)           -- color + transparency
cp.SetTransparency(0.5)
```

A vertical alpha strip lives at the right of the popup (gray base, top = opaque, bottom = transparent).

### Keybind (mouse-aware)

Accepts `Enum.KeyCode` *or* `Enum.UserInputType.MouseButton1/2/3`. Press **Escape / Backspace / Delete** while listening to clear the binding.

```lua
local k = GuiLibrary:CreateKeybind(tab, "Aim Key", Enum.KeyCode.E, function()
    -- bound key OR mouse button pressed
end)

-- Mouse-button default:
GuiLibrary:CreateKeybind(tab, "Snap Aim", Enum.UserInputType.MouseButton2, function() end)

k.GetKey()      -- → Enum.KeyCode for key binds; nil for mouse binds
k.GetBind()     -- → {type="key"|"mouse", value=...} or nil
k.SetKey(v)     -- accepts EnumItem, KeyCode name string, "MB1"/"MB2"/"MB3", or nil
```

### Notification

```lua
GuiLibrary:CreateNotification(title, message, duration, type)
-- type: "info" | "success" | "warning" | "error"
```

Stacked, reflow on dismiss. Globally toggle with `GuiLibrary.NotificationsEnabled = false`.

---

## New Components (v2.3)

### Textbox — labeled text input, validation, live mode

```lua
local tb = GuiLibrary:CreateTextbox(tab, "Hex Color", "#FF6B6B",
    function(text)
        -- called on commit (or every keystroke if opts.live = true)
        -- return false to reject
        if not text:match("^#%x%x%x%x%x%x$") then return false end
        applyColor(text)
    end, {
        live = true,                 -- fire onChange on every keystroke
        validate = function(text)    -- separate validator (return false to reject)
            return text:match("^#%x%x%x%x%x%x$") ~= nil
        end,
        placeholder = "#RRGGBB",
        password = false,
    })

tb.GetValue() ; tb.SetValue("#000000")
tb.TextBox  -- direct access
```

Use for: target names, blacklists, hex color input, regex filters — anywhere `CreateInput`'s Enter-only commit is awkward.

### MultiSelect — dropdown returning a set

```lua
local ms = GuiLibrary:CreateMultiSelect(tab, "Aim Only On",
    {"Red","Blue","Green","Yellow","Neutral"},
    {"Red","Blue"},                         -- defaults
    function(set)
        for name,_ in pairs(set) do print(name) end
    end)

ms.GetValue()                  -- → { Red=true, Blue=true }
ms.SetValue({Green=true})      -- replace selection
ms.UpdateOptions(newOpts, keepSelection)
```

Clicking an option toggles a check; the list stays open. Closes on tab-switch.

### Search — live-filtered list

```lua
GuiLibrary:CreateSearch(tab, "Type a name...",
    function(query)
        -- Called every keystroke; return any list of strings or objects-with-.Name
        local names = {}
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer then table.insert(names, p.Name) end
        end
        return names
    end,
    function(item)
        -- Called when the user clicks a row
        print("Picked:", item)
    end)
```

### ProgressBar — live 0..1 readout

```lua
GuiLibrary:CreateProgressBar(tab, "Your Health", function()
    return Humanoid.Health / Humanoid.MaxHealth
end, {interval = 0.1})  -- poll every 0.1 s (default)
```

### Gauge — live readout with explicit min/max + format

```lua
GuiLibrary:CreateGauge(tab, "Ping (ms)", 0, 500, function()
    return LocalPlayer:GetNetworkPing() * 1000
end, {format = "%.0f ms", interval = 0.5})
```

### PlayerList — auto-populated player roster

```lua
GuiLibrary:CreatePlayerList(tab, function(player)
    print("Picked:", player.Name)
end, {maxRows = 6, includeLocal = false})
```

Rebuilds on `PlayerAdded` / `PlayerRemoving`. Each row shows the avatar headshot + display name.

### BindGroup — multi-row hotkey list in one widget

```lua
GuiLibrary:CreateBindGroup(tab, "Quick Actions", {
    {label="Toggle Fly",  default=Enum.KeyCode.F,                  callback=function() end},
    {label="Snap Aim",    default=Enum.UserInputType.MouseButton2, callback=function() end},
    {label="Reset HP",    default=Enum.KeyCode.H,                  callback=function() end},
})
```

Each row is a fully-functional keybind (mouse-aware). The whole group saves and restores as one record.

### ColorGradient — multi-stop ColorSequence editor

```lua
GuiLibrary:CreateColorGradient(tab, "HP Bar Gradient",
    {Color3.fromRGB(255,80,80), Color3.fromRGB(74,222,128)},
    function(colorSequence)
        -- colorSequence is a Roblox ColorSequence you can assign to UIGradient.Color
        hpBarGradient.Color = colorSequence
    end)
```

Click a swatch to cycle through built-in presets. Auto-saved.

### Modal — blocking confirmation overlay

```lua
GuiLibrary:CreateModal("Delete profile?",
    "This cannot be undone.",
    {
        {text="Cancel", style="ghost"},
        {text="Delete", style="danger", callback=function()
            -- perform destructive action
        end},
    })
```

Button styles: `"primary"` (default), `"danger"`, `"ghost"`. Click the backdrop to dismiss.

Wrap destructive actions (reset, clear save, server hop) so misclicks don't fire them.

### Profiles (built into the Settings tab)

The `CreateProfile` widget has been **removed**. Profile management lives in the **Settings tab** instead (open with ⚙). Saves are always automatic to the active profile — there is no longer an "Auto Save Config" toggle.

The Settings tab exposes:

- **Active Profile** dropdown — switch profiles; switching reloads all widget values from the chosen profile.
- **Profile name** input — used by the next three buttons.
- **New Profile (from input)** — snapshots the current state into a brand-new named profile.
- **Rename Active Profile** — renames the active profile.
- **Delete Active Profile** — modal-confirmed; cannot delete the last remaining profile.
- **Save Now** — force a save snapshot to the active profile.
- **Reset Active Profile** — modal-confirmed; clears the active profile and applies built-in defaults.

#### File layout

```
GuiLibrary_AutoSaves/
└── <PlaceId>/
    ├── _active.txt        ← active profile name pointer
    ├── default.json       ← the default profile
    ├── rage.json          ← additional profiles you create
    └── legit.json
```

Old `GuiLibrary_AutoSaves/<PlaceId>.json` files (from v2.3 and earlier) are automatically migrated to `<PlaceId>/default.json` on first load.

---

## Built-in Settings Tab

Every window gets a Settings tab automatically (open with ⚙).

| Setting | Description |
|---|---|
| Toggle GUI | Keybind to show/hide the window (default: Insert) |
| Theme | Dark, Light, Midnight, Forest, Ocean |
| Enable Animations | Master toggle for all UI tweens |
| Show FPS | FPS counter in the title bar |
| Notifications | Master enable/disable |
| Lock Window Position | Disables dragging |
| Notification Duration | Default duration (1–10 sec) |
| Center Window | Re-center on screen |
| Reset Window Size | Restore default 600 × 400 |
| **Active Profile** | Dropdown — switch between named loadouts |
| **Profile name** | Input — target name for New / Rename |
| **New Profile** | Create a profile from current state |
| **Rename Active Profile** | Rename the currently active profile |
| **Delete Active Profile** | Modal-confirmed deletion |
| **Save Now** | Force-save current state to active profile |
| **Reset Active Profile** | Modal-confirmed; wipe active profile to defaults |

---

## Save System (Profiles)

Saves are **always automatic to the active profile**. There is no "auto-save on/off" toggle — switching to a different profile gives you a different set of values.

### File layout

```
GuiLibrary_AutoSaves/
└── <PlaceId>/
    ├── _active.txt   ← active profile name pointer
    ├── default.json  ← always-present fallback
    └── <name>.json   ← any profiles you create
```

### What gets saved per profile

- All widget values — toggles, sliders, dropdowns, color pickers, inputs, textboxes, multi-selects, bind-groups, color gradients, keybinds.
- Window state — size, position.
- UI preferences — theme, animations, FPS, notifications, notification duration, lock position.

### Migration

If `GuiLibrary_AutoSaves/<PlaceId>.json` exists (from v2.3 and earlier), it's automatically moved to `<PlaceId>/default.json` the first time you load v2.4+.

### Manual control

```lua
GuiLibrary:SaveConfig(window)         -- force a save to the active profile
GuiLibrary.LoadConfig(window)         -- read active profile and apply (dot, not colon!)
GuiLibrary:TestFileSaving()           -- → boolean
```

> ⚠ `LoadConfig` has no implicit `self`. Always call it with a **dot**.

---

## Themes

| Name | Description |
|---|---|
| Dark | Default — dark grey with purple accent |
| Light | White background, blue accent |
| Midnight | Near-black with muted purple |
| Forest | Dark green palette |
| Ocean | Dark teal/blue palette |

---

## API Reference

### Window
```lua
GuiLibrary:CreateWindow(title, size, iconAsset)  -- → window
window.Show() ; window.Hide() ; window.Toggle()
window.Minimize() ; window.Restore() ; window.ToggleMinimize()
window.SwitchTab(name)
window.SetTitle(text) ; window.SetIcon(asset)
```

### Tabs
```lua
GuiLibrary:CreateTab(window, name)  -- → tab
```

### Components
```lua
-- Core
GuiLibrary:CreateButton(tab, text, callback)                    -- → { SetText, SetCallback, SetVisible, GetText, Instance }
GuiLibrary:CreateToggle(tab, text, default, callback)           -- → { GetValue, SetValue, Frame }
GuiLibrary:CreateSlider(tab, text, min, max, default, callback) -- → { GetValue, SetValue, Frame }
GuiLibrary:CreateDropdown(tab, text, options, callback)         -- → { GetValue, SetValue, UpdateOptions, Frame }
GuiLibrary:CreateLabel(tab, text)                               -- → { SetText, GetText, SetColor, SetVisible, Instance }
GuiLibrary:CreateSection(tab, title)                            -- → { SetText, GetText, SetVisible, Instance }
GuiLibrary:CreateInput(tab, placeholder, callback)              -- → { GetValue, TextBox, Frame }
GuiLibrary:CreateColorPicker(tab, text, defaultColor, callback) -- → { GetValue, GetTransparency, SetColor, SetTransparency, Frame }
GuiLibrary:CreateKeybind(tab, text, defaultKey, callback)       -- → { GetKey, GetBind, SetKey, Frame }
GuiLibrary:CreateNotification(title, message, duration, type)

-- v2.3+
GuiLibrary:CreateTextbox(tab, label, default, onChange, opts)   -- → { GetValue, SetValue, TextBox, Frame }
GuiLibrary:CreateMultiSelect(tab, text, options, defaults, cb)  -- → { GetValue, SetValue, UpdateOptions, Frame }
GuiLibrary:CreateSearch(tab, placeholder, getItems, onPick)     -- → { Refresh, GetQuery, SetQuery, Frame }
GuiLibrary:CreateProgressBar(tab, label, getValue, opts)        -- → { Stop, Start, SetGetter, Frame }
GuiLibrary:CreateGauge(tab, label, min, max, getValue, opts)    -- → { Stop, SetGetter, Frame }
GuiLibrary:CreatePlayerList(tab, onPickPlayer, opts)            -- → { Refresh, Frame }
GuiLibrary:CreateBindGroup(tab, title, list)                    -- → { GetBinds, SetBind, Frame }
GuiLibrary:CreateColorGradient(tab, label, defaultStops, cb)    -- → { GetValue, GetTransparencySequence, GetStops, SetStops, Frame }
GuiLibrary:CreateModal(title, body, buttons)                    -- → { Close, ScreenGui }
-- (CreateProfile removed in v2.4 — profile management is built into the Settings tab)
```

### Config
```lua
GuiLibrary:SaveConfig(window, force)
GuiLibrary.LoadConfig(window)         -- dot, not colon
GuiLibrary:TestFileSaving()           -- → boolean
```

### Globals
```lua
GuiLibrary.debugPrints           -- boolean, default false
GuiLibrary.NotificationsEnabled  -- boolean, default true
GuiLibrary.NotificationDuration  -- number (seconds), default 3
GuiLibrary.CurrentWindow         -- most recently created window
GuiLibrary.Icon                  -- number | string | nil — default icon for all windows
```

---

## Changelog

### 2.4.0
- **Profile system replaces auto-save** — saves are always automatic to the active profile. The "Auto Save Config" toggle is gone. Profile management (switch / new / rename / delete / save now / reset) lives in the Settings tab.
- **File layout migrated** — `GuiLibrary_AutoSaves/<PlaceId>.json` → `GuiLibrary_AutoSaves/<PlaceId>/<profile>.json`. Old files are auto-migrated to `default.json` on first load.
- **`CreateProfile` widget removed** — its functionality is now in the Settings tab.
- **`CreateColorGradient`** now opens a full color-picker popup per stop (SV / hue / transparency / RGB / hex). Each stop has its own RGB+alpha. Bottom row of the gradient widget shows the hex + alpha for both stops.
- **`CreateColorPicker`** popup gained an info bar at the bottom showing the current hex code + alpha percentage.

### 2.3.0
- **New widgets**: `CreateTextbox`, `CreateMultiSelect`, `CreateSearch`, `CreateProgressBar`, `CreateGauge`, `CreatePlayerList`, `CreateBindGroup`, `CreateColorGradient`, `CreateModal`, `CreateProfile`.
- **Mouse-aware Keybind** — `CreateKeybind` now accepts `Enum.UserInputType.MouseButton1/2/3`; Escape/Backspace/Delete clears the binding. New `GetBind()` returns a tagged union.
- **`BindGroup`** — collect multiple hotkeys into one widget with one saved record.
- **`Modal`** — blocking confirmation overlay with typed buttons (`primary` / `danger` / `ghost`).
- **`Profile`** — named config-slot management; profiles persisted to `GuiLibrary_AutoSaves/profiles/`.
- Auto-save extended to cover all new widget types.

### 2.2.0
- Title bar redesigned — window icon replaces the old control dots (left-aligned, 32 × 32 with rounded corners).
- Tab bar redesigned — underline indicator on the active tab; transparent inactive tabs.
- Dropdowns close automatically on tab-switch.
- `ColorPicker` gained a vertical transparency strip; callback now fires with `(color, transparency)`.
- Numeric icon IDs use `rbxthumb://` so any asset type renders.
- `GuiLibrary.Icon` global property — set once before `CreateWindow` to apply an icon to every window.

### 2.1.1
- `CreateLabel`, `CreateSection`, `CreateButton` return controller tables with chainable `SetText` / `GetText` / `SetVisible` / `SetCallback` / `SetColor`.

### 2.1.0
- Auto-save overhauled — saves include position, size, theme, all preferences.
- Restoration always runs if a save file exists.
- Added window icons, tab slide animations, horizontal tab-bar scrolling, stacked notifications.
- Settings tab additions: Notifications toggle, Lock Window Position, Notification Duration, Center Window, Reset Window Size, Clear Save File.

### 2.0.0
- Initial public release.

---

## Contact

Discord: **cyber_modz**
