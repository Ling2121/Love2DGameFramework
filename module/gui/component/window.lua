local ui_box = require"module/gui/component/ui_box"
local base_ui = require"module/gui/component/base_ui"
local slide = require"module/gui/component/slide"
local rectangle = require"module/graphics/rectangle"

local window = class("window",ui_box){
    style = {
        font = nil,
        font_color = nil,
        box = nil,
        bg = nil,
    },
    title_text = "Hello",
    title_text_x = nil,
    title_text_y = nil,
    title_rect = nil,
    content_box = nil,
    x_slide = nil,
    y_slide = nil,
    close_button = nil,

    max_x = 0,
    max_y = 0,
}

function window:__init(title,x,y,w,h,style)
    ui_box.__init(self,0,0,w or 640,h or 480)
    self:_init_style(style)
    local depth = self.y
    local font = self.style.font

    local title_x = 0
    local title_y = 0
    local title_w = self.width
    local title_h = self.height * (1/14)

    local title_t_x = 2
    local title_t_y = title_h / 2 - font:getHeight() / 2

    local y_slide_w = self.width * (1/20)
    local y_slide_h = self.height - title_h
    local y_slide_x = title_w - y_slide_w
    local y_slide_y = title_h

    local x_slide_w = title_w - y_slide_w
    local x_slide_h = y_slide_w
    local x_slide_x = title_x
    local x_slide_y = self.height - x_slide_h

    self.title_text_x = title_t_x
    self.title_text_y = title_t_y
    self.title_rect = base_ui(x,y,title_w,title_h):set_depth(depth + 1)--:set_drag(true)
    self.x_slide = slide("H",x_slide_x,x_slide_y,x_slide_w,x_slide_h):set_depth(depth + 2)
    self.y_slide = slide("V",y_slide_x,y_slide_y,y_slide_w,y_slide_h):set_depth(depth + 3)
    self.content_box = ui_box(title_x,title_y,self.width,self.height):set_depth(depth - 1)


    self            :set_root(self.title_rect)
    self.x_slide    :set_root(self.title_rect)
    self.y_slide    :set_root(self.title_rect)
    self.content_box:set_root(self.title_rect)
    self.title_rect.draw = nil
    self.content_box.style.bg = self.style.bg.color
    ui_box.add_component(self,self.content_box)
    self:connect(self,"add_to_box","__add__")
    self:connect(self,"remove_from_box","__remove__")
    self:connect(self.x_slide,"drag","__x_drag__")
    self:connect(self.y_slide,"drag","__y_drag__")

    function self.content_box:draw()
        local x,y = self:get_pos()
        love.graphics.setColor(unpack(self.style.bg))
        love.graphics.rectangle("fill",x - 10,y - 10,self.width + 10,self.height + 10)
        love.graphics.setColor(255,255,255,255)
        ui_box.draw(self)
    end
    self.max_x = self.width + 10
    self.max_y = self.height + 10
end

function window:_init_style(style)
    style = style or {}
    local w,h = self.width,self.height
    self.style.font         = ling.font.default
    self.style.font_color   = style.font_color or {255,215,155,255}
    self.style.box          = style.box or rectangle("line",w,h,{255,116,12,255})
    self.style.bg           = style.bg or rectangle("fill",w,h,{255,215,155,255})
end

function window:__add__(box)
    box:add_component(self.title_rect)
    box:add_component(self.y_slide)
    box:add_component(self.x_slide)
end

function window:__remove__(box)
    box:remove_component(self.title_rect)
    box:remove_component(self.x_slide)
    box:remove_component(self.y_slide)
end

function window:__x_drag__(v)
    self.content_box.x = -v
end

function window:__y_drag__(v)
    self.content_box.y = -v
end

function window:update_content_x_max(component)
    local x = component.x + component.width
    if x > self.max_x then
        self.max_x = x
        self.content_box.width = x + component.width
        self.x_slide:set_max(self.content_box.width - self.width)
    end
end

function window:update_content_y_max(component)
    local y = component.y + component.height
    if y > self.max_y then
        self.max_y = y
        self.content_box.height = y + component.height
        self.y_slide:set_max(self.content_box.height - self.height)
    end
end

function window:set_drag(bool)
    self.title_rect:set_drag(bool)
    return self
end

function window:add_component(component)
    self.content_box:add_component(component)
    self:update_content_x_max(component)
    self:update_content_y_max(component)
end

function window:remove_component(component)
    self.content_box:remove_component(component)
end

function window:wheelmoved(x,y)
    if love.keyboard.isDown("lshift") then
        self.x_slide:wheelmoved(x,y)
    else
        self.y_slide:wheelmoved(x,y)
    end
end

function window:draw_title()
    local sx,sy = self:get_pos()
    local x,y = self.title_rect:get_pos()
    local title = self.title_text
    local tx,ty = x + self.title_text_x,y + self.title_text_y
    local sf,df = self.style.font,ling.font.default
    local is_set = (sf ~= df)
    if is_set then
        love.graphics.setFont(sf)
    end
    love.graphics.setColor(unpack(self.style.box.color))
    love.graphics.rectangle("fill",sx,sy,self.title_rect.width,self.title_rect.height)
    love.graphics.setColor(unpack(self.style.font_color))
        love.graphics.print(self.title_text,x,y)
    love.graphics.setColor(255,255,255,255)
    if is_set then
        love.graphics.setFont(ling.font.default)
    end
end

function window:draw()     
    ui_box.draw(self)
    self:draw_title()
end

return window