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
    return self
end

function ui_box:remove_contrls(contrls)
    area_mng.remove_area(self,contrls)
    return self
end

function ui_box:get_origin()
    return self:get_pos()
end

function ui_box:mousepressed(...)
    base_ui.mousepressed(self,...)
    local area = self.area
    if area and area.mousepressed then
        area:mousepressed(...)
    end
end

function ui_box:mousereleased(...)
    base_ui.mousereleased(self,...)
    local area = self.area
    if area and area.mousereleased then
        area:mousereleased(...)
    end
end

function ui_box:update(dt)
    base_ui.update(self,dt)
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

function ui_box:draw()
    local x,y = self:get_pos()
    local sx, sy, sw, sh = love.graphics.getScissor()
    love.graphics.setScissor(x,y,self.width,self.height)
    for ui in self.all_area:items() do
        ui:draw()
    end
    love.graphics.rectangle("line",x,y,self.width,self.height)
    love.graphics.setScissor(sx, sy, sw, sh)
end

return ui_box

