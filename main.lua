local ling = require"ling_init"
local rectangle = require"module/graphics/rectangle"
local game = require"module/game"
local scene = require"module/game/scene"("test_scene")
local ui_box = require"module/gui/component/ui_box"
local ui_mng = require"module/gui/ui_mng"():set_view(1)
local node2d = require"module/game/scene/node2d"
local base_ui = require"module/gui/component/base_ui"

local label = require"module/gui/component/label"
local button = require"module/gui/component/button"
local input = require"module/gui/component/input"
local slide = require"module/gui/component/slide"

local cam = scene:get_node("camera")

local ui_box_a = ui_box():set_drag(true)

local ui_x,ui_y = 120,120

local rect = rectangle("fill",100,100)

function push_ui(color,set_color_i)
    local w = 160
    local h = 30
    local iw,ih = w * 0.8,h * 0.8
    local sw,sh = iw,h * 0.2
    local inp = input(ui_x,ui_y,iw,ih)
    local sli = slide("H",0,ih,sw,sh,255):set_root(inp):set_draw_value(true)
    local box_c = color
    local bg_c = {box_c[1] / 2,box_c[2] / 2,box_c[3] / 2,box_c[4] / 2}
    inp.style.box:set_color(box_c)
    inp.style.bg:set_color(bg_c)
    sli.style.box:set_color(box_c)
    sli.style.bg:set_color(bg_c)
    ui_y = ui_y + h

    inp:connect(sli,"drag","__drag__")
    sli:connect(inp,"input","__input__")
    inp.input_text = tostring(rect.color[set_color_i])
    sli:set_value(rect.color[set_color_i])

    function inp:__drag__(value)
        self.input_text = tostring(string.format("%.0f",value))
        rect.color[set_color_i] = value
    end

    function sli:__input__(text)
        local value = tonumber(text) or 0
        self:set_value(value or 0)
        rect.color[set_color_i] = value
    end

    ui_box_a:add_component(inp)
    ui_box_a:add_component(sli)
end


local r = push_ui({255,1,1,255},1)
local g = push_ui({1,255,1,255},2)
local a = push_ui({1,1,255,255},3)



ui_mng:add_component(ui_box_a)
scene:add_node(ui_mng)
scene:add_node(class("test",node2d){
    draw = function()
        rect:draw(ui_x + 300,120)
    end
}():set_view(1))

game:add_scene(scene)
:change_scene("test_scene")


