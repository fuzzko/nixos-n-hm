package.preload["helper"] = package.preload["helper"] or function(...)
  local spawn = cwc["spawn_with_shell"]
  local screen = cwc["screen"]
  local client = cwc["client"]
  local function spawn_app(cmd)
    _G.assert((nil ~= cmd), "Missing argument cmd on ./helper.fnl:3")
    return spawn(("app2unit -- " .. cmd))
  end
  local function percent__3epixel(num)
    _G.assert((nil ~= num), "Missing argument num on ./helper.fnl:6")
    local current_screen = screen.focused()
    local width = current_screen.width
    return ((num * width) / 100)
  end
  return {["spawn-app"] = spawn_app, ["percent->pixel"] = percent__3epixel}
end
local _local_1_ = require("helper")
local percent__3epixel = _local_1_["percent->pixel"]
return print(cwc.screen.focused().width, percent__3epixel(50))
