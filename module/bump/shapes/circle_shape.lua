local math_min, math_sqrt, math_huge,abs = math.min, math.sqrt, math.huge,math.abs
local shape = require"module/bump/shapes/shape"
local GJK = require"module/bump/gjk"

local circle_shape = class(){
    _center = {x = 0,y = 0},
    _radius = 0,
}

function circle_shape:__init(x,y,r)
    shape.__init(self,'circle')
    self._center = {x = x, y = y}
	self._radius = r or 10
end

function circle_shape:support(dx,dy)
	return  vector.add(self._center.x, self._center.y,
		    vector.mul(self._radius, vector.normalize(dx,dy)))
end

function circle_shape:collidesWith(other)
	if self == other then return false end
	if other._type == 'circle' then
		local px,py = self._center.x-other._center.x, self._center.y-other._center.y
		local d = vector.len2(px,py)
		local radii = self._radius + other._radius
		if d < radii*radii then
			-- if circles overlap, push it out upwards
			if d == 0 then return true, 0,radii end
			-- otherwise push out in best direction
			return true, vector.mul(radii - math_sqrt(d), vector.normalize(px,py))
		end
		return false
	elseif other._type == 'polygon' then
		return GJK(self, other)
	end

	-- else: let the other shape decide
	local collide, sx,sy = other:collidesWith(self)
	return collide, sx and -sx, sy and -sy
end

function circle_shape:contains(x,y)
	return vector.len2(x-self._center.x, y-self._center.y) < self._radius * self._radius
end

function circle_shape:intersectionsWithRay(x,y, dx,dy)
	local pcx,pcy = x-self._center.x, y-self._center.y

	local a = vector.len2(dx,dy)
	local b = 2 * vector.dot(dx,dy, pcx,pcy)
	local c = vector.len2(pcx,pcy) - self._radius * self._radius
	local discr = b*b - 4*a*c

	if discr < 0 then return {} end

	discr = math_sqrt(discr)
	local ts, t1, t2 = {}, discr-b, -discr-b
	if t1 >= 0 then ts[#ts+1] = t1/(2*a) end
	if t2 >= 0 then ts[#ts+1] = t2/(2*a) end
	return ts
end

function circle_shape:intersectsRay(x,y, dx,dy)
	local tmin = math_huge
	for _, t in ipairs(self:intersectionsWithRay(x,y,dx,dy)) do
		tmin = math_min(t, tmin)
	end
	return tmin ~= math_huge, tmin
end

function circle_shape:center()
	return self._center.x, self._center.y
end

function circle_shape:outcircle()
	local cx,cy = self:center()
	return cx,cy, self._radius
end

function circle_shape:bbox()
	local cx,cy = self:center()
	local r = self._radius
	return cx-r,cy-r, cx+r,cy+r
end

function circle_shape:move(x,y)
	self._center.x = self._center.x + x
	self._center.y = self._center.y + y
end

function circle_shape:rotate(angle, cx,cy)
	Shape.rotate(self, angle)
	if not (cx and cy) then return end
	self._center.x,self._center.y = vector.add(cx,cy, vector.rotate(angle, self._center.x-cx, self._center.y-cy))
end

function circle_shape:draw(mode, segments)
	love.graphics.circle(mode or 'line', self:outcircle())
end

return circle_shape
