local base_ui = require"module/gui/component/base_ui"
local area_mng = require"misc/area/area_mng"

local ui_box = class("ui_box",base_ui,area_mng){
    __ui_mng = true,
    __draw_box = false,
}

function ui_box:__init(x,y,w,h)
    base_ui.__init(self,x,y,w or love.graphics.getWidth(),h or love.graphics.getHeight());
    area_mng.__init(self)
    self:__init_callback__()
end

function ui_box:__init_callback__()
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

function ui_box:add_component(component)
    area_mng.add_area(self,component)
    component.__view_id = self.__view_id
    if not component.root then
        component.root = self
    end
    component:release("add_to_box",self)
    return self
end

function ui_box:set_draw_box(bool)
    self.__draw_box = bool
    return self
end

function ui_box:remove_component(component)
    component:release("remove_to_box",self)
    area_mng.remove_area(self,component)
    return self
end

function ui_box:mousepressed(...)
    local area = self.area
    if area then
        if area.mousepressed then
            area:mousepressed(...)
        end
        if not area.locking then
            base_ui.mousepressed(self,...)
        end
    else
        base_ui.mousepressed(self,...)
    end
end

function ui_box:mousereleased(...)
    local area = self.area
    if area then
        if area.mousereleased then
            area:mousereleased(...)
        end
    end
    base_ui.mousereleased(self,...)
end

function ui_box:update(dt)
    local area = self.area

    if area then
        if area.update then
            area:update(dt)
        end
        if not area.locking then
            area_mng.update(self,dt)
            base_ui.update(self,dt)
        end
        self.locking = area.locking
    else
        area_mng.update(self,dt)
        base_ui.update(self,dt)
    end
end

function ui_box:draw()
    local world_x,world_y = self:get_wpos()
    local x,y = self:get_pos()
    local sx, sy, sw, sh = love.graphics.getScissor()
    love.graphics.intersectScissor(world_x,world_y,self.width,self.height)
    for ui in self.all_area:items() do
        if ui.draw then
            ui:draw()
        end
    end
    love.graphics.setScissor(sx, sy, sw, sh)
    if self.__draw_box then
        love.graphics.rectangle("line",x,y,self.width,self.height)
    end
end

return ui_box

