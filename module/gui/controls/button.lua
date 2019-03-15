local base_ui = require"module/gui/controls/base_ui"
local _label = require"module/gui/controls/label"
local rectangle = require"module/graphics/rectangle"

local button = class("button",base_ui){
    label = nil,
    label_x = 0,
    label_y = 0,
    draw_index = "default",
    style = {
        font = nil,
        font_color = nil,
        default = nil,
        hover   = nil,
        hit     = nil,
    }
}

function button:__init(label,x,y,w,h,style)
    base_ui.__init(self,x,y,w,h)
    self:_init_style(label,style)
    :set_depth(self.y)
    local font = self.style.font
    self.label = label
    self.label_x = self.width / 2 - font:getWidth(label) / 2
    self.label_y = self.height / 2 - font:getHeight() / 2

    self:connect(self,"mouse_enter","__mouse_enter__")
    self:connect(self,"mouse_exit","__mouse_exit__")
end

function button:__init_signal__()
    base_ui.__init_signal__(self)
    self:signal("mouse_hit")
    self:signal("mouse_lift")
end

function button:_init_style(style)
    style = style or {}
    local w,h = self.width,self.height
    self.style.font         = style.font or ling.font.default
    self.style.font_color   = style.font_color or {10,10,10,255}
    self.style.default      = style.default or rectangle("fill",w,h,{250,200,0,255}) 
    self.style.hover        = style.hover   or rectangle("fill",w,h,{255,230,30,255})
    self.style.hit          = style.hit     or rectangle("fill",w,h,{80,80,80,255})

    return self
end

function button:__mouse_enter__()
    self.draw_index = "hover"
end

function button:__mouse_exit__()
    self.draw_index = "default"
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

function button:draw_label(sx,sy)
    local x,y = self.label_x + sx,sy + self.label_y
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

function button:draw()
    local tex = self.style[self.draw_index]
    local x,y = self:get_pos()
    tex:draw(x,y)
    self:draw_label(x,y)
end

return button