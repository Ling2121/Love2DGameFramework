--[[
    用于处理区域的点击和反馈
    用途：
        点击拾取物品
        点击对象互动
        ···
--]]
local list = require"module/struct/depth_list"
local scene = require"module/game/scene"
local node = require"module/game/scene/node"

local area_mng = class("area_mng",node){
    area = nil,--当前选择的区域
}

function area_mng:__init()
    node.__init(self)
    self.all_area = list()
end

function area_mng:__init_signal__()
    node.__init_signal__(self)
    self:signal("add_object")
    self:signal("remove_object")
end

function area_mng:add_area(area)--名称显而易见
    self.all_area:insert_node(area)
    self:local_release("add_object",{area},self)
    area.__at_area_mng = self
    return self
end

function area_mng:remove_area(area)
    self.all_area:remove_self(area)
    self:local_release("remove_object",{area},self)
    area.__at_area_mng = nil
    return self
end

function area_mng:update(dt)
    local up_area = self.area
    
    --获取当前选择的区域
    for area in self.all_area:items() do
        if area.__depth_change then
            self.all_area:update_node_depth(area)
        end
        if area:is_hover() then
            self.area = area
        end
    end

    local area = self.area

    --下面的东西用于处理信号发送
    if area then
        if not self.all_area.__all_node[area] then
            area.__is_select = false
            self.area = nil
        else
            area.__is_select = true
            if up_area then
                if up_area ~= area then
                    up_area.__is_select = false
                    up_area:release("mouse_exit",area)
                    up_area.__select_rel__ = false
                    up_area.__enter_rel__ = false
                    up_area.__exit_rel__ = false
                end
            end

            if not area.__enter_rel__ then
                area:release("mouse_enter",area)
                area.__enter_rel__ = true
            end

            if not area:is_hover() then
                area:release("mouse_exit",area)
                area.__is_select  = false
                area.__select_rel__ = false
                area.__enter_rel__ = false
                area.__exit_rel__ = false
                self.area = nil
            end
        end
    end
end

return area_mng