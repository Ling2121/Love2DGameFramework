local base_shapes = require"module/struct/shapes/base_shapes"

local rectangle = class("rectangle",base_shapes){
    width = 10,
    height = 10,
}

function rectangle:__init(w,h)
    base_shapes.__init(self,"rectangle")
    self.width = w or 10
    self.height = h or 10
end

function rectangle:get_width()
    return self.width
end

function rectangle:get_height()
    return self.height
end

function rectangle:draw(mode,x,y)
    love.graphics.rectangle(mode,x,y,self.w,self.h)
end

return rectangle