local spawn = cwc["spawn_with_shell"]
local screen = cwc["screen"]
local client = cwc["client"]
local function spawn_app(cmd)
  _G.assert((nil ~= cmd), "Missing argument cmd on helper.fnl:3")
  return spawn(("app2unit -- " .. cmd))
end
local function percent__3epixel(num)
  _G.assert((nil ~= num), "Missing argument num on helper.fnl:6")
  local current_screen = screen.focused()
  local width = current_screen.width
  return ((num * width) / 100)
end
return {["spawn-app"] = spawn_app, ["percent->pixel"] = percent__3epixel}
