# Soldo GUI Library

A modern GUI library for Roblox executors, written in Luau.

- **Author:** Soldo (Discord: `cyber_modz`)
- **Version:** 2.1.0

---

## Loading

```lua
local GuiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/SoldoxD/libery/refs/heads/main/main"))()
```

---

## Quick Start

```lua
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
| `iconAsset` | `number` \| `string` | `nil` | Roblox asset ID (or `rbxassetid://...`) shown left of the title |

### Window methods

| Method | Description |
|---|---|
| `window.Show()` | Show the window with animation |
| `window.Hide()` | Hide the window with animation |
| `window.Toggle()` | Toggle visibility |
| `window.SetTitle(text)` | Change title at runtime |
| `window.SetIcon(asset)` | Change icon at runtime (pass `nil` to remove) |
| `window.SwitchTab(name)` | Switch to a tab by name (with slide animation) |

### Title bar

- **Window icon** (if provided)
- **Title text**
- **FPS counter** (toggle in Settings)
- **⚙ Settings button** — opens the built-in Settings tab
- **✕ Close button** — destroys the GUI and disconnects all input listeners

The window is **draggable from the title bar** and **resizable from the bottom-right grip handle**. Both position and size persist with auto-save.

---

## Tabs

```lua
local tab = GuiLibrary:CreateTab(window, "Tab Name")
```

- The first tab created is selected automatically.
- Tabs slide in/out horizontally when switching.
- If too many tabs to fit, the tab bar scrolls horizontally (mouse wheel).

---

## Components

All components are added to a tab and stacked vertically in the order they're created.

### Button

```lua
GuiLibrary:CreateButton(tab, "Label", function()
    -- clicked
end)
```

### Toggle

```lua
local toggle = GuiLibrary:CreateToggle(tab, "Label", default, function(state)
    -- state: boolean
end)

toggle.GetValue()       -- returns current boolean
toggle.SetValue(true)   -- updates visual + fires callback
```

### Slider

```lua
local slider = GuiLibrary:CreateSlider(tab, "Label", min, max, default, function(value)
    -- value: number, clamped to [min, max]
end)

slider.GetValue()       -- returns current number
slider.SetValue(50)     -- updates visual + fires callback + saves (if auto-save on)
```

Saves only happen on **drag-end** (not every frame during a drag), keeping disk writes minimal.

### Dropdown

```lua
local dropdown = GuiLibrary:CreateDropdown(tab, "Label", {"A", "B", "C"}, function(selected)
    -- selected: string
end)

dropdown.GetValue()                            -- current selection
dropdown.SetValue("B")                         -- select an option
dropdown.UpdateOptions(newList, keepSelection) -- replace the option list at runtime
```

**`UpdateOptions(newList, keepSelection)`**
- `keepSelection = true` keeps the current selection if it still exists in `newList`; otherwise resets to first.
- `keepSelection = false` always resets to the first option and fires the callback.

The list pops up as a floating, scrollable panel parented to the main frame, so it never gets clipped by the tab content.

#### Live player list example

```lua
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    return #names > 0 and names or {"(no players)"}
end

local target = GuiLibrary:CreateDropdown(tab, "Target", getPlayerNames(), function(name)
    print("Target:", name)
end)

Players.PlayerAdded:Connect(function() target.UpdateOptions(getPlayerNames(), true) end)
Players.PlayerRemoving:Connect(function() target.UpdateOptions(getPlayerNames(), true) end)
```

### Label

```lua
GuiLibrary:CreateLabel(tab, "Some informational text")
```

### Section

A styled header used to visually group elements.

```lua
GuiLibrary:CreateSection(tab, "Movement")
```

### Input

Callback fires when the user presses **Enter** or unfocuses the box.

```lua
local input = GuiLibrary:CreateInput(tab, "Placeholder", function(text)
    -- text: string (only on Enter)
end)

input.GetValue()  -- current text
input.TextBox     -- direct access to the underlying TextBox instance
```

