local base_ui = require"module/gui/component/base_ui"
local rectangle = require"module/graphics/rectangle"
local button = require"module/gui/component/button"

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
    :set_depth(self.y)
    self:connect(self,"mouse_exit","__mouse_exit__")
    self:connect(self.slide_button,"sliding","__btn_sliding__")
    self:connect(self,"add_to_box","__add__")
    self:connect(self,"remove_from_box","__remove__")
    self:signal("drag")
end

function slide:__btn_sliding__()
    local v = self:get_value()
    self:release("drag",v)
end

function slide:__add__(box)
    box:add_component(self.slide_button:set_depth(self:get_depth() + 1))
end

function slide:__remove__(box)
    box:remove_component(self.slide_button)
end

function slide:_init_style(mode,style)
    local sdb_w = self.width / 10
    local sdb_h = self.height
    style = style or {}
    style.button = style.button or {}
    self.style.button = {}
    self.mode = mode or "H" --H :horizontal V:vertical
    if mode == "V" then
        sdb_w = self.width
        sdb_h = self.height / 10
    end
    self.sdb_w = sdb_w
    self.sdb_h = sdb_h

    local r = rectangle("fill",sdb_w,sdb_h,{210,70,0,255})
    self.style.font             = style.font
    self.style.font_color       = style.font_color or {226,101,11,255}
    self.style.box              = style.box or rectangle("line",self.width,self.height,{226,101,11,255})
    self.style.bg               = style.bg or rectangle("fill",self.width,self.height,{255,215,155,255})
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

    if mode == "V" then
        function self.slide_button:drag_move()
            local mox,moy = love.mouse.getPosition()
            local root = self.root
            local rx,ry = root:get_pos()
            local y = ry + moy - self._drag_ofs.y 
            if y >= 0 and y > ry - 1 and y < ry + root.height - self.height + 1 then
                self.y = moy - self._drag_ofs.y 
            end
        end
    else
        function self.slide_button:drag_move()
            local mox,moy = love.mouse.getPosition()
            local root = self.root
            local rx,ry = root:get_pos()
            local x = rx + mox - self._drag_ofs.x 
            if x >= 0 and x > rx - 1 and x < rx + root.width - self.width + 1 then
                self.x = mox - self._drag_ofs.x 
            end
        end
    end
end

function slide:set_max(max)
    self.max = max or self.max
    if self.mode == "V" then
        self.add_value = self.max / (self.height - self.sdb_h)
    else
        self.add_value = self.max / (self.width - self.sdb_w)
    end
    return self
end

function slide:__mouse_exit__()
    self.locking = false
end

function slide:set_draw_value(bool)
    self.is_draw_value = bool
    return self
end

function slide:set_value(v)
    if v >= 0 and v <= self.max then
        if self.mode == "V" then
            self.slide_button.y = v
        else
            self.slide_button.x = v / self.add_value
        end
    end
end

function slide:get_value()
    if self.mode == "V" then
        return math.min(math.max(self.slide_button.y * self.add_value,0),self.max)
    end
    return math.min(math.max(self.slide_button.x * self.add_value,0),self.max)
end

function slide:wheelmoved(x,y)
    local sdb = self.slide_button
    local sdtx,sdty = sdb:get_pos()
    local sex,sey = self:get_pos()
    if self.mode == "V" then
        y = -y * (self.height / 30)
        local mvy = sdty + y
        if mvy > sey - 1 and mvy < sey + self.height - sdb.height + 1 then
            sdb.y = sdb.y + y
        end
    else
        y = -y * (self.width / 30)
        local mvx = sdtx + y
        if mvx > sex - 1 and mvx < sex + self.width - sdb.width + 1 then
            sdb.x = sdb.x + y
        end
    end
    self.locking = true
end

function slide:update()
    if self.locking then
        if not self:is_hover() then
            self.locking = false
        end
    end
end

function slide:draw_value(x,y)
    local self_font = self.style.font
    local font = self_font or ling.font.default
    local value = string.format("%.0f",self:get_value())
    if self_font then
        love.graphics.setFont(font)
    end
    love.graphics.setColor(unpack(self.style.font_color))

    if self.mode == "V" then
        love.graphics.print(value,x + self.width / 2 + font:getHeight() / 2,y + self.height + 2,math.rad(90))
    else
        love.graphics.print(value,x + self.width + 2,y + (self.height / 2 - font:getHeight() / 2))
    end
    
    love.graphics.setColor(255,255,255,255)
    if self_font then
        love.graphics.setFont(ling.default_font)
    end
end

function slide:draw()
    local x,y = self:get_pos()
    self.style.bg:draw(x,y)
    self.style.box:draw(x,y)
    if self.is_draw_value then
        self:draw_value(x,y)
    end
end

return slide

