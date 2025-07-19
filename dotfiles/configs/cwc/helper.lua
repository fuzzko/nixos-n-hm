package.preload["helper"] = package.preload["helper"] or function(...)
  local spawn = cwc["spawn_with_shell"]
  local screen = cwc["screen"]
  local client = cwc["client"]
  local function spawn_app(cmd)
    _G.assert((nil ~= cmd), "Missing argument cmd on ./helper.fnl:3")
    return spawn(("app2unit -- " .. cmd))
  end
  local function percent__3epixel(scr, num)
    _G.assert((nil ~= num), "Missing argument num on ./helper.fnl:6")
    _G.assert((nil ~= scr), "Missing argument scr on ./helper.fnl:6")
    local width = scr["width"]
    return ((num * width) / 100)
  end
  return {["spawn-app"] = spawn_app, ["percent->pixel"] = percent__3epixel}
end
local _local_1_ = require("helper")
local percent__3epixel = _local_1_["percent->pixel"]
local function _2_(_241)
  return print(_241.width, percent__3epixel(_241, 50))
end
return cwc.connect_signal("screen::new", _2_)
