local area_mng = ling_import"misc/area/area_mng"
local list = ling_import"misc/list"
local node = ling_import"module/game/scene/node"

local ui_mng = class("ui_mng",area_mng){
    ox = 0,
    oy = 0,
}

function ui_mng:__init(scene,ox,oy)
    node.__init(self)
    self.nodes = list()
    self.camera = scene.camera
    self:__init_callback__()
    self:set_origin(ox,oy)
end

function ui_mng:__init_callback__()
    for _,call_name in ipairs(love_callback) do
        if not self[call_name] then
            self[call_name] = function(self,...)
                local area = self.area
                if area then
                    if area[call_name] then
                        area[call_name](area,...)
                    end
                    if area.exe_root_cb then
                        if area.root then
                            if area.root[call_name] then
                                area.root[call_name](area.root,...)
                            end
                        end
                    end
                end
            end
        end
    end
end

function ui_mng:set_origin(ox,oy)
    self.ox = ox or 0
    self.oy = oy or 0
    return self
end

function ui_mng:add_controls(controls)
    self:add_node(controls,self.__view_id)
    controls:release("add_to_scene",self)
end

function ui_mng:remove_controls(controls)
    self:add_remove(area)
    controls:release("remove_from_scene",self)
end

function ui_mng:update(dt)
    if self.area then
        if not self.area.locking then
            area_mng.update(self,dt)
        end
    else
        area_mng.update(self,dt)
    end

    if self.area then
        if self.area.update then
            self.area:update(dt)
        end
    end
end

return ui_mng