local shape = class("shape"){
    _type = nil,
    _rotation = 0,
    _id = 0,
    _layer = 0,
}

function shape:__init(t)
    self._type = t
    self._id = self
    self._layer =0
end

function shape:set_id(id)
    self._id = id or self._id
    return self
end

function shape:get_id()
    return self._id
end

function shape:set_layer(layer)
    self._layer = layer or self._layer
    return self
end

function shape:get_layer()
    return self._layer
end

function shape:moveTo(x,y)
	local cx,cy = self:center()
	self:move(x - cx, y - cy)
end

function shape:rotation()
	return self._rotation
end

function shape:rotate(angle)
	self._rotation = self._rotation + angle
end

function shape:setRotation(angle, x,y)
	return self:rotate(angle - self._rotation, x,y)
end

return shape