local _rectangle = require"module/struct/shapes/rectangle"

local rectangle = class("rectangle",_rectangle){
    mode = "fill",
    color = {},
}

function rectangle:__init(mode,w,h,color)
    color = color or {255,255,255,255}
    _rectangle.__init(self,w,h)
    self.mode = mode or "fill"
    self.color[1] = color[1] or 255
    self.color[2] = color[2] or 255
    self.color[3] = color[3] or 255
    self.color[4] = color[4] or 255
end

function rectangle:draw(x,y)
    love.graphics.setColor(unpack(self.color))
    _rectangle.draw(self,self.mode,x,y)
    love.graphics.setColor(255,255,255,255)
end

return rectangle
