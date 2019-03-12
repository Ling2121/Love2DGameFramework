local _polygon = require"module/struct/shapes/polygon"

local polygon = class("polygon",_polygon){
    mode = "fill",
    color = {},
}

function polygon:__init(mode,points,color)
    color = color or {255,255,255,255}
    _polygon.__init(self,points)
    self.mode = mode or "fill"
    self.color[1] = color[1] or 255
    self.color[2] = color[2] or 255
    self.color[3] = color[3] or 255
    self.color[4] = color[4] or 255
end

function polygon:draw()
    love.graphics.setColor(unpack(self.color))
    _polygon.draw(self,self.mode)
    love.graphics.setColor(255,255,255,255)
end

return polygon