### Color Picker

```lua
local picker = GuiLibrary:CreateColorPicker(tab, "Label", Color3.fromRGB(255,80,80), function(color)
    -- color: Color3
end)

picker.GetValue()                         -- current Color3
picker.SetColor(Color3.fromRGB(0,255,0))  -- set programmatically
```

- Click the swatch to open the picker; click the X (or swatch again) to close.
- Pick from the SV square + hue strip, or type RGB values directly.
- The popup expands inline within the picker frame and lays out properly with surrounding components.

### Keybind

```lua
local kb = GuiLibrary:CreateKeybind(tab, "Label", Enum.KeyCode.Insert, function()
    -- the bound key was pressed in-game
end)

kb.GetKey()       -- current Enum.KeyCode (or nil)
kb.SetKey("F")    -- set by KeyCode name string
```

Click the button to enter listening mode, then press any key to bind it.

### Notification

```lua
GuiLibrary:CreateNotification(title, message, duration, type)
-- type: "info" | "success" | "warning" | "error"
-- duration in seconds (default = GuiLibrary.NotificationDuration, default 3)
```

```lua
GuiLibrary:CreateNotification("Saved", "Config saved successfully!", 2, "success")
```

**Stacking:** new notifications appear *below* existing ones. When one expires, the others slide up to fill its slot. Each notification has its own ScreenGui (independent layering).

Notifications can be globally disabled via the Settings → "Notifications" toggle, or directly:

```lua
GuiLibrary.NotificationsEnabled = false  -- mute all notifications
GuiLibrary.NotificationDuration = 5      -- default duration in seconds
```

---

## Built-in Settings Tab

Every window gets a Settings tab automatically (open with ⚙).

### Library

| Setting | Description |
|---|---|
| Toggle GUI | Keybind to show/hide the window (default: Insert) |
| Theme | Dark, Light, Midnight, Forest, Ocean |

### Preferences

