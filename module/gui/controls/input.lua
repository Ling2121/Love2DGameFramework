local base_ui = require"module/gui/controls/base_ui"
local rectangle = require"module/graphics/rectangle"
local utf8 = require"library/utf8_simple"
local lksd = love.keyboard.isDown

local function insert_str(str,pos,ins)
    return utf8.sub(str,0,pos)..ins..utf8.sub(str,pos + 1,utf8.len(str))
end

local input = class("input",base_ui){
    input_text = "",
    final_input = "",--输入完毕的文本
    style = {
        font = nil,
        font_color = nil,
        box = nil,
        background = nil,
    },

    cursor = 0,
    remove_clock = 0,
    remove_speed = 0.06,
    move_speed = 0.08,
    cursor_clock = 0,
    cursor_speed = 0.4,
    cursor_draw = true,
    move_clock = 0,
    text_draw_offset = 0,
}

function input:__init(x,y,w,h,style)
    base_ui.__init(self,x,y,w,h)
    self:_init_style(style)
    self:signal("confirm_input")
end

function input:_init_style(style)
    style = style or {}
    local w,h = self.width,self.height
    self.style.font         = ling.font.default
    self.style.font_color   = style.font_color or {0,150,240,255}
    self.style.box          = style.box or rectangle("line",w,h,{0,150,240,255})
    self.style.bg           = style.bg or rectangle("fill",w,h,{175,215,247,255})
end

function input:update(dt)
    local ish = self:is_hover()
    local isd = love.mouse.isDown(1)
    if ish and isd then
        self.locking = true
    elseif not ish and isd then
        self.locking = false
    end

    if self.locking then
        self.remove_clock = self.remove_clock + dt
        self.cursor_clock = self.cursor_clock + dt
        self.move_clock = self.move_clock + dt

        if self.cursor_clock >= self.cursor_speed then
            self.cursor_clock = 0
            self.cursor_draw = not self.cursor_draw
        end
        if self.remove_clock >= self.remove_speed then
            self.remove_clock = 0
            if lksd("backspace") then
                local pos = self.cursor
                if pos > 0 then
                    local str = self.input_text
                    local r_str = utf8.sub(str,1,pos - 1)
                    local l_str = utf8.sub(str,pos + 1,utf8.len(str))
                    self.input_text = r_str..l_str
                    self.cursor = math.max(0,self.cursor - 1)
                end
            end
        end

        if self.move_clock >= self.move_speed then
            self.move_clock = 0
            if lksd("left") then
                self.cursor = math.max(0,self.cursor - 1)
            elseif lksd("right") then
                self.cursor = math.min(self.cursor + 1,utf8.len(self.input_text))
            end
        end
    end
end

function input:textinput(text)
    if self.locking then
        self.input_text = insert_str(self.input_text,self.cursor,text)
        self.cursor = math.min(self.cursor + 1,utf8.len(self.input_text))
    end
end

function input:keypressed(key)
    if self.locking then
        if key == "return" then
            self.locking = false
            self.final_input = self.input_text
            self.input_text = ""
            self:release("confirm_input",self.final_input)
        end
    end
end

function input:draw_input(x,y)
    local wx,wy = self:get_pos()
    local self_font = self.style.font
    local font = self_font or ling.default_font
    local tx = x
    local ty = y + (self.height / 2 - font:getHeight() / 2)
    local offset = 0
    local cux,cuy = tx,ty
    local tw = font:getWidth(self.input_text)
    local cw = font:getWidth(utf8.sub(self.input_text,1,self.cursor))
    local w = self.width - 4

    if cw - self.text_draw_offset < 0 then
        self.text_draw_offset = cw
    end
    if cw - self.text_draw_offset > w then
        self.text_draw_offset = cw - w
    end

    local sx, sy, sw, sh = love.graphics.getScissor()
    if sx then
        if wx > sx and wy > sy and wx + self.width < sy + sw and wy + self.height < sy + sw then
            love.graphics.setScissor(wx,wy,self.width,self.height)
        end
    end
    
    love.graphics.setColor(unpack(self.style.font_color))
    love.graphics.print(self.input_text,tx - self.text_draw_offset,ty)
    if self.locking and self.cursor_draw then
        cux = (cux + cw - self.text_draw_offset)
        local cuh = self.height * 0.5
        love.graphics.rectangle("fill",cux,wy + self.height / 2 - cuh/2,2,cuh)
        love.graphics.setColor(255,255,255,100)
    end
    love.graphics.setColor(255,255,255,255)
    love.graphics.setScissor(sx, sy, sw, sh)
end

function input:draw()
    local x,y = self:get_pos()
    self.style.bg:draw(x,y)
    local up_lw = love.graphics.getLineWidth()
    love.graphics.setLineWidth(3)
    self.style.box:draw(x,y)
    love.graphics.setLineWidth(up_lw)
    self:draw_input(x,y)
end

return input