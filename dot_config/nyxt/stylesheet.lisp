;; For version 3
(in-package #:nyxt-user)

;; Catppuccin Mocha Browser Theme
(define-configuration browser
    ((theme
      (make-instance 'theme:theme
                     :background-color "#1e1e2e"     ; Base
                     :on-background-color "#cdd6f4"  ; Text
                     :accent-color "#cba6f7"         ; Mauve
                     :on-accent-color "#1e1e2e"      ; Base
                     :primary-color "#a6e3a1"        ; Green
                     :on-primary-color "#1e1e2e"     ; Base
                     :secondary-color "#89b4fa"      ; Blue
                     :on-secondary-color "#1e1e2e")))) ; Base

;; Prompt Buffer Styling
(define-configuration prompt-buffer
    ((style
      (str:concat
       %slot-value%
       (theme:themed-css
        (theme *browser*)
        '("#prompt"
          :background-color "#1e1e2e" :color "#cdd6f4") ; Base & Text
        '("#prompt-extra"
          :background-color "#1e1e2e" :color "#cdd6f4") ; Base & Text
        '("#selection"
          :background-color "#313244" :color "#cdd6f4") ; Surface0 & Text
        '("#input"
          :background-color "#181825" :color "#cdd6f4" :border-color "#313244") ; Mantle, Text, Surface0
        '("#input:focus" :border-color "#cba6f7")))))) ; Mauve border on focus
