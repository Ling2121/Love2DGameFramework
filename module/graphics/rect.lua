local rectangle = require"module/struct/shapes/rectangle"

local rect = class("rect",rectangle){
    mode = "fill",
    color = {},
}

function rect:__init(mode,w,h,color)
    color = color or {255,255,255,255}
    rectangle.__init(self,w,h)
    self.mode = mode or "fill"
    self.color[1] = color[1] or 255
    self.color[2] = color[2] or 255
    self.color[3] = color[3] or 255
    self.color[4] = color[4] or 255
end

function rect:draw(x,y)
    love.graphics.setColor(unpack(self.color))
    rectangle.draw(self,self.mode,x,y)
    love.graphics.setColor(255,255,255,255)
end

return rect
