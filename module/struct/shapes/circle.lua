local base_shapes = require"module/struct/shapes/base_shapes"

local circle = class("circle",base_shapes){
    radius = 0,
}

function circle:__init(r)
    base_shapes.__init(self,"circle")
    self.radius = r or 10
end

function circle:get_radius()
    return self.radius
end

function circle:get_diameter()
    return self.radius * 2
end

function circle:draw(mode,x,y)
    love.graphics.circle(mode,self.x,self.y,self.radius)
end

return circle


