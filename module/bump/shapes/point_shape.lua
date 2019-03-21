local shape = require"module/bump/shapes/shape"

local point_shape = point("point"){
    _pos = {x = 0,y = 0},
}

function point_shape:init(x,y)
	Shape.init(self, 'point')
	self._pos = {x = x, y = y}
end

function point_shape:collidesWith(other)
	if self == other then return false end
	if other._type == 'point' then
		return (self._pos == other._pos), 0,0
	end
	return other:contains(self._pos.x, self._pos.y), 0,0
end

function point_shape:contains(x,y)
	return x == self._pos.x and y == self._pos.y
end

function point_shape:intersectsRay(x,y, dx,dy)
	local px,py = self._pos.x-x, self._pos.y-y
	local t = px/dx
	-- see (px,py) and (dx,dy) point in same direction
	return (t == py/dy), t
end

function point_shape:intersectionsWithRay(x,y, dx,dy)
	local intersects, t = self:intersectsRay(x,y, dx,dy)
	return intersects and {t} or {}
end

function point_shape:center()
	return self._pos.x, self._pos.y
end

function point_shape:outcircle()
	return self._pos.x, self._pos.y, 0
end

function point_shape:bbox()
	local x,y = self:center()
	return x,y,x,y
end

function point_shape:move(x,y)
	self._pos.x = self._pos.x + x
	self._pos.y = self._pos.y + y
end

function point_shape:scale()
	-- nothing
end

function point_shape:draw()
	love.graphics.point(self:center())
end

return point_shape