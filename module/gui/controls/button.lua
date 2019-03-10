local base_ui = ling_import"module/gui/controls/base_ui"
local rect = ling_import"module/graphics/rect"

local button = class("controls_button",base_ui){
    label = "button",
    draw_index = "default",
}

function button:__init(label,x,y,w,h,style)
    base_ui.__init(self,x,y,w,h)
    self:_init_style(label,style)
    self:signal("mouse_hit")
    self:signal("mouse_lift")
    self:connect(self,"mouse_enter","__mouse_enter__")
    self:connect(self,"mouse_exit","__mouse_exit__")
end

function button:_init_style(label,style)
    style = style or {}
    self.label = label or "button"
    self.style.font         = style.font
    self.style.font_color   = style.font_color or {104,18,0,255}
    self.style.default      = style.default or rect("fill",self.w,self.h,{255,123,0,255})
    self.style.hover        = style.hover   or rect("fill",self.w,self.h,{255,160,65,255})
    self.style.hit          = style.hit     or rect("fill",self.w,self.h,{255,200,110,255})
end

function button:mousepressed(mox,moy)
    self:release("mouse_hit",button)
    self.draw_index = "hit"
    base_ui.mousepressed(self,mox,moy)
end

function button:mousereleased(mox,moy,button)
    self:release("mouse_lift",button)
    self.draw_index = "hover"
    base_ui.mousereleased(self,mox,moy)
end

function button:__mouse_enter__()
    self.draw_index = "hover"
end

function button:__mouse_exit__()
    self.draw_index = "default"
end

function button:draw_label(x,y)
    local label = self.label
    local self_font = self.style.font
    local font = self_font or ling.default_font
    x = x + (self.w / 2 - font:getWidth(label) / 2)
    y = y + (self.h / 2 - font:getHeight() / 2)
    if self_font then
        love.graphics.setFont(font)
    end
    love.graphics.setColor(unpack(self.style.font_color))
    love.graphics.print(label,x,y)
    love.graphics.setColor(255,255,255,255)
    if self_font then
        love.graphics.setFont(ling.default_font)
    end
end

function button:draw()
    local tex = self.style[self.draw_index]
    local x,y = self:get_transform_pos()
    tex:draw(x,y)
    self:draw_label(x,y)
end

return button