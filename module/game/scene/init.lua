local list = ling_import"misc/depth_list"
local camera = ling_import"library/camera"
local signal = ling_import"misc/signal"

local scene = class("scene"){
    scene_name = "",
    nodes = {},
    __is_init = false,
    __is_update = true,
    __at_game_mng = nil,
}

function scene:__init(name)
    self.camera = camera()
    self.scene_name = name
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
    self:signal("node_add")
    self:signal("node_remove")
    self:signal("scene_init")
    self:signal("scene_load")
    self:signal("scene_enter")
    self:signal("scene_exit")
end

function scene:init()end--第一次加载场景时执行

function scene:load()end--加载场景时执行

function scene:get_node(name)
    return self.nodes.__all_node[name]
end

function scene:add_node(node,view_id)
    local node_name = node.__node_name or node
    self.nodes:insert_node(node)
    :_enter_scene(self)
    :set_node_name(node_name)
    :set_view(view_id or node.__view_id)

    self:release("add_node",node)
end

function scene:remove_node(node_or_name)
    if node_or_name then
        local nodes = self.nodes
        local node = nodes.__all_node[node_or_name]
        if node then
            nodes:remove_self(node)
            nodes.__all_node[node.__node_name] = nil

            self:release("remove_node",node)
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
            if view_id == 1 then
                self.camera:attach()
                node:draw()
                self.camera:detach()
            elseif view_id == 2 then
                node:draw()
            end
        end
    end
end

return scene
