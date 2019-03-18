local ling = require"ling_init"
local rectangle = require"module/graphics/rectangle"
local game = require"module/game"
local scene = require"module/game/scene"("test_scene")
local ui_box = require"module/gui/component/ui_box"
local ui_mng = require"module/gui/ui_mng"():set_view(1)
local node2d = require"module/game/scene/node2d"
local base_ui = require"module/gui/component/base_ui"
local window = require"module/gui/component/window"

local label = require"module/gui/component/label"
local button = require"module/gui/component/button"
local input = require"module/gui/component/input"
local slide = require"module/gui/component/slide"

local cam = scene:get_node("camera")

local ui_box_a = ui_box():set_drag(true)
local label_a = label("LABEL",100,70)
local button_a = button("BUTTON",100,300,110,40)
local input_a = input(100,150,120,30)
local slide_a = slide("H",100,190,180,10,233):set_draw_value(true)
local window_a = window("WINDOW",100,210,640 * 0.6,480 * 0.6):set_drag(true)

ui_box_a:add_component(label_a)
window_a:add_component(button_a)
ui_box_a:add_component(input_a)
ui_box_a:add_component(slide_a)
ui_box_a:add_component(window_a)

ui_mng:add_component(ui_box_a)
scene:add_node(ui_mng)

game:add_scene(scene)
:change_scene("test_scene")


