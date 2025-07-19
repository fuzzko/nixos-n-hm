(local {: percent->pixel} (require :helper))

(cwc.connect_signal "screen::new"
                    #(print $1.width (percent-pixel $1 50)))
