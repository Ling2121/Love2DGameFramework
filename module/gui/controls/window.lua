local base_ui = ling_import"module/gui/controls/base_ui"
local rect = ling_import"module/graphics/rect"
local button = ling_import"module/gui/controls/button"
local slide = ling_import"module/gui/controls/slide"
local ui_mng = ling_import"module/gui/ui_mng"
local list = ling_import"misc/list"

local function init_silde(self,_slide)
    _slide.style.slide.color = self.style.window_fg
    _slide.style.box.color = self.style.window_color
    local sdb = _slide.slide_button
    sdb.style.default.color = self.style.window_color
    sdb.style.hover.color = self.style.window_color
    sdb.style.hit.color = self.style.window_color

    _slide.exe_root_cb = false
    _slide:set_depth(10000)
    sdb:set_depth(10000 + 1)

    function _slide:wheelmoved(x,y)
        slide.wheelmoved(self,x,y)
        if self.mode == "V" then
            self.root:__vs_sliding__()
        else
            self.root:__hs_sliding__()
        end
    end
    return _slide
end

local window = class("window",ui_mng,base_ui){
    top = nil,
    top_x = 0,
    top_y = 0,
    top_w = 0,
    top_h = 0,
    display_x = nil,
    display_y = nil,
    display_w = nil,
    display_h = nil,
    content_w = 0,
    content_h = 0,
    vs_value = 0,
    hs_value = 0
}

function window:__init(title,x,y,w,h,content_w,content_h,style)
    base_ui.__init(self,x,y,w,h)
    self.nodes = list()
    self:set_origin(self.x,self.y)
    self:_init_style(title,style)
    self:__init_callback__()
    self:set_content_box(content_w,content_h)
    self:connect(self.style.v_slide.slide_button,"sliding","__vs_sliding__")
    self:connect(self.style.h_slide.slide_button,"sliding","__hs_sliding__")
    self:connect(self,"add_to_scene","__add_to_scene__")
end

function window:_init_style(title,style)
    local w,h = self.w,self.h
    local top_x = 0
    local top_y = 0
    local top_w = w
    local top_h = h / 15
    local v_sd_w = w / 18
    local v_sd_h = h - top_h 
    local v_sd_x = w - v_sd_w
    local v_sd_y = top_y + top_h

    local h_sd_w = top_w - v_sd_w
    local h_sd_h = v_sd_w
    local h_sd_x = top_x
    local h_sd_y = h - h_sd_h
    style = style or {}
    self.top_x = top_x
    self.top_y = top_y
    self.top_w = top_w
    self.top_h = top_h
    self.display_x = top_x
    self.display_y = top_y + top_h
    self.display_w = w - v_sd_w
    self.display_h = h - h_sd_h - top_h
    self.title = title or "Window"
    self.style.font         = style.font
    self.style.font_color   = style.font_color or {104,18,0,255}
    self.style.window_color = style.window_color or {210,70,0,255}
    self.style.window_fg = style.window_fg or {255,123,0,255}
    self.style.window_bg = style.window_bg or {255,150,0,255}
    self.style.v_slide = init_silde(self,slide("V",v_sd_x,v_sd_y,v_sd_w,v_sd_h)):set_root(self)
    self.style.h_slide = init_silde(self,slide("H",h_sd_x,h_sd_y,h_sd_w,h_sd_h)):set_root(self)
end

function window:set_origin(ox,oy)
    self.ox = (ox or 0)
    self.oy = (oy or 0) + self.top_h
    return self
end

function window:__vs_sliding__()
    self.vs_value = self.style.v_slide:get_value()
    self:set_origin(self.x - self.hs_value,self.y - self.vs_value)
end

function window:__hs_sliding__()
    self.hs_value = self.style.h_slide:get_value()
    self:set_origin(self.x - self.hs_value,self.y - self.vs_value)
end

function window:wheelmoved(x,y)
    if love.keyboard.isDown("lalt") then
        self.style.h_slide:wheelmoved(x,y)
        self:__hs_sliding__()
    else
        self.style.v_slide:wheelmoved(x,y)
        self:__vs_sliding__()
    end
end

function window:__add_to_scene__(scene)
    self.camera = scene.camera
    scene:add_controls(self.style.h_slide)
    scene:add_controls(self.style.v_slide)

    for ui in self.nodes:items() do
        ui.__view_id = self.__view_id
    end
end

function window:is_hover_display()
    local sex,sey = self:get_world_pos()
    local mox,moy = love.mouse.getPosition()
    local x,y,w,h = sex + self.display_x,sey + self.display_y,self.display_w,self.display_h
    return mox > x and moy > y and mox < x + w and moy < y + h
end

function window:is_hover_top()
    local sex,sey = self:get_world_pos()
    local mox,moy = love.mouse.getPosition()
    local x,y,w,h = sex + self.top_x,sey + self.top_y,self.top_w,self.top_h
    return mox > x and moy > y and mox < x + w and moy < y + h
end

function window:set_content_box(w,h)
    self.content_w = w or self.w
    self.content_h = h or self.h
    self.style.h_slide:set_max(self.content_w)
    self.style.v_slide:set_max(self.content_h)
end

function window:mousepressed(mox,moy)
    if self:is_hover_top() then
        base_ui.mousepressed(self,mox,moy)
    end

    local area = self.area
    if area and area.mousepressed then
        area:mousepressed(mox,moy)
    end
end

function window:mousereleased(mox,moy)
    base_ui.mousereleased(self,mox,moy)
    local area = self.area
    if area and area.mousereleased then
        area:mousereleased(mox,moy)
    end
end

function window:update(dt)
    if self:is_hover_display() then
        ui_mng.update(self,dt)
    end
    base_ui.update(self)
    self:set_origin(self.x - self.hs_value,self.y - self.vs_value)
end

function window:draw_title(x,y)
    local self_font = self.style.font
    local font = self_font or ling.default_font
    x = x + self.top_x + font:getWidth("A")
    y = y + self.top_y + (self.top_h / 2 - font:getHeight() / 2)
    if self_font then
        love.graphics.setFont(font)
    end
    love.graphics.setColor(unpack(self.style.font_color))
    love.graphics.print(self.title,x,y)
    love.graphics.setColor(255,255,255,255)
    if self_font then
        love.graphics.setFont(ling.default_font)
    end
end

function window:draw_top(x,y)
    local wcolor = self.style.window_color
    local w,h = self.top_w,self.top_h
    local tx,ty = x + self.top_x,y + self.top_y
    love.graphics.setColor(unpack(wcolor))
    love.graphics.rectangle("fill",tx,ty,w,h)
    local up_lw = love.graphics.getLineWidth()
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line",tx,ty,self.w,self.h)
    love.graphics.setLineWidth(up_lw)
    self:draw_title(x,y)
    love.graphics.setColor(255,255,255,255)
end

function window:draw()
    local x,y = self:get_transform_pos()
    local dx,dy,dw,dh = x + self.display_x,y + self.display_y,self.display_w,self.display_h
    local sx, sy, sw, sh = love.graphics.getScissor()
    love.graphics.setScissor(dx,dy,dw,dh)
    love.graphics.setColor(unpack(self.style.window_bg))
    love.graphics.rectangle("fill",dx,dy,dw,dh)
    love.graphics.setColor(255,255,255,255)
    ui_mng.draw(self)
    love.graphics.setScissor(sx, sy, sw, sh)
    self:draw_top(x,y)
end

return window