;; -*- lexical-binding: t; -*-
;; Cursed or peak Emacs usage -- decide for yourself

(defvar vz/wmenu--ivy-map (make-sparse-keymap)
  "Map used in ivy call of `vz/wmenu'.")

(defun vz/wmenu--move-window (window-id group)
  )

(defun vz/wmenu--action (windows)
  (ivy-read "Select window: "
            (-keep
             (fn (when-let ((name (shell-command-to-string ; For now, use `shell-command-to-string'
                                   (concat "xdotool getwindowname " <>)))
                            (_ (s-present? name)))
                   (cons (s-trim-right name) <>)))
             windows)))

(defun vz/wmenu ()
  (setq vz/wmenu--windows nil)
  (set-process-sentinel
   (make-process :name "vz/wmenu--xdotool-process"
                 :buffer " *wmenu-xdotool*"
                 :command '("xdotool" "search" "--maxdepth" "1" "--name" ".")
                 :stderr " *wmenu-xdotool-stderr*")
   (lambda (_ status)
     (when (s-equals? status "finished\n")
       (with-current-buffer " *wmenu-xdotool*"
         (vz/wmenu--action
          (s-split "\n"
                   (s-trim-right
                    (buffer-substring-no-properties (point-min) (point-max))))))
       (let ((kill-buffer-query-functions nil))
         (-each '(" *wmenu-xdotool*" " *wmenu-xdotool-stderr*")
           #'kill-buffer))))))

(vz/wmenu)
