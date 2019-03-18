local ui_box = require"module/gui/component/ui_box"

local window = class("window",ui_box){
    title_text = "Hello",
    title_rect = nil,
    content_box = nil,
    x_slide = nil,
    y_slide = nil,
    close_button = nil,
}

function window:__init()

end

return window