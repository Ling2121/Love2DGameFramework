local ling = require"ling_init"

local game = require"module/game"()
local scene = require"module/game/scene"("test_scene")
local ui_box = require"module/gui/ui_box"():set_drag(true):set_view(1)
local label = require"module/gui/controls/label"

local cam = scene:get_node("camera")
cam:lookAt(0,0)

local label_a = label("Hello",0,0,{
    font_color = {100,100,0,255},
}):set_drag(true)

local label_b = label("Hello",100,100,{
    font_color = {100,100,0,255},
}):set_drag(true):set_root(label_a)

ui_box:add_controls(label_a)
ui_box:add_controls(label_b)
scene:add_node(ui_box)

game:add_scene(scene)
:change_scene("test_scene")


