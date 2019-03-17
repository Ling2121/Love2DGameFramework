local scene = require"module/game/scene"
local signal = require"misc/signal"

local game = class("game",signal){--
    all_scene = {},
    scene = nil,
}

function game:__init()
    self:signal("change_scene")

    for i,call_name in ipairs(love_callback) do
        love[call_name] = function(...)
            local scene = self.scene
            if scene then
                if scene[call_name] then
                    scene[call_name](scene,...)
                end
            end
        end
    end
    return self
end

function game.new_scene(name)
    return scene(name)
end

function game.new_game()
    return game()
end

function game:add_scene(scene)
    if not scene then return end
    scene.__at_game_mng = self
    self.all_scene[scene.scene_name] = scene
    return self
end

function game:change_scene(name_or_scene)
    local cs = self.all_scene[name_or_scene] or name_or_scene
    self:release("change_scene",self.scene,cs)
    if not cs.__is_init then
        cs:release("scene_init",cs)
        cs.__is_init = true
    end
    cs:release("scene_load",cs)
    self.scene = cs
    return self
end

function get_node(name)--获取当前场景的节点
    return ling.game.scene:get_node(name)
end

function get_scene()
    return ling.game.scene
end

function get_game()
    return ling.game
end

ling.game = game:__init()
return ling.game

