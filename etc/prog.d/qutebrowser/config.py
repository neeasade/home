import sys
sys.path.insert(0, "/home/viz/var/cache/tm")

from colors import colors

# general
c.url.searchengines = {
        "DEFAULT" : "https://duckduckgo.com/?q={}",
        "r"       : "https://reddit.com/r/{}",
        "u"       : "https://reddit.com/u/{}",
        "g"       : "https://google.com/search?hl=en&q={}",
        # shortcuts
        "yt"      : "https://youtube.com/{}",
        "gh"      : "https://github.com/{}"
}

c.aliases = {"q": "quit", "q!": "quit", "re": "config-source"}
c.backend = "webengine"

if c.backend == "webkit":
    c.hints.find_implementation = "python"
    c.content.javascript.can_close_tabs = False
    c.content.notifications = False

# bindings
def bind(key, command, mode="normal"):
    config.bind(key, command, mode)

bind("Q", "record-macro")
bind("q", "tab-close")
bind("T", "undo")
bind("P", "tab-pin")
bind("<Ctrl-j>", "completion-item-focus next", mode="command")
bind("<Ctrl-k>", "completion-item-focus prev", mode="command")
bind("<Ctrl-j>", "prompt-item-focus next", mode="prompt")
bind("<Ctrl-k>", "prompt-item-focus prev", mode="prompt")

# fonts
c.zoom.default = "120%"
c.fonts.completion.category = "10pt Go Mono"
c.fonts.completion.entry = "10pt Go Mono"
c.fonts.debug_console = "10pt Go Mono"
c.fonts.downloads = "10pt Go Mono"
c.fonts.hints = "14pt Go Mono"
c.fonts.keyhint = "10pt Go Mono"
c.fonts.messages.error = "10pt Go Mono"
c.fonts.messages.info = "10pt Go Mono"
c.fonts.messages.warning = "10pt Go Mono"
c.fonts.monospace = "Go Mono"
c.fonts.prompts = "10pt Fira Sans"
c.fonts.statusbar = "10pt Go Mono"
c.fonts.tabs = "10pt Go Mono"
c.fonts.web.family.fixed = "Go Mono"
c.fonts.web.family.sans_serif = "Fira Sans"
c.fonts.web.family.serif = "Fira Sans"
c.fonts.web.family.standard = "Go Mono"
c.fonts.web.size.default = 14
c.fonts.web.size.default_fixed = 13
c.fonts.web.size.minimum = 10
c.fonts.web.size.minimum_logical = 10

# hints
c.hints.auto_follow = "unique-match"
c.hints.auto_follow_timeout = 0
c.hints.border = "0px solid " + colors[0]
c.hints.chars = "asdfjkl"
c.hints.hide_unmatched_rapid_hints = True
c.hints.min_chars = 1
c.hints.mode = "letter" # number/letter/word
c.hints.uppercase = True # easier to see
# might be worth it?
# c.hints.dictionary = "/usr/share/dict/words"

# statusbar
c.statusbar.hide = True
c.statusbar.padding = {"top": 2, "bottom": 2, "left": 5, "right": 5}
c.statusbar.position = "bottom"
c.statusbar.widgets = ["keypress", "progress", "url"]

# tabbar
c.tabs.background = False
c.tabs.close_mouse_button = "none"
c.tabs.close_mouse_button_on_bar = "ignore"
c.tabs.favicons.scale = 1.0
c.tabs.favicons.show = "pinned"
c.tabs.indicator.width = 0
c.tabs.last_close = "startpage"
c.tabs.mode_on_change = "normal"
c.tabs.mousewheel_switching = False  # i dont even have one
c.tabs.new_position.related = "last"
c.tabs.new_position.unrelated = "last"
c.tabs.padding = {"top": 10, "bottom": 10, "left": 10, "right": 10}
c.tabs.position = "top"
c.tabs.select_on_remove = "last-used"
c.tabs.show = "multiple" # or switching
c.tabs.show_switching_delay = 800
c.tabs.tabs_are_windows = False # would be True if qutebrowser supported XEmbed protocol BUT NO
c.tabs.title.alignment = "center"
c.tabs.title.format = "{audio} {title}"
c.tabs.pinned.shrink = True
c.tabs.title.format_pinned = ""
c.tabs.max_width = -1
c.tabs.min_width = 100
c.tabs.wrap = True

