(local {: percent->pixel} (require :helper))

(print (. (cwc.screen.focused) width) (percent->pixel 50))