| Setting | Description |
|---|---|
| Auto Save Config | Auto-save changes per-game (see [Auto-Save](#auto-save-system)) |
| Enable Animations | Master toggle for all UI tweens |
| Show FPS | FPS counter in the title bar |
| Notifications | Master enable/disable for notifications |
| Lock Window Position | Disables dragging |
| Notification Duration | Default duration (1–10 sec) for new notifications |

### Window

| Setting | Description |
|---|---|
| Center Window | Re-center the window on screen |
| Reset Window Size | Restore default 600 × 400 |

### Actions

| Setting | Description |
|---|---|
| Save Config Now | Force-write the config file immediately |
| Clear Save File | Delete the saved config (recovery from a corrupted save) |
| Reset Settings | Revert all built-in settings to defaults |

---

## Auto-Save System

The library writes per-game configs to:

```
GuiLibrary_AutoSaves/<PlaceId>.json
```

### What gets saved

- **All widget values** — toggles, sliders, dropdowns, color pickers, inputs, keybinds.
- **Window state** — size, position.
- **UI preferences** — theme, animations, show FPS, notifications enabled, notification duration, lock position.
- **`AutoSaveEnabled`** — the toggle's own state.

### Behavior

- **`Auto Save Config = ON`** — every widget change is auto-saved immediately. On next session, every saved value is restored.
- **`Auto Save Config = OFF`** — no auto-saves on change. The previously saved file (if any) is still **read and applied** on next load — auto-save only controls *writing*. Use `Save Config Now` for a one-shot manual save.
- **No file present** — defaults are used.

### Restore order

1. Window size and position are applied before the open animation, so the window opens at exactly the size/position you last left it.
2. Built-in Settings widgets restore from the file.
3. User-created widgets check the restoration queue in their constructor and apply their saved value as they're created.

### Manual control

```lua
GuiLibrary:SaveConfig(window, true)   -- force-save right now (ignores auto-save flag)
GuiLibrary.LoadConfig(window)          -- read file and apply (note: dot, not colon)
GuiLibrary:TestFileSaving()           -- quick check: does this executor support file I/O?
```

> ⚠ **Important:** `LoadConfig` is a plain function (no implicit `self`). Always call it as `GuiLibrary.LoadConfig(window)` with a **dot**. Calling it with `:` will pass the wrong argument and silently break restoration.

---

## Themes

| Name | Description |
|---|---|
| Dark | Default — dark grey with purple accent |
| Light | White background, blue accent |
| Midnight | Near-black with muted purple |
| Forest | Dark green palette |
| Ocean | Dark teal/blue palette |

Themes are applied to **every** UI element, including dropdown popups and color picker chrome. Switch via Settings → Theme.

---

## Debug Output

Set this any time after loading the library to see save/load activity, restoration steps, and component creation in the output window:

```lua
local GuiLibrary = loadstring(game:HttpGet("..."))()
GuiLibrary.debugPrints = true
```

Off by default.

---

## API Reference

### Window
```lua
GuiLibrary:CreateWindow(title, size, iconAsset)  -- → window
window.Show()
window.Hide()
window.Toggle()
window.SwitchTab(name)
window.SetTitle(text)
window.SetIcon(asset)
```

### Tabs
```lua
GuiLibrary:CreateTab(window, name)               -- → tab
```

### Components
```lua
GuiLibrary:CreateButton(tab, text, callback)
GuiLibrary:CreateToggle(tab, text, default, callback)         -- → { GetValue, SetValue, Frame }
GuiLibrary:CreateSlider(tab, text, min, max, default, callback) -- → { GetValue, SetValue, Frame }
GuiLibrary:CreateDropdown(tab, text, options, callback)       -- → { GetValue, SetValue, UpdateOptions, Frame }
GuiLibrary:CreateLabel(tab, text)
GuiLibrary:CreateSection(tab, title)
GuiLibrary:CreateInput(tab, placeholder, callback)            -- → { GetValue, TextBox, Frame }
GuiLibrary:CreateColorPicker(tab, text, defaultColor, callback) -- → { GetValue, SetColor, Frame }
GuiLibrary:CreateKeybind(tab, text, defaultKey, callback)     -- → { GetKey, SetKey, Frame }
GuiLibrary:CreateNotification(title, message, duration, type)
```

### Config
```lua
GuiLibrary:SaveConfig(window, force)
GuiLibrary.LoadConfig(window)         -- (call with dot, not colon)
GuiLibrary:TestFileSaving()           -- → boolean
```

### Globals
```lua
GuiLibrary.debugPrints           -- boolean, default false
GuiLibrary.NotificationsEnabled  -- boolean, default true
GuiLibrary.NotificationDuration  -- number (seconds), default 3
GuiLibrary.CurrentWindow         -- the most recently created window
```

---

## Changelog

### 2.1.0
- **Auto-save fully overhauled** — saves now include window position, size, theme, animations, FPS visibility, notification preferences, lock position, and the auto-save flag itself.
- **Restoration decoupled from auto-save flag** — if a save file exists, settings are restored regardless of whether auto-save is currently on.
- Added window icons and `SetIcon` / `SetTitle`.
- Added tab slide animations and horizontal tab bar scrolling.
- Added stacked notifications with reflow on dismiss.
- Added Settings: Notifications toggle, Lock Window Position, Notification Duration, Center Window, Reset Window Size, Clear Save File.
- Removed UI Scale slider (use the bottom-right resize grip).
- Fixed dragging (was offset by GuiInset).
- Fixed color picker swatch being hidden under its own popup.
- Fixed slider value occasionally reverting to default after reload (saves now coalesce to drag-end).
- Fixed themes not applying to dropdown popups.

### 2.0.0
- Initial public release.

---

## Contact

Discord: **cyber_modz**
