(require "vis")

;; Helper functions
(fn *startswith* [str prefix]
  (= (string.sub str 1 (string.len prefix))
    prefix))

(fn *endswith* [str suffix]
  (= (string.sub str (- (string.len str) (string.len suffix) -1) -1)
    suffix))

(fn *settitle* [title]
  (vis:command
    (string.format ":!printf '\\033]]0;%s: %s\\a'"
        (if (not (os.getenv "IN_NIX_SHELL"))
              "vis" "!vis")
          title)))

(fn car [list]
  (. list 1))

(fn cdr [list]
  (let [l list]
    (table.remove l 1)
    l))

(fn foreach [fun list]
  (each [_ x (ipairs list)]
    (fun x)))

(fn ormap [fun list]
  (if (= (length list) 0)
        false
      (fun (car list))
        true
    (ormap fun (cdr list))))

;; Set title of the vis window
(fn settitle [win]
  (if (= win.file.path nil)
        (*settitle* "*new*")
      (not (*startswith* win.file.path (os.getenv "HOME")))
        (*settitle* win.file.path)
    (*settitle* (.. "~" (string.sub win.file.path
                          (+ 1 (string.len (os.getenv "HOME"))) -1)))))

;; Set the global config. Called in INIT
(fn globcfg []
  (foreach (fn [x] (vis:command (.. "set " x)))
    ["tw 4" "syntax off"]))

;; Set the default configuration for languages
(fn defcfg []
  (foreach (fn [x] (vis:command (.. "set " x)))
    ["tw 4" "et off" "ai off"]))

;; Set the configuration for functional languages
(fn langcfg [win]
  (if (= win.file.path nil)
        (defcfg)
      (ormap (fn [x] (*endswith* win.file.path x))
          [".nix" ".rkt" ".fnl" ".scm"])
        (foreach (fn [x] (vis:command (.. "set " x)))
          ["tw 2" "et on" "ai on"])
    (defcfg)))

;; Hijacking this function for proper selection style
(fn vis.types.window.set_syntax [win syntax]
  (set win.syntax nil)
  (foreach (fn [x] (win:style_define (car x) (car (cdr x))))
    [[win.STYLE_CURSOR         "back: 16"]
     [win.STYLE_STATUS         ""]
     [win.STYLE_STATUS_FOCUSED "reverse"]
     [win.STYLE_CURSOR_PRIMARY "reverse"]])
   true)

(vis.events.subscribe vis.events.INIT globcfg)

(foreach (fn [x] (vis.events.subscribe vis.events.WIN_OPEN x))
  [settitle langcfg])
