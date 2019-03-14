local base_ui = require"module/gui/controls/base_ui"
local area_mng = require"misc/area/area_mng"

local ui_box = class("ui_box",base_ui,area_mng){
    origin_x = 0,
    origin_y = 0,
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

function ui_box:add_controls(contrls)
    area_mng.add_area(self,contrls)
    contrls.__view_id = self.__view_id
    if not contrls.root then
        contrls.root = self
    end
    contrls.__at_box = self
    return self
end

function ui_box:remove_contrls(contrls)
    area_mng.remove_area(self,contrls)
    contrls.__at_box = nil
    return self
end

function ui_box:mousepressed(...)
    if self.__is_select then
        base_ui.mousepressed(self,...)
    end
    local area = self.area
    if area and area.mousepressed then
        area:mousepressed(...)
    end
end

function ui_box:mousereleased(...)
    if self.__is_select then
        base_ui.mousereleased(self,...)
    end
    local area = self.area
    if area and area.mousereleased then
        area:mousereleased(...)
    end
end

function ui_box:update(dt)
    if not self.root then
        self.__is_select = self:is_hover()
    end

    local area = self.area
    if area then
        if area.update then
            area:update(dt)
        end
        if not area.locking then
            area_mng.update(self,dt)

            if self.__is_select then
                base_ui.update(self,dt)
            end
        end
    else
        area_mng.update(self,dt)
        base_ui.update(self,dt)
    end
end

function ui_box:draw()
    local x,y = self:get_wpos()
    local sx, sy, sw, sh = love.graphics.getScissor()
    love.graphics.setScissor(x,y,self.width,self.height)
    for ui in self.all_area:items() do
        ui:draw()
    end
    love.graphics.setScissor(sx, sy, sw, sh)
    love.graphics.rectangle("line",self.x,self.y,self.width,self.height)
end

return ui_box

