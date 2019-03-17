--[[
    碰撞体
--]]
local bump_body = class("bump_body"){
    _id = 0,
    _layer = 0,
    _wait = false,
    shapes = nil,--这是一个HC形状对象
    at_world = nil,
}

function bump_body:__init(shapes,id,layer)
    self.shapes = shapes
    self._id = id or self
    self._layer = layer or 0
end

function bump_body:get_bump_body()
    return self
end

function bump_body:get_shapes()
    return self.shapes
end

function bump_body:enter_wait()
    self._wait = true
    return self
end

function bump_body:exit_wait()
    self._wait = false
    return self
end

function bump_body:get_world()
    return self.at_world
end

function bump_body:set_id(id)
    self._id = id or self._id
    return self
end

function bump_body:set_layer(layer)
    self._layer = layer or self._layer
    return self
end

return bump_body