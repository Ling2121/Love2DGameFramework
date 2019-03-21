--[[
    凸多边形形
--]]
local math_min, math_sqrt, math_huge = math.min, math.sqrt, math.huge
local shape = require"module/bump/shapes/shape"
local GJK = require"module/bump/gjk"

local convex_polygon_shape = class("convex_polygon_shape",shape){
    _polygon = nil,--polygon object
}

function convex_polygon_shape:__init(polygon)
    shape.__init(self,'polygon')
    assert(polygon:isConvex(), "Polygon is not convex.")
	self._polygon = polygon
end

function convex_polygon_shape:support(dx,dy)
	local v = self._polygon.vertices
	local max, vmax = -math_huge
	for i = 1,#v do
		local d = vector.dot(v[i].x,v[i].y, dx,dy)
		if d > max then
			max, vmax = d, v[i]
		end
	end
	return vmax.x, vmax.y
end

function convex_polygon_shape:collidesWith(other)
	if self == other then return false end
	if other._type ~= 'polygon' then
		local collide, sx,sy = other:collidesWith(self)
		return collide, sx and -sx, sy and -sy
	end

	-- else: type is POLYGON
	return GJK(self, other)
end

function convex_polygon_shape:contains(x,y)
	return self._polygon:contains(x,y)
end

function convex_polygon_shape:intersectsRay(x,y, dx,dy)
	return self._polygon:intersectsRay(x,y, dx,dy)
end

function convex_polygon_shape:intersectionsWithRay(x,y, dx,dy)
	return self._polygon:intersectionsWithRay(x,y, dx,dy)
end

function convex_polygon_shape:center()
	return self._polygon.centroid.x, self._polygon.centroid.y
end

function convex_polygon_shape:outcircle()
	local cx,cy = self:center()
	return cx,cy, self._polygon._radius
end

function convex_polygon_shape:bbox()
	return self._polygon:bbox()
end

function convex_polygon_shape:move(x,y)
	self._polygon:move(x,y)
end

function convex_polygon_shape:rotate(angle, cx,cy)
	Shape.rotate(self, angle)
	self._polygon:rotate(angle, cx, cy)
end

function convex_polygon_shape:draw(mode)
	mode = mode or 'line'
	love.graphics.polygon(mode, self._polygon:unpack())
end

return convex_polygon_shape


