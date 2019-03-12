local rectangle = require"module/struct/shapes/rectangle"
local node = require"library/scene/node2d"

local area = class("area",node,rectangle){
    x = 0,
    y = 0,
    __is_select = false,
}

function area:__init(x,y,w,h)
    rectangle.__init(self,w,h)
    self.x = x or 0
    self.y = y or 0
    self:__init_signal__()
end

function area:__init_signal__()
    self:signal("mouse_enter")
    self:signal("mouse_exit")
    self:signal("mouse_click")
end

function area:bbox()
    return self.x,self.y,self.x + self.w,self.y + self.h
end

function area:is_hover()
    local x,y,max_x,max_y = self:bbox()
    local mx,my = love.mouse.getPosition()
    return mx > x and my > y and mx < max_x and my < max_y
end

function area:mousepressed(x,y,b)
    if self.__is_select then
        self:release("mouse_click",b)
    end
end

function area:draw()
    love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
end

return area


