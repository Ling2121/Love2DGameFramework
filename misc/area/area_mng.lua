local list = require"library/depth_list"
local scene = require"library/scene"
local node = require"library/scene/node"

local area_mng = class("area_mng",node){
    area = nil,
}

function area_mng:__init()
    node.__init(self)
    self.area = list()
end

function area_mng:update(dt)
    local up_area = self.area
    
    if self.__is_update then
        for area in self.area:items() do
            if area.__depth_change then
                self.nodes:update_node_depth(area)
            end

            if area:is_hover() then
                self.area = area
            end
        end
    end 

    local area = self.area


    if area then
        if not self:is_node(area) then
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