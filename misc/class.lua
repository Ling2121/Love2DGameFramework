local function copy(value)
	if type(value) ~= "table" then
		return value
	end
	local cp = {}
	for k,v in pairs(value) do
		cp[copy(k)] = copy(v)
	end
	return setmetatable(cp,value)
end

local function extends(class,...)
	local extc_list = {...}
	if #extc_list == 0 then return class end
	for i,extc in pairs(extc_list) do
		for k,v in pairs(extc) do
			if class[k] == nil then
				class[copy(k)] = copy(v)
			end
		end
	end
	return class
end

local function new(self,...)
	local ncla = {}
	extends(ncla,self)
	setmetatable(ncla,ncla)
	if type(ncla.__init) == "function" then
		ncla:__init(...)
	end
	return ncla
end

return function(name,...)
	local class = {}
	local ext = {...}
	class.new = new
	class.__call = class.new
	class.__name = name
	setmetatable(class,class)

	if #ext > 0 then
		extends(class,unpack(ext))
	end
	return function(info)
		extends(class,info)
		return class
	end
end