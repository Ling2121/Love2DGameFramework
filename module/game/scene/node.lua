local depth_node = require"module/struct/depth_list/node"

local node = class("scene_node",depth_node,signal){
    __node_name = nil,
    __at_scene = nil,
    __wait = false,
}

function node:__init(name)
    self.__node_name = name or self
    self:__init_signal__()
end

function node:__init_signal__()
    self:signal("enter_wait")
    self:signal("exit_wait")
    self:signal("exit_scene")
    self:signal("exit_scene")
end

function node:set_node_name(name)
    name = name or self
    local at_scene = self.__at_scene
    if at_scene then
        local nodes = at_scene.nodes
        if not nodes.__all_node[name] then
            nodes.__all_node[name] = self
        end
    end
    self.__node_name = name
    return self
end

function node:get_node(name)
    if name and self.__at_scene then
        return self.__at_scene:get_node(name)
    end
end

function node:_enter_wait()
    self.__wait = true
    return self
end

function node:_exit_wait()
    self.__wait = false
    return self
end

function node:_enter_scene(scene)
    self.__at_scene = scene
    self:release("enter_scene",self,self.__at_scene)
    return self
end

function node:_exit_scene()
    self:release("exit_scene",self,self.__at_scene)
    self.__at_scene = nil
    return self
end

return node
