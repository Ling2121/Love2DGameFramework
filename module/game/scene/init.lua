--[[
    场景(节点管理器)
--]]
local list = require"module/struct/depth_list"
local camera = require"module/game/camera"
local signal = require"misc/signal"

local scene = class("scene",signal){
    scene_name = "",
    nodes = nil,
    static_node = {},
    __is_init = false,
    __is_update = true,
    __at_game_mng = nil,
}

function scene:__init(name)
    self.nodes = list()
    self.scene_name = name
    self:add_node(camera():set_node_name("camera"),true)
    self:__init_signal__()
    self:__init_callback__()
    self:connect(self,"scene_init","init")
    self:connect(self,"scene_load","load")
end

function scene:__init_callback__()
    for _,call_name in ipairs(love_callback) do
        if not self[call_name] then
            self[call_name] = function(self,...)
                if self.__is_update then
                    for node in self.nodes:items() do
                        if node[call_name] then
                            node[call_name](node,...)
                        end
                    end
                end
            end
        end
    end
end

function scene:__init_signal__()
    self:signal("scene_init")
    self:signal("scene_load")
    self:signal("scene_enter")
    self:signal("scene_exit")
end

function scene:init()end--第一次加载场景时执行

function scene:load()end--加载场景时执行

function scene:get_node(name)--通过名称获取节点,节点如果没命名，默认是他本身
    return self.nodes.__all_node[name]
end

function scene:add_node(node,is_static)
    local node_name = node.__node_name or node
    if not is_static then
        node.__is_static = false
        self.nodes:insert_node(node)
        :_enter_scene(self)
        :set_node_name(node_name)
    else
        node.__is_static = true
        self.nodes.__all_node[node] = node
        self.nodes.__all_node[node.__node_name] = node
    end
    node:release("add_to_scene",self)
    return self
end

function scene:remove_node(node_or_name)
    if node_or_name then
        local nodes = self.nodes
        local node = nodes.__all_node[node_or_name]

        if node then
            if node.__is_static then
                self.nodes.__all_node[node] = node
                self.nodes.__all_node[node.__node_name] = node
            else
                nodes:remove_self(node)
                nodes.__all_node[node.__node_name] = nil
            end
            node:release("remove_from_scene",self)
        end
    end
end

function scene:update(dt)
    if self.__is_update then
        for node in self.nodes:items() do
            if node.__depth_change then
                self:_set_node_depth(node)
            end
            if node.update then
                node:update(dt)
            end
        end
    end 
end

function scene:draw()
    for node in self.nodes:items() do
        if node.draw then
            local view_id = node.__view_id
            local camera = self:get_node("camera")
            if view_id == 1 then
                camera:draw_begin()
                node:draw()
                camera:draw_end()
            elseif view_id == 2 then
                node:draw()
            end
        end
    end
end

return scene
