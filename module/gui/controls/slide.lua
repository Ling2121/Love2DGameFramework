local base_ui = ling_import"module/gui/controls/base_ui"
local button = ling_import"module/gui/controls/button"
local rect = ling_import"module/graphics/rect"

local slide = class("slide",base_ui){
    max = 10,
    value = 0,
    add_value = 0,
    slide_button = nil,
    is_draw_value = false,
}

function slide:__init(mode,x,y,w,h,max,style)
    base_ui.__init(self,x,y,w,h)
    self.max = max or 10
    self:_init_style(mode,style)
    self:set_max(max)
    self:connect(self,"add_to_scene","__add_to_scene__")
    self:connect(self,"mouse_exit","__mouse_exit__")
    self:connect(self,"remove_from_scene","__remove_from_scene__")
end

function slide:_init_style(mode,style)
    local sdb_w = self.w / 10
    local sdb_h = self.h
    style = style or {}
    style.button = style.button or {}
    self.style.button = {}
    self.mode = mode or "H" --H :horizontal V:vertical
    if mode == "V" then
        sdb_w = self.w
        sdb_h = self.h / 10
    end
    self.sdb_w = sdb_w
    self.sdb_h = sdb_h

    local r = rect("fill",sdb_w,sdb_h,{210,70,0,255})
    self.style.font             = style.font
    self.style.font_color       = style.font_color or {104,18,0,255}
    self.style.slide            = style.slide or rect("fill",self.w,self.h,{255,123,0,255})
    self.style.box              = style.box or rect("line",self.w,self.h,{210,70,0,255})
    self.style.button.default   = style.button.default or r
    self.style.button.hover     = style.button.hover or r
    self.style.button.hit       = style.button.hit or r

    self.slide_button = button("",0,0,sdb_w,sdb_h,{
        default = self.style.button.default,
        hover   = self.style.button.hover,
        hit     = self.style.button.hit
    })
    :set_drag(true)
    :set_root(self)
    :set_depth(self.y + 1)
    self.slide_button.draw = nil

    if mode == "V" then
        function self.slide_button:drag_move()
            local mox,moy = love.mouse.getPosition()
            local root = self.root
            local rx,ry = root:get_transform_pos()
            local y = moy - self._drag_ofs.y 
            if y > ry - 1 and y < ry + root.h - self.h + 1 then
                self.y = y - ry
            end
        end
    else
        function self.slide_button:drag_move()
            local mox,moy = love.mouse.getPosition()
            local root = self.root
            local rx,ry = root:get_transform_pos()
            local x = mox - self._drag_ofs.x 
            if x > rx - 1 and x < rx + root.w - self.w + 1 then
                self.x = x - rx
            end
        end
    end
end

function slide:set_max(max)
    self.max = max or self.max
    if self.mode == "V" then
        self.add_value = self.max / (self.h - self.sdb_h)
    else
        self.add_value = self.max / (self.w - self.sdb_w)
    end
    return self
end

function slide:__add_to_scene__(scene)
    scene:add_controls(self.slide_button)
end

function slide:__remove_from_scene__(scene)
    scene:add_remove(self.slide_button)
end

function slide:__mouse_exit__()
    self.locking = false
end

function slide:set_draw_value(bool)
    self.is_draw_value = true
    return self
end

function slide:get_value()
    local sdbx,sdby = self.slide_button:get_transform_pos()
    local x,y = self:get_transform_pos()
    if self.mode == "V" then
        return (sdby - y)* self.add_value
    end
    return (sdbx - x)* self.add_value
end

function slide:wheelmoved(x,y)
    local sdb = self.slide_button
    local sdtx,sdty = sdb:get_transform_pos()
    local sex,sey = self:get_transform_pos()
    if self.mode == "V" then
        y = -y * (self.h / 30)
        local mvy = sdty + y
        if mvy > sey - 1 and mvy < sey + self.h - sdb.h + 1 then
            sdb.y = sdb.y + y
        end
    else
        y = -y * (self.w / 30)
        local mvx = sdtx + y
        if mvx > sex - 1 and mvx < sex + self.w - sdb.w + 1 then
            sdb.x = sdb.x + y
        end
    end
end

function slide:draw_value(x,y)
    local self_font = self.style.font
    local font = self_font or ling.default_font
    local value = self:get_value()
    if self_font then
        love.graphics.setFont(font)
    end
    love.graphics.setColor(unpack(self.style.font_color))

    if self.mode == "V" then
        love.graphics.print(value,x + self.w / 2 + font:getHeight() / 2,y,math.rad(90))
    else
        love.graphics.print(value,x,y + (self.h / 2 - font:getHeight() / 2))
    end
    
    love.graphics.setColor(255,255,255,255)
    if self_font then
        love.graphics.setFont(ling.default_font)
    end
end

function slide:draw()
    local x,y = self:get_transform_pos()
    self.style.slide:draw(x,y)
    local up_lw = love.graphics.getLineWidth()
    love.graphics.setLineWidth(3)
    self.style.box:draw(x,y)
    love.graphics.setLineWidth(up_lw)
    button.draw(self.slide_button)
    if self.is_draw_value then
        self:draw_value(x,y)
    end
end

return slide

