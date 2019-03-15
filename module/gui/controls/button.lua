local base_ui = require"module/gui/controls/base_ui"
local _label = require"module/gui/controls/label"
local rectangle = require"module/graphics/rectangle"

local button = class("button",base_ui){
    label = nil,
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
    local lx = self.width / 2 - font:getWidth(label) / 2
    local ly = self.height / 2 - font:getHeight() / 2

    self.label = _label(label,lx,ly,{
       font = self.style.font,
       font_color = self.style.font_color,
    }):set_root(self):set_depth(self.y + 1)

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
    self.style.font_color   = style.font_color or {255,255,255,255}
    self.style.default      = style.default or rectangle("fill",w,h,{180,180,95,255}) 
    self.style.hover        = style.hover   or rectangle("fill",w,h,{200,200,140,255})
    self.style.hit          = style.hit     or rectangle("fill",w,h,{220,220,150,255})

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

function button:draw()
    local tex = self.style[self.draw_index]
    local x,y = self:get_pos()
    tex:draw(x,y)
end

return button