local node = require"module/game/scene/node"
--hump.camera:
--https://github.com/vrld/hump

local cos, sin = math.cos, math.sin

local camera = class("camera",node){
    x = x, 
    y = y, 
    scale = 1, 
    rot = rot, 
    w = 0,
    h = 0,
    smoother = nil,
    psin = 0,
    nsin = 0,
    pcos = 0,
    ncos = 0,

    smooth = {}
}


function camera.smooth.none()
	return function(dx,dy) return dx,dy end
end

function camera.smooth.linear(speed)
	assert(type(speed) == "number", "Invalid parameter: speed = "..tostring(speed))
	return function(dx,dy, s)
		-- normalize direction
		local d = math.sqrt(dx*dx+dy*dy)
		local dts = math.min((s or speed) * love.timer.getDelta(), d) -- prevent overshooting the goal
		if d > 0 then
			dx,dy = dx/d, dy/d
		end

		return dx*dts, dy*dts
	end
end

function camera.smooth.damped(stiffness)
	assert(type(stiffness) == "number", "Invalid parameter: stiffness = "..tostring(stiffness))
	return function(dx,dy, s)
		local dts = love.timer.getDelta() * (s or stiffness)
		return dx*dts, dy*dts
	end
end

function camera:__init(x,y, scale, rot, smoother)
    self.x,self.y = x or love.graphics.getWidth()/2, y or love.graphics.getHeight()/2
    self.scale = scale or 1
    self.rot = rot or 0
    self.w = love.graphics.getWidth()
    self.h = love.graphics.getHeight()
    self.smoother = smoother or camera.smooth.none() 
    self.psin = math.sin(self.rot) 
    self.nsin = math.sin(-self.rot)
    self.pcos = math.cos(self.rot) 
    self.ncos = math.cos(-self.rot)
end

function camera:lookAt(x,y)
	self.x, self.y = x, y
	return self
end

function camera:move(dx,dy)
	self.x, self.y = self.x + dx, self.y + dy
	return self
end

function camera:position()
	return self.x, self.y
end

function camera:toScreen(x,y,z)
	return x,z - y
end
function camera:toWorld(x,y)
	return x,y,0
end

function camera:update_rotate()
	self.psin, self.nsin = math.sin(self.rotation), math.sin(-self.rotation)
    self.pcos, self.ncos = math.cos(self.rotation), math.cos(-self.rotation)
end

function camera:rotate(phi)
	self.rot = self.rot + phi
	self:update_rotate()
	return self
end

function camera:rotateTo(phi)
	self.rot = phi
	self:update_rotate()
	return self
end

function camera:zoom(mul)
	self.scale = self.scale * mul
	return self
end

function camera:zoomTo(zoom)
	self.scale = zoom
	return self
end

function camera:draw_begin(x,y,w,h, noclip)
	x,y = x or 0, y or 0
	w,h = w or love.graphics.getWidth(), h or love.graphics.getHeight()

	self._sx,self._sy,self._sw,self._sh = love.graphics.getScissor()
	if not noclip then
		love.graphics.setScissor(x,y,w,h)
	end

	local cx,cy = x+w/2, y+h/2
	love.graphics.push()
	love.graphics.translate(cx, cy)
	love.graphics.scale(self.scale)
	love.graphics.rotate(self.rot)
	love.graphics.translate(-self.x, -self.y)
end

function camera:draw_end()
	love.graphics.pop()
	love.graphics.setScissor(self._sx,self._sy,self._sw,self._sh)
end

-- world coordinates to camera coordinates
function camera:to_world_pos(x,y, ox,oy,w,h)
	ox, oy = ox or 0, oy or 0
	w,h = w or love.graphics.getWidth(), h or love.graphics.getHeight()

	-- x,y = ((x,y) - (self.x, self.y)):rotated(self.rot) * self.scale + center
	local c,s = cos(self.rot), sin(self.rot)
	x,y = x - self.x, y - self.y
	x,y = c*x - s*y, s*x + c*y
	return x*self.scale + w/2 + ox, y*self.scale + h/2 + oy
end

-- camera coordinates to world coordinates
function camera:to_camera_pos(x,y, ox,oy,w,h)
	ox, oy = ox or 0, oy or 0
	w,h = w or love.graphics.getWidth(), h or love.graphics.getHeight()

	-- x,y = (((x,y) - center) / self.scale):rotated(-self.rot) + (self.x,self.y)
	local c,s = cos(-self.rot), sin(-self.rot)
	x,y = (x - w/2 - ox) / self.scale, (y - h/2 - oy) / self.scale
	x,y = c*x - s*y, s*x + c*y
	return x+self.x, y+self.y
end

function camera:mouse_pos(ox,oy,w,h)
	local mx,my = love.mouse.getPosition()
	return self:to_camera_pos(mx,my, ox,oy,w,h)
end

-- camera scrolling utilities
function camera:lockX(x, smoother, ...)
	local dx, dy = (smoother or self.smoother)(x - self.x, self.y, ...)
	self.x = self.x + dx
	return self
end

function camera:lockY(y, smoother, ...)
	local dx, dy = (smoother or self.smoother)(self.x, y - self.y, ...)
	self.y = self.y + dy
	return self
end

function camera:lockPosition(x,y, smoother, ...)
	return self:move((smoother or self.smoother)(x - self.x, y - self.y, ...))
end

function camera:lockWindow(x, y, x_min, x_max, y_min, y_max, smoother, ...)
	-- figure out displacement in camera coordinates
	x,y = self:world_to_camera(x,y)
	local dx, dy = 0,0
	if x < x_min then
		dx = x - x_min
	elseif x > x_max then
		dx = x - x_max
	end
	if y < y_min then
		dy = y - y_min
	elseif y > y_max then
		dy = y - y_max
	end

	-- transform displacement to movement in world coordinates
	local c,s = cos(-self.rot), sin(-self.rot)
	dx,dy = (c*dx - s*dy) / self.scale, (s*dx + c*dy) / self.scale

	-- move
	self:move((smoother or self.smoother)(dx,dy,...))
end

return camera