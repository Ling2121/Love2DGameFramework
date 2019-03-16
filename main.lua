local ling = require"ling_init"

local game = require"module/game"
local scene = require"module/game/scene"("test_scene")
local ui_box = require"module/gui/ui_box"
local ui_mng = require"module/gui/ui_mng"():set_view(1)


local label = require"module/gui/controls/label"
local button = require"module/gui/controls/button"
local input = require"module/gui/controls/input"

local cam = scene:get_node("camera")

local ui_box_a = ui_box():set_drag(true)
local ui_box_b = ui_box():set_drag(true)
local ui_box_c = ui_box():set_drag(true)
cam:lookAt(0,0)

local label_b = label("Hello",100,100):set_drag(true)

local label_a = label("Hello",0,0):set_drag(true)

local button_a = button("Button",200,100,100,40):set_drag(true)

local input_a = input(300,100,120,40)
local input_b = input(300,120,120,40)

ui_box_a:add_controls(input_a)
ui_box_a:add_controls(input_b)

ui_box_b:add_controls(button("Button",200,100,100,40):set_drag(true))
ui_box_c:add_controls(button("Button",200,150,100,40):set_drag(true))

ui_box_b:add_controls(ui_box_c)
ui_box_a:add_controls(ui_box_b)

ui_mng:add_controls(ui_box_a)

scene:add_node(ui_mng)

game:add_scene(scene)
:change_scene("test_scene")


