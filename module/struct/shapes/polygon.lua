local polygon = class("polygon"){
    points = {0,0,0,0,0,0}
}

function polygon:__init(points)
    base_shapes.__init(self,"circle")
    self.points = points or {0,0,0,0,0,0}
end

function polygon:get_points()
    return self.points
end

function polygon:unpack_points()
    return unpack(self.points)
end

function polygon:draw(mode)
    love.graphics.polygon(mode,unpack(self.points))
end

return polygon