# thank god something like this exists
c.content.autoplay = False

# no thank u
c.content.desktop_capture = "ask"
c.content.geolocation = "ask"
c.content.media_capture = "ask"
c.content.mouse_lock = "ask"
c.content.persistent_storage = "ask"
c.content.register_protocol_handler = "ask"
c.content.ssl_strict = "ask"
c.content.headers.do_not_track = True
c.content.javascript.can_access_clipboard = False
c.content.javascript.can_open_tabs_automatically = False
c.content.local_content_can_access_remote_urls = False
c.content.pdfjs = False
c.content.plugins = False
c.content.webgl = False # lmao why
c.input.rocker_gestures = False
c.input.spatial_navigation = False
c.scrolling.bar = "never"
c.window.hide_decoration = True
c.qt.low_end_device_mode = "always"  # qb likes to chew battery

# yes pls
c.content.host_blocking.enabled = True
c.content.host_blocking.lists = []     # have them in /etc/hosts
c.content.mute = False
c.content.windowed_fullscreen = True
c.editor.command = ["emacsclient", "-c", "{file}"]
c.downloads.location.directory = "~/var/downloads"
c.downloads.location.prompt = False
c.downloads.location.remember = True
c.editor.encoding = "utf-8"

# misc
c.completion.cmd_history_max_items = -1
c.completion.delay = 0
c.completion.height = "20%"
c.completion.min_chars = 3
c.completion.quick = True
c.completion.scrollbar.padding = 1
c.completion.scrollbar.width = 0
c.completion.show = "auto"
c.completion.shrink = True
c.completion.timestamp_format = "%d-%m-%y"
c.completion.use_best_match = False
c.confirm_quit = ["downloads"]

c.content.headers.accept_language = "en-US,en"
c.content.headers.referer = "same-domain"
c.content.images = True
c.content.javascript.alert = True
c.content.javascript.enabled = True
c.content.javascript.prompt = True
c.content.local_content_can_access_file_urls = True

c.downloads.location.suggestion = "both"
c.downloads.open_dispatcher = None
c.downloads.position = "top"
c.downloads.remove_finished = 100

c.history_gap_interval = 5

c.input.escape_quits_reporter = True
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = False
c.input.insert_mode.auto_load = False
c.input.insert_mode.plugins = True
c.input.links_included_in_focus_chain = True
c.input.partial_timeout = 400

c.keyhint.delay = 5000
c.keyhint.radius = 0

c.messages.timeout = 4000

c.new_instance_open_target = "tab-bg"
c.new_instance_open_target_window = "first-opened"
c.prompt.filebrowser = True
c.prompt.radius = 0

c.scrolling.smooth = True
c.search.ignore_case = "smart"
c.search.incremental = True
c.spellcheck.languages = ["en-US"]

c.url.auto_search = "naive"
c.url.default_page = "file:///home/viz/var/cache/homepage.html"
c.url.incdec_segments = ["path", "query"]
c.url.open_base_url = True
c.url.start_pages = "file:///home/viz/var/cache/homepage.html"

c.window.title_format = "qb: {perc}{title}"

