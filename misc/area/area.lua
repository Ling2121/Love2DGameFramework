--[[
    基本的区域对象
--]]
local rectangle = require"module/struct/shapes/rectangle"
local node2d = require"module/game/scene/node2d"

local area = class("area",node2d,rectangle){
    x = 0,
    y = 0,
    __is_select = false,
    __at_area_mng = nil,
}

function area:__init(x,y,w,h)
    rectangle.__init(self,w,h)
    self.x = x or 0
    self.y = y or 0
    self:__init_signal__()
end

function area:__init_signal__()
    node2d.__init_signal__(self)
    self:signal("mouse_enter")
    self:signal("mouse_exit")
    self:signal("mouse_click")
end

function area:bbox()
    local x,y = self:get_wpos()
    return x,y,x + self.width,y + self.height
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
    local a = 100
    if self.__is_select then
        a = 255
    end
    love.graphics.setColor(200,0,0,a)
    rectangle.draw("fill",self.x,self.y)
    love.graphics.setColor(255,255,255,255)
end

return area


