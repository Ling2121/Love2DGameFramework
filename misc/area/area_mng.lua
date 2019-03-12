local list = require"library/depth_list"
local node = require"library/scene/node"

local area_mng = class("area_mng",node){
    area = nil,
    inst_test = false,
}

function area_mng:__init()
    node.__init(self)
    self.nodes = list()
    self:__init_callback__()
end

function area_mng:__init_callback__()
    for i,n in ipairs(love_callback) do
        if not self[n] then
            self[n] = function(self,...)
                if self.area then
                    if self.area[n] then
                        self.area[n](self.area,...)
                    end
                end
            end
        end    
    end
end

function area_mng:update(dt)
    local up_area = self.area
    
    if self.__is_update then
        for node in self.nodes:items() do
            if node.__depth_change then
                self.nodes:update_node_depth(node)
            end
            if node.update then
                node:update(dt)
            end

            if node:is_hover() then
                self.area = node
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

function area_mng:draw()
    for area in self.nodes:items() do
        if area.draw then
            area:draw()
        end
    end
end

return area_mng