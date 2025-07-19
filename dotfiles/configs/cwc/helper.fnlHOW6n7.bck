(local {:spawn_with_shell spawn : screen : client} cwc)

(lambda spawn-app [cmd]
  "spawn an executable with app2unit"
  (spawn (.. "app2unit -- " cmd)))

(lambda percent->number [max-value value]
  "converts a percent unit to a number"
  (/ (* value max-value) 100))

{: spawn-app : percent->number}
