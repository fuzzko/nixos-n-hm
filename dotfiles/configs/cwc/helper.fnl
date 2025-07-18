(lambda spawn-app [cmd]
  (spawn (.. "app2unit -- " cmd)))

{: spawn-app}
