# Soldo GUI Library for Roblox

A modern, feature-rich GUI library for Roblox executors, built with Luau. This library provides a customizable and animated user interface with a variety of components, themes, and utility functions. It is designed to be easy to use, visually appealing, and performant, making it ideal for creating professional-grade GUI systems in Roblox.

- **Author**: Soldo (Discord: Soldo_io)
- **License**: MIT License
- **Version**: 1.0.0

## Features

- **Modern Animations**: Smooth transitions and hover effects using Roblox's TweenService.
- **Theming System**: Multiple built-in themes (Dark, Light, Midnight, Forest, Ocean) with customizable colors.
- **Comprehensive Components**: Includes buttons, toggles, sliders, dropdowns, labels, sections, inputs, color pickers, keybinds, and notifications.
- **Settings Tab**: Automatically generated settings tab for controlling UI scale, theme, animations, and FPS display.
- **Responsive Design**: Draggable windows, scalable UI, and dynamic tab system.
- **Performance Monitoring**: Optional FPS display with color-coded performance indicators.
- **Notification System**: Customizable notifications with different types (info, success, warning, error).

## Loading

1. **Download a Executer**:
   - For example AWP or Velocity.  >  https://whatexpsare.online/

2. **Add to Your Project**:
   - Paste the code into a Lua script in your Roblox executor or game environment.
   - Ensure the script is executed in a context where `game.CoreGui` is accessible (e.g., via an executor).

3. **Require the Library**:
   ```lua
   local GuiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/SoldoxD/libery/refs/heads/main/main"))()
   ```

## Usage

### Creating a Window
The `GuiLibrary:CreateWindow` function creates a new GUI window with a title and optional size.

```lua
local window = GuiLibrary:CreateWindow("My GUI", UDim2.new(0, 600, 0, 400))
```

### Adding Tabs
Tabs organize content within the window. Use `GuiLibrary:CreateTab` to create a new tab.

```lua
local tab = GuiLibrary:CreateTab(window, "Main")
```

### Adding Components
The library supports various components that can be added to tabs. Below are examples for each component:

#### Button
Creates a clickable button with a callback function.

```lua
GuiLibrary:CreateButton(tab, "Click Me", function()
    print("Button clicked!")
end)
```

#### Toggle
Creates a toggle switch with an optional default state and callback.

```lua
local toggle = GuiLibrary:CreateToggle(tab, "Enable Feature", true, function(state)
    print("Toggle state:", state)
end)
print("Toggle value:", toggle.GetValue())
```

#### Slider
Creates a slider for selecting a value within a range.

```lua
local slider = GuiLibrary:CreateSlider(tab, "Volume", 0, 100, 50, function(value)
    print("Slider value:", value)
end)
print("Slider value:", slider.GetValue())
slider.SetValue(75) -- Set slider to a specific value
```

#### Dropdown
Creates a dropdown menu with selectable options.

```lua
local dropdown = GuiLibrary:CreateDropdown(tab, "Select Option", {"Option 1", "Option 2", "Option 3"}, function(option)
    print("Selected:", option)
end)
print("Dropdown value:", dropdown.GetValue())
```

#### Label
Creates a simple text label.

```lua
GuiLibrary:CreateLabel(tab, "This is a label")
```

#### Section
Creates a titled section to group components.

```lua
GuiLibrary:CreateSection(tab, "Settings")
```

#### Input/TextBox
Creates a text input field.

```lua
local input = GuiLibrary:CreateInput(tab, "Enter text", function(text)
    print("Input text:", text)
end)
print("Input value:", input.GetValue())
```

#### Color Picker
Creates a color picker with a predefined set of colors.

```lua
local colorPicker = GuiLibrary:CreateColorPicker(tab, "Pick Color", Color3.new(1, 0, 0), function(color)
    print("Selected color:", color)
end)
print("Color value:", colorPicker.GetValue())
colorPicker.SetColor(Color3.new(0, 1, 0)) -- Set a specific color
```

#### Keybind
Creates a keybind input for assigning keyboard shortcuts.

```lua
local keybind = GuiLibrary:CreateKeybind(tab, "Action Key", Enum.KeyCode.Q, function()
    print("Keybind triggered!")
end)
print("Keybind value:", keybind.GetKey().Name)
```

#### Notification
Creates a temporary notification with a title, message, duration, and type.

```lua
GuiLibrary:CreateNotification("Welcome", "GUI loaded successfully!", 3, "success")
```

### Settings Tab
Every window automatically includes a hidden "Settings" tab, accessible via the settings button (⚙️) in the title bar. It includes:

- **Toggle GUI Keybind**: Default key is `Insert`.
- **UI Scale Slider**: Adjusts the window size (0.5x to 2.0x).
- **Theme Dropdown**: Select from Dark, Light, Midnight, Forest, or Ocean themes.
- **Enable Animations Toggle**: Enable or disable UI animations.
- **Show FPS Toggle**: Display real-time FPS with color-coded indicators.
- **Reset Settings Button**: Resets all settings to default.

### Window Methods
The window object returned by `GuiLibrary:CreateWindow` provides the following methods:

- `window:Hide()`: Hides the window with an animation.
- `window:Show()`: Shows the window with an animation.
- `window:Toggle()`: Toggles the window's visibility.

```lua
window:Toggle() -- Toggle visibility
```

## Themes
The library includes five built-in themes:

- **Dark**: Default dark theme with muted colors.
- **Light**: Bright theme for better visibility in well-lit environments.
- **Midnight**: Deep, dark theme with a sleek aesthetic.
- **Forest**: Green-themed for a natural look.
- **Ocean**: Blue-themed for a calming effect.