# themeing
c.colors.webpage.bg = colors[0]
c.colors.completion.category.bg = colors[0]
c.colors.completion.category.border.bottom = colors[0]
c.colors.completion.category.border.top = colors[0]
c.colors.completion.category.fg = colors[7]
c.colors.completion.even.bg = colors[0]
c.colors.completion.fg = colors[7]
c.colors.completion.item.selected.bg = colors[8]
c.colors.completion.item.selected.border.bottom = colors[8]
c.colors.completion.item.selected.border.top = colors[8]
c.colors.completion.item.selected.fg = colors[15]
c.colors.completion.match.fg = colors[1]
c.colors.completion.odd.bg = colors[0]
c.colors.completion.scrollbar.bg = colors[0]
c.colors.completion.scrollbar.fg = colors[0]
c.colors.downloads.bar.bg = colors[0]
c.colors.downloads.error.bg = colors[0]
c.colors.downloads.error.fg = colors[1]
c.colors.downloads.start.bg = colors[0]
c.colors.downloads.start.fg = colors[7]
c.colors.downloads.stop.bg = colors[0]
c.colors.downloads.stop.fg = colors[6]
c.colors.downloads.system.bg = "none"
c.colors.downloads.system.fg = "none"
c.colors.hints.bg = colors[0]
c.colors.hints.fg = colors[7]
c.colors.hints.match.fg = colors[3]
c.colors.keyhint.bg = colors[3]
c.colors.keyhint.fg = colors[7]
c.colors.keyhint.suffix.fg = colors[15]
c.colors.messages.error.bg = colors[0]
c.colors.messages.error.border = colors[0]
c.colors.messages.error.fg = colors[1]
c.colors.messages.info.bg = colors[0]
c.colors.messages.info.border = colors[0]
c.colors.messages.info.fg = colors[7]
c.colors.messages.warning.bg = colors[0]
c.colors.messages.warning.border = colors[0]
c.colors.messages.warning.fg = colors[4]
c.colors.prompts.bg = colors[0]
c.colors.prompts.border = "0px " + colors[0]
c.colors.prompts.fg = colors[7]
c.colors.prompts.selected.bg = colors[8]
c.colors.statusbar.caret.bg = colors[0]
c.colors.statusbar.caret.fg = colors[5]
c.colors.statusbar.caret.selection.bg = colors[0]
c.colors.statusbar.caret.selection.fg = colors[13]
c.colors.statusbar.command.bg = colors[0]
c.colors.statusbar.command.fg = colors[7]
c.colors.statusbar.insert.bg = colors[0]
c.colors.statusbar.insert.fg = colors[2]
c.colors.statusbar.normal.bg = colors[0]
c.colors.statusbar.normal.fg = colors[7]
c.colors.statusbar.passthrough.bg = colors[0]
c.colors.statusbar.passthrough.fg = colors[4]
c.colors.statusbar.progress.bg = colors[0]
c.colors.statusbar.url.error.fg = colors[1]
c.colors.statusbar.url.fg = colors[7]
c.colors.statusbar.url.hover.fg = colors[7]
c.colors.statusbar.url.success.http.fg = colors[7]
c.colors.statusbar.url.success.https.fg = colors[7]
c.colors.statusbar.url.warn.fg = colors[3]
c.colors.tabs.bar.bg = colors[8]
c.colors.tabs.even.bg = colors[8]
c.colors.tabs.even.fg = colors[15]
c.colors.tabs.indicator.error = colors[1]
c.colors.tabs.indicator.start = colors[8]
c.colors.tabs.indicator.stop = colors[8]
c.colors.tabs.indicator.system = "none"
c.colors.tabs.odd.bg = colors[8]
c.colors.tabs.odd.fg = colors[15]
c.colors.tabs.selected.even.bg = colors[0]
c.colors.tabs.selected.even.fg = colors[7]
c.colors.tabs.selected.odd.bg = colors[0]
c.colors.tabs.selected.odd.fg = colors[7]

# might be worth it idk
## This setting can be used to map keys to other keys. When the key used
## as dictionary-key is pressed, the binding for the key used as
## dictionary-value is invoked instead. This is useful for global
## remappings of keys, for example to map Ctrl-[ to Escape. Note that
## when a key is bound (via `bindings.default` or `bindings.commands`),
## the mapping is ignored.
## Type: Dict
# c.bindings.key_mappings = {"<Ctrl-[>": "<Escape>", "<Ctrl-6>": "<Ctrl-^>", "<Ctrl-M>": "<Return>", "<Ctrl-J>": "<Return>", "<Shift-Return>": "<Return>", "<Enter>": "<Return>", "<Shift-Enter>": "<Return>", "<Ctrl-Enter>": "<Ctrl-Return>"}
