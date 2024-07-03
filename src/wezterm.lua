local wezterm = require('wezterm')

wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
        return string.format("%i", tab.tab_index)
    end
)


return {
    keys = {
        -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
        {key="LeftArrow", mods="OPT", action=wezterm.action{SendString="\x1bb"}},
        -- Make Option-Right equivalent to Alt-f; forward-word
        {key="RightArrow", mods="OPT", action=wezterm.action{SendString="\x1bf"}},
    },
    -- Theme from https://github.com/sholalkere/dotfiles/blob/main/wezterm/.config/wezterm/wezterm.lua
    adjust_window_size_when_changing_font_size = false,
    audible_bell = 'Disabled',
    bold_brightens_ansi_colors = false,
    check_for_updates = false,
    colors = {
        -- foreground = "rgb(94,97,101)",
        -- background = "rgb(252,252,252)",
    foreground = "#5c6166",
    background = "#fcfcfc",
        -- cursor_bg = "rgb(94,97,101)",
        -- cursor_fg = "rgb(252,252,252)",
    cursor_bg = "#5c6166",
    cursor_fg = "#fcfcfc",
        cursor_border = "rgb(94,97,101)",
        -- ansi = {
        --     "rgb(1,1,1)",
        --     "rgb(196,117,109)",
        --     "rgb(142,168,66)",
        --     "rgb(211,170,95)",
        --     "rgb(113,147,216)",
        --     "rgb(143,117,189)",
        --     "rgb(130,179,148)",
        --     "rgb(193,193,193)",
        -- },
    ansi = {
        '#010101',
        '#e7666a',
        '#80ab24',
        '#eba54d',
        '#4196df',
        '#9870c3',
        '#51b891',
        '#c1c1c1',
    },
    brights = {
        '#343434',
        '#ee9295',
        '#9fd32f',
        '#f0bc7b',
        '#6daee6',
        '#b294d2',
        '#75c7a8',
        '#dbdbdb',
    },
        tab_bar = {
            background = "rgb(219,219,219)",
            active_tab = {
                bg_color = "rgb(252,252,252)",
                fg_color = "rgb(1,1,1)",
            },
            inactive_tab = {
                bg_color = "rgb(219,219,219)",
                fg_color = "rgb(52,52,52)",
            },
            inactive_tab_hover = {
                bg_color = "rgb(230,230,230)",
                fg_color = "rgb(52,52,52)",
            },
            new_tab = {
                bg_color = "rgb(219,219,219)",
                fg_color = "rgb(52,52,52)",
            },
            new_tab_hover = {
                bg_color = "rgb(230,230,230)",
                fg_color = "rgb(52,52,52)",
            },
        },
    },
    font_size = 16,
    front_end = 'WebGpu',
    hide_tab_bar_if_only_one_tab = true,
    line_height = 0.95,
    show_update_window = false,
    window_background_opacity = 1.0,
    window_decorations = "RESIZE",
    window_frame = {
        active_titlebar_bg = "rgb(219,219,219)",
        inactive_titlebar_bg = "rgb(230,230,230)",
    }
}
