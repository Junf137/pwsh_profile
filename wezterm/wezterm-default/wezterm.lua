-- Pull in the wezterm API

local wezterm = require 'wezterm'



-- This will hold the configuration.

local config = wezterm.config_builder()



-- This is where you actually apply your config choices


-- Start programs
config.default_prog = { 'D:\\ProgramFiles\\PowerShell\\7\\pwsh.exe' }


-- config.default_cwd = "$env:USERPROFILE"

config.font_size = 12.0
config.font = wezterm.font('FiraCode Nerd Font', { weight = 'Light' })

config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.enable_scroll_bar = false
config.scrollback_lines = 10000
config.show_new_tab_button_in_tab_bar = false

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.90

config.text_background_opacity = 0.90


-- set initial window size
config.adjust_window_size_when_changing_font_size = false
config.initial_rows = 30
config.initial_cols = 120

-- set windows in the center of the screen
config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
}

-- Key Bindings
-- CTRL+SHIFT+R: reload configuration
function keyBind()
    keys = {
        { -- clear screen by sending ctrl+l
            key = 'k',
            mods = 'ALT',
            action = wezterm.action.Multiple {
                wezterm.action.ClearScrollback 'ScrollbackAndViewport',
                wezterm.action.SendKey { key = 'L', mods = 'CTRL' },
            },
        },
        { -- 展示启动器
            key = 'l',
            mods = 'ALT',
            action = wezterm.action.ShowLauncher
        }
    }
    return keys
end

config.keys = keyBind()

-- For example, changing the color scheme:

config.color_scheme = 'AdventureTime'



-- and finally, return the configuration to wezterm

return config
