#|
  ## the asdf-jkl; thing

   . [a + f] → lctrl   . [k + ;] → rctrl
   . [a + d] → lalt    . [j + l] → ralt
   . [a + s] → lshift  . [j + k] → rshift
   . [s + d] → lsuper  . [k + l] → rsuper
   . caps → esc

|#

;; uncomment this if you're not using the NixOS option
; (defcfg
;   process-unmapped-keys yes)

(defsrc
  caps
  a s d f    ;; left home row
  j k l ";") ;; right home row

(defvar
  tap-time 150
  hold-time 200)

(defalias
  )
