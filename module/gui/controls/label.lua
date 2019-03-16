local base_ui = require"module/gui/controls/base_ui"

local label = class("label",base_ui){
    label = "Label",
    style = {
        font = nil,
        font_color = nil,
    }
}

function label:__init(label,x,y,style)
    base_ui.__init(self,x,y,0,0)
    self:_load_style(style)
    local font = self.style.font
    self:set_box(font:getWidth(self.label),font:getHeight())
end

function label:_load_style(style)
    style = style or {}
    self.style.font = style.font or ling.font.default
    self.style.font_color = style.font_color or {255,255,255,255}
end

function label:set_label(label)
    self.label = label or self.label
    local font = self.style.font
    self:set_box(font:getWidth(self.label),font:getHeight())
    return self
end

function label:get_label()
    return self.label
end

function label:draw()
    local x,y = self:get_pos()
    local sf,df = self.style.font,ling.font.default
    local is_set = (sf ~= df)
    if is_set then
        love.graphics.setFont(sf)
    end
    love.graphics.setColor(unpack(self.style.font_color))
        love.graphics.print(self.label,x,y)
    love.graphics.setColor(255,255,255,255)
    if is_set then
        love.graphics.setFont(ling.font.default)
    end
end

return label