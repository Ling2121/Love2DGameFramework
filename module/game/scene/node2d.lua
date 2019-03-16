local node = require"module/game/scene/node"

local node2d = class("node2d",node){
    x = 0,
    y = 0,
    __view_id = 1,--1:摄像机 2:屏幕
}

function node2d:set_view(id)
    self.__view_id = id or 1
    return self
end

function node2d:set_pos(x,y)
    self.x = x
    self.y = y
end

function node2d:move_pos(x,y)
    self.x = self.x + x
    self.y = self.y + y
end

function node2d:get_pos()
    return self.x,self.y
end

function node2d:get_wpos()--获取世界坐标，位于场景中才有效
    if self.__view_id == 1 then
        local cam = get_node("camera")
        if cam then
            return cam:to_world_pos(self.x,self.y)
        end
    end
    return self.x,self.y
end

return node2d