local base_ui = require"module/gui/controls/base_ui"
local area_mng = require"misc/area/area_mng"

local ui_box = class("ui_box",base_ui,area_mng){
    __ui_mng = true,
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
    if not contrls.__ui_mng then
        for child in pairs(contrls.child) do
            self:add_controls(child)
        end
    end
    return self
end

function ui_box:remove_contrls(contrls)
    area_mng.remove_area(self,contrls)
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
    if sx == 0 or sx == 0 then
        love.graphics.setScissor(world_x,world_y,self.width,self.height)
    else
        if world_x > sx or world_y > sy then
            local w,h = sw - (world_x - sx),sh - (world_y - sy)
            love.graphics.setScissor(world_x,world_y,w,h)
        else
            local w,h = ((world_x + self.width) - sx),((world_y + self.height) - sy)
            love.graphics.setScissor(sx,sy,w,h)
        end
    end
    for ui in self.all_area:items() do
        ui:draw()
    end
    love.graphics.setScissor(sx, sy, sw, sh)
    love.graphics.rectangle("line",x,y,self.width,self.height)
end

return ui_box

