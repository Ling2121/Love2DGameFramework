local base_ui = ling_import"module/gui/controls/base_ui"
local area_mng = ling_import"misc/area/area_mng"

local ui_box = class("ui_box",base_ui,area_mng){
    origin_x = 0,
    origin_y = 0,
}

function ui_box:__init(x,y,w,h)
    base_ui.__init(self,x,y,w,h);
    area_mng.__init(self)
    self:__init_callback__()
end

function ui_box:__init_callback__()
    for _,call_name in ipairs(love_callback) do
        if not self[call_name] then
            self[call_name] = function(self,...)
                if self.area then
                    self.area[call_name](self.area)
                end
            end
        end
    end
end

function base_ui:add_contrls(contrls)
    area_mng.add_area(contrls)
    contrls.__view_id = self.__view_id
    return self
end

function ui_box:get_origin()
    return self:get_pos()
end

function ui_box:update(dt)
    area_mng.update(self,dt)
    if self.area then
        self.area:update(dt)
    end
end

function ui_box:draw()
    local x,y = self:get_pos()
    local dx,dy,dw,dh = x + self.display_x,y + self.display_y,self.display_w,self.display_h
    local sx, sy, sw, sh = love.graphics.getScissor()
    for ui in self.all_area:items() do
        ui:draw()
    end
    love.graphics.setScissor(sx, sy, sw, sh)
end

return ui_box

