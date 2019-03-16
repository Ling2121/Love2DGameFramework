local area_mng = require"misc/area/area_mng"

local ui_mng = class("ui_mng",area_mng){
    __view_id = 1,
}

function ui_mng:__init()
    area_mng.__init(self)
    self:__init_callback__()
end

function ui_mng:__init_callback__()
    for _,call_name in ipairs(love_callback) do
        if not self[call_name] then
            self[call_name] = function(self,...)
                local area = self.area
                if area and area[call_name] then
                    area[call_name](area,...)
                end
            end
        end
    end
end

function ui_mng:set_view(id)
    self.__view_id = id or 1
    return self
end

function ui_mng:add_controls(contrls)
    area_mng.add_area(self,contrls)
    contrls.__view_id = self.__view_id
    return self
end

function ui_mng:remove_contrls(contrls)
    area_mng.remove_area(self,contrls)
    return self
end

function ui_mng:update(dt)
    local area = self.area
    if area then
        if area.update then
            area:update(dt)
        end
        if not area.locking then
            area_mng.update(self,dt)
        end
    else
        area_mng.update(self,dt)
    end
end

function ui_mng:draw()
    for ui in self.all_area:items() do
        ui:draw()
    end
end


return ui_mng