Switch themes via the Settings tab or programmatically:

```lua
-- Example: Switch to Light theme
for key, color in pairs({
    PRIMARY = Color3.fromRGB(230, 230, 240),
    -- ... other theme colors
}) do
    COLORS[key] = color
end
updateElementColors(window)
```

## API Reference

### GuiLibrary:CreateWindow(title, size)
- **Parameters**:
  - `title` (string): Window title (default: "GUI Library").
  - `size` (UDim2): Window size (default: UDim2.new(0, 600, 0, 400)).
- **Returns**: Window object with methods `Hide`, `Show`, and `Toggle`.

### GuiLibrary:CreateTab(window, name)
- **Parameters**:
  - `window` (table): Window object from `CreateWindow`.
  - `name` (string): Tab name.
- **Returns**: Tab object with `Button`, `Content`, `Name`, and `Elements` properties.

### GuiLibrary:CreateButton(tab, text, callback)
- **Parameters**:
  - `tab` (table): Tab object from `CreateTab`.
  - `text` (string): Button text.
  - `callback` (function): Function called when the button is clicked.
- **Returns**: Button instance.

### GuiLibrary:CreateToggle(tab, text, default, callback)
- **Parameters**:
  - `tab` (table): Tab object.
  - `text` (string): Toggle label.
  - `default` (boolean): Initial state (default: false).
  - `callback` (function): Function called with the toggle state.
- **Returns**: Table with `Frame` and `GetValue` method.

### GuiLibrary:CreateSlider(tab, text, min, max, default, callback)
- **Parameters**:
  - `tab` (table): Tab object.
  - `text` (string): Slider label.
  - `min` (number): Minimum value.
  - `max` (number): Maximum value.
  - `default` (number): Initial value.
  - `callback` (function): Function called with the slider value.
- **Returns**: Table with `Frame`, `GetValue`, and `SetValue` methods.

### GuiLibrary:CreateDropdown(tab, text, options, callback)
- **Parameters**:
  - `tab` (table): Tab object.
  - `text` (string): Dropdown label.
  - `options` (table): Array of option strings.
  - `callback` (function): Function called with the selected option.
- **Returns**: Table with `Frame` and `GetValue` method.

### GuiLibrary:CreateLabel(tab, text)
- **Parameters**:
  - `tab` (table): Tab object.
  - `text` (string): Label text.
- **Returns**: Label instance.

### GuiLibrary:CreateSection(tab, title)
- **Parameters**:
  - `tab` (table): Tab object.
  - `title` (string): Section title.
- **Returns**: Section frame instance.

### GuiLibrary:CreateInput(tab, placeholder, callback)
- **Parameters**:
  - `tab` (table): Tab object.
  - `placeholder` (string): Placeholder text.
  - `callback` (function): Function called with the input text when Enter is pressed.
- **Returns**: Table with `Frame`, `TextBox`, and `GetValue` method.

### GuiLibrary:CreateColorPicker(tab, text, defaultColor, callback)
- **Parameters**:
  - `tab` (table): Tab object.
  - `text` (string): Color picker label.
  - `defaultColor` (Color3): Initial color.
  - `callback` (function): Function called with the selected color.
- **Returns**: Table with `Frame`, `GetValue`, and `SetColor` methods.

### GuiLibrary:CreateKeybind(tab, text, defaultKey, callback)
- **Parameters**:
  - `tab` (table): Tab object.
  - `text` (string): Keybind label.
  - `defaultKey` (Enum.KeyCode): Initial key.
  - `callback` (function): Function called when the key is pressed.
- **Returns**: Table with `Frame` and `GetKey` method.

### GuiLibrary:CreateNotification(title, message, duration, notifType)
- **Parameters**:
  - `title` (string): Notification title.
  - `message` (string): Notification message.
  - `duration` (number): Display duration in seconds (default: 3).
  - `notifType` (string): Type of notification ("info", "success", "warning", "error").
- **Returns**: None.

## Example Project
Below is a complete example demonstrating multiple components:

```lua
local GuiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/SoldoxD/libery/refs/heads/main/main"))()

-- Create a window
local window = GuiLibrary:CreateWindow("Demo GUI", UDim2.new(0, 500, 0, 300))

-- Create a tab
local mainTab = GuiLibrary:CreateTab(window, "Main")

-- Add components
GuiLibrary:CreateSection(mainTab, "Controls")
GuiLibrary:CreateButton(mainTab, "Test Button", function()
    GuiLibrary:CreateNotification("Button Clicked", "You clicked the button!", 2, "success")
end)

local toggle = GuiLibrary:CreateToggle(mainTab, "Enable Feature", false, function(state)
    print("Feature enabled:", state)
end)

local slider = GuiLibrary:CreateSlider(mainTab, "Speed", 0, 100, 50, function(value)
    print("Speed set to:", value)
end)

GuiLibrary:CreateDropdown(mainTab, "Mode", {"Easy", "Medium", "Hard"}, function(option)
    print("Mode selected:", option)
end)

GuiLibrary:CreateLabel(mainTab, "This is a demo label")

-- Create another tab
local otherTab = GuiLibrary:CreateTab(window, "Other")
GuiLibrary:CreateInput(otherTab, "Enter username", function(text)
    print("Username entered:", text)
end)

GuiLibrary:CreateColorPicker(otherTab, "Player Color", Color3.new(1, 0, 0), function(color)
    print("Color selected:", color)
end)

GuiLibrary:CreateKeybind(otherTab, "Jump Key", Enum.KeyCode.Space, function()
    print("Jump key pressed!")
end)
```

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact
For support or inquiries, contact Soldo on Discord: **Soldo_io**.
