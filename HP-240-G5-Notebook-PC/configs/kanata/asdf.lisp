#|
  ## the asdf-jkl; thing

   . [f + d] → ctrl  . [j + k] → ctrl
   . [s + a] → alt   . [l + ;] → alt
   . [d + s] → shft  . [k + l] → shft
   . [f + s] → met   . [j + l] → met
   . caps → esc

|#



;; uncomment this if you're not using the NixOS option
;; (defcfg
;;   process-unmapped-keys yes)

(defsrc
  caps
  s d f    #| left home row  |#
  j k l) #| right home row |#

(defvirtualkeys
  relf24 (release-key f24))

(defvar
  tap-time 150
  hold-time 200)

(defalias
  release-f24 (macro 5 (on-press tap-vkey relf24)))

(defalias
  s-first (multi f24 (tap-hold $tap-time $hold-time s (layer-while-held s-comb)) @release-f24)
  d-first (multi f24 (tap-hold $tap-time $hold-time d (layer-while-held d-comb)) @release-f24)
  f-first (multi f24 (tap-hold $tap-time $hold-time f (layer-while-held f-comb)) @release-f24)

  j-first (multi f24 (tap-hold $tap-time $hold-time j (layer-while-held j-comb)) @release-f24)
  k-first (multi f24 (tap-hold $tap-time $hold-time k (layer-while-held k-comb)) @release-f24)
  l-first (multi f24 (tap-hold $tap-time $hold-time l (layer-while-held l-comb)) @release-f24))

(deflayermap (f-comb)
  d ctrl
  s met)

(deflayermap (s-comb)
  a alt)

(deflayermap (d-comb)
  s shft)

(deflayermap (j-comb)
  k ctrl
  l met)

(deflayermap (l-comb)
  ";" alt)

(deflayermap (k-comb)
  l shft)

(deflayer base
  esc
  @s-first @d-first @f-first
  @j-first @k-first @l-first)
