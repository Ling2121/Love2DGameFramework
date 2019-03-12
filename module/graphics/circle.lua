local _circle = require"module/struct/shapes/circle"

local circle = class("circle",_circle){
    mode = "fill",
    color = {},
}

function circle:__init(mode,r,color)
    color = color or {255,255,255,255}
    _circle.__init(self,r)
    self.mode = mode or "fill"
    self.color[1] = color[1] or 255
    self.color[2] = color[2] or 255
    self.color[3] = color[3] or 255
    self.color[4] = color[4] or 255
end

function circle:draw(x,y)
    love.graphics.setColor(unpack(self.color))
    _circle.draw(self,self.mode,x,y)
    love.graphics.setColor(255,255,255,255)
end

return circle
