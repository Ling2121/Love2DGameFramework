--[[
    凹多边形形
--]]
local math_min, math_sqrt, math_huge,abs = math.min, math.sqrt, math.huge,math.abs
local shape = require"module/bump/shapes/shape"
local convex_polygon_shape = require"module/bump/shapes/convex_polygon_shape"
local GJK = require"module/bump/gjk"

local concave_polygon_shape = class("concave_polygon_shape",shape){
    _polygon = nil,--polygon object
}

function concave_polygon_shape:__init(polygon)
    shape.__init(self, 'compound')
	self._polygon = polygon
	self._shapes = polygon:splitConvex()
	for i,s in ipairs(self._shapes) do
		self._shapes[i] = convex_polygon_shape(s)
	end
end

function concave_polygon_shape:collidesWith(other)
	if self == other then return false end
	if other._type == 'point' then
		return other:collidesWith(self)
	end

	-- TODO: better way of doing this. report all the separations?
	local collide,dx,dy = false,0,0
	for _,s in ipairs(self._shapes) do
		local status, sx,sy = s:collidesWith(other)
		collide = collide or status
		if status then
			if abs(dx) < abs(sx) then
				dx = sx
			end
			if abs(dy) < abs(sy) then
				dy = sy
			end
		end
	end
	return collide, dx, dy
end

function concave_polygon_shape:contains(x,y)
	return self._polygon:contains(x,y)
end

function concave_polygon_shape:intersectsRay(x,y, dx,dy)
	return self._polygon:intersectsRay(x,y, dx,dy)
end

function concave_polygon_shape:intersectionsWithRay(x,y, dx,dy)
	return self._polygon:intersectionsWithRay(x,y, dx,dy)
end

function concave_polygon_shape:center()
	return self._polygon.centroid.x, self._polygon.centroid.y
end

function concave_polygon_shape:outcircle()
	local cx,cy = self:center()
	return cx,cy, self._polygon._radius
end

function concave_polygon_shape:bbox()
	return self._polygon:bbox()
end

function concave_polygon_shape:move(x,y)
	self._polygon:move(x,y)
	for _,p in ipairs(self._shapes) do
		p:move(x,y)
	end
end

function concave_polygon_shape:rotate(angle,cx,cy)
	Shape.rotate(self, angle)
	if not (cx and cy) then
		cx,cy = self:center()
	end
	self._polygon:rotate(angle,cx,cy)
	for _,p in ipairs(self._shapes) do
		p:rotate(angle, cx,cy)
	end
end

function concave_polygon_shape:draw(mode, wireframe)
	local mode = mode or 'line'
	if mode == 'line' then
		love.graphics.polygon('line', self._polygon:unpack())
		if not wireframe then return end
	end
	for _,p in ipairs(self._shapes) do
		love.graphics.polygon(mode, p._polygon:unpack())
	end
end

return concave_polygon_shape