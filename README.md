# Soldo GUI Library

A modern GUI library for Roblox executors, written in Luau.

- **Author**: Soldo (Discord: cyber_modz)
- **Version**: 2.0.0

---

## Loading

```lua
local GuiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/SoldoxD/libery/refs/heads/main/main"))()
```

---

## Quick Start

```lua
local window = GuiLibrary:CreateWindow("My Script")
local tab    = GuiLibrary:CreateTab(window, "Main")

GuiLibrary:CreateToggle(tab, "God Mode", false, function(state)
    -- state is true/false
end)
```

---

## Debug Prints

Set it from your script after loading the library:

```lua
local GuiLibrary = loadstring(game:HttpGet("..."))()
GuiLibrary.debugPrints = true  -- enable verbose output
```

When enabled, every config save/load, restoration step, and component creation logs to the output window.

---

## Auto-Save System

The library saves per-game configs to `GuiLibrary_AutoSaves/<PlaceId>.json`.

**Behaviour on script load:**
1. All elements initialize with the `default` value passed to their constructor.
2. If a save file exists **and** `AutoSaveEnabled` was `true` in that file, the saved values are applied on top.
3. If auto-save was off, defaults are kept — no restoration happens.

Enable it from the **Settings** tab (Auto Save Config toggle), or call:

```lua
GuiLibrary:SaveConfig(window, true)   -- force-save right now
GuiLibrary:LoadConfig(window)         -- load and apply saved config
```

To test whether your executor supports file I/O:

```lua
GuiLibrary:TestFileSaving()
```

---

## Window

```lua
local window = GuiLibrary:CreateWindow(title, size)
-- title  string   default "GUI Library"
-- size   UDim2    default UDim2.new(0, 600, 0, 400)
```

**Methods on the returned window object:**

| Method | Description |
|---|---|
| `window.Show()` | Show the window with animation |
| `window.Hide()` | Hide the window with animation |
| `window.Toggle()` | Toggle visibility |

The title bar includes:
- **⚙️ Settings button** — opens the built-in Settings tab
- **❌ Close button** — destroys the GUI and disconnects all input connections

---

## Tabs

```lua
local tab = GuiLibrary:CreateTab(window, "Tab Name")
```

Tabs appear as buttons at the top of the window. The first tab created is selected automatically.

---

## Components

All components are added to a tab and stacked vertically in order of creation.

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

toggle.GetValue()        -- returns current boolean
toggle.SetValue(true)    -- set programmatically (does NOT fire callback)
```

### Slider

```lua
local slider = GuiLibrary:CreateSlider(tab, "Label", min, max, default, function(value)
    -- value: number, clamped to [min, max]
end)

slider.GetValue()       -- returns current number
slider.SetValue(50)     -- updates visual + fires callback, does NOT auto-save
```

Dragging is handled with direct property assignment (no tween lag).

### Dropdown

```lua
local dropdown = GuiLibrary:CreateDropdown(tab, "Label", {"A", "B", "C"}, function(selected)
    -- selected: string
end)

dropdown.GetValue()            -- returns currently selected string
dropdown.SetValue("B")         -- selects "B" silently if it exists in the list
dropdown.UpdateOptions(list, keepSelection)
```

**`UpdateOptions(newList, keepSelection)`**
- Replaces the option list at runtime without recreating the widget.
- `keepSelection = true` — keeps the current selection if it still exists in `newList`.
- `keepSelection = false` — always resets to the first item and fires the callback.
- If the old selection is no longer in the new list (even with `keepSelection = true`), it resets to the first item and fires the callback.

Useful for live player lists:

```lua
local function getPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    return #names > 0 and names or {"(no players)"}
end

local playerDrop = GuiLibrary:CreateDropdown(tab, "Target", getPlayerNames(), function(name)
    -- name changed
end)

Players.PlayerAdded:Connect(function()
    playerDrop.UpdateOptions(getPlayerNames(), true)
end)
Players.PlayerRemoving:Connect(function()
    playerDrop.UpdateOptions(getPlayerNames(), true)
end)
```

### Label

```lua
GuiLibrary:CreateLabel(tab, "Some text")
```

### Section

A styled header to visually group elements.

```lua
GuiLibrary:CreateSection(tab, "Section Title")
```

### Input

Callback fires when the user presses Enter or unfocuses the box.

```lua
local input = GuiLibrary:CreateInput(tab, "Placeholder", function(text)
    -- text: string (only on Enter)
end)

input.GetValue()         -- returns current text
input.TextBox            -- direct access to the TextBox instance
```

### Color Picker

```lua
local picker = GuiLibrary:CreateColorPicker(tab, "Label", Color3.fromRGB(255,0,0), function(color)
    -- color: Color3
end)

picker.GetValue()             -- returns current Color3
picker.SetColor(Color3.new()) -- set programmatically
```

The popup expands inline (same layout as dropdown). RGB values can also be typed directly.

### Keybind

```lua
local kb = GuiLibrary:CreateKeybind(tab, "Label", Enum.KeyCode.Insert, function()
    -- key was pressed in-game
end)

kb.GetKey()              -- returns current Enum.KeyCode (or nil)
kb.SetKey("F")           -- set by KeyCode name string
```

Click the button in the UI to enter listening mode, then press any key to assign it.

### Notification

```lua
GuiLibrary:CreateNotification(title, message, duration, type)
-- type: "info" | "success" | "warning" | "error"
-- duration in seconds, default 3
```

```lua
GuiLibrary:CreateNotification("Saved", "Config saved successfully!", 2, "success")
```

---

## Built-in Settings Tab

Every window gets a Settings tab automatically, accessible via ⚙️.

| Setting | Description |
|---|---|
| Toggle GUI | Keybind to show/hide (default: Insert) |
| UI Scale | Resize the window (0.5× – 2.0×) |
| Theme | Dark, Light, Midnight, Forest, Ocean |
| Auto Save Config | Save/restore element states per-game |
| Enable Animations | Toggle all UI tweens on/off |
| Show FPS | FPS counter in the title bar |
| Save Config Now | Force-save immediately |
| Reset Settings | Revert everything to defaults |

---

## Themes

| Name | Description |
|---|---|
| Dark | Default — dark grey with purple accent |
| Light | White background, blue accent |
| Midnight | Near-black with muted purple |
| Forest | Dark green palette |
| Ocean | Dark teal/blue palette |

Switch programmatically (also saves if auto-save is on):

```lua
-- done automatically when the Theme dropdown in Settings changes
```

---

## API Reference

### `GuiLibrary:CreateWindow(title, size)` → window
### `GuiLibrary:CreateTab(window, name)` → tab
### `GuiLibrary:CreateButton(tab, text, callback)` → button
### `GuiLibrary:CreateToggle(tab, text, default, callback)` → `{ GetValue, SetValue, Frame }`
### `GuiLibrary:CreateSlider(tab, text, min, max, default, callback)` → `{ GetValue, SetValue, Frame }`
### `GuiLibrary:CreateDropdown(tab, text, options, callback)` → `{ GetValue, SetValue, UpdateOptions, Frame }`
### `GuiLibrary:CreateLabel(tab, text)` → label
### `GuiLibrary:CreateSection(tab, title)` → frame
### `GuiLibrary:CreateInput(tab, placeholder, callback)` → `{ GetValue, TextBox, Frame }`
### `GuiLibrary:CreateColorPicker(tab, text, defaultColor, callback)` → `{ GetValue, SetColor, Frame }`
### `GuiLibrary:CreateKeybind(tab, text, defaultKey, callback)` → `{ GetKey, SetKey, Frame }`
### `GuiLibrary:CreateNotification(title, message, duration, type)`
### `GuiLibrary:SaveConfig(window, force)`
### `GuiLibrary:LoadConfig(window)` → boolean
### `GuiLibrary:TestFileSaving()` → boolean

---

## Contact

Discord: **cyber_modz**
