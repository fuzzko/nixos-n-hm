local webview = require("webview")
local lousy = require("lousy")
local common_widget = require("lousy.widget")

local theme = lousy.theme.get()

local secure_icon = "󰌾"
local unsecure_icon = "󱙱"

local function update(w, ssl)
  local is_secure = w.view:ssl_trusted()
  if is_secure == true then
    ssl.fg = theme.trust_fg
    ssl.text = secure_icon
    ssl:show()
  elseif (w.view_uri or ""):sub(1, 4) == "http" then
    ssl.fg = theme.notrust_fg
    ssl.text = unsecure_icon
    ssl:show()
  else
    ssl:hide()
  end
end

local widgets = { update = update }

webview.add_signal("init", function(view)
  view:add_signal("load-status", function(view_child, status)
    local window = webview.window(view_child)
    if status == "commited" and window and window.view == view then
      common_widget.update_widgets_on_w(widgets, window)
    end
  end)

  view:add_signal("switched-page", function(view_child)
    local window = webview.window(view_child)
    common_widget.update_widgets_on_w(widgets, window)
  end)
end)

local function new(...)
  local ssl = widget({ type = "label" })
  ssl:hide()
  ssl.fg = theme.ssl_sbar_fg
  ssl.font = theme.ssl_sbar_font
  return common_widget.add_widget(widgets, ssl)
end

return setmetatable({}, {
  __call = function(_self, ...)
    new(...)
  end
})
