local space_hash = class("space_hash"){
    space_size = 100,
    spaces = {},
    all_object = {},
}

function space_hash:__init(size)
    self.space_size = size
end

function space_hash:to_pos(w_x,w_y)
    return math.floor(w_x / self.space_hash),math.floor(w_y / self.space_hash)
end

function space_hash:to_wpos(x,y)
    return x * self.space_hash,y * self.space_hash
end

function space_hash:get_space(x,y)
    local space_line = self.spaces[y]
    if not space_line then
        space_line = {}
        self.spaces[y] = space_line
    end
    local space = space_line[x]
    if not space then
        space = {}
        space[x] = space
    end
    return space
end

function space_hash:add(object,xa,ya,xb,yb)
    xa,ya = self:to_pos(xa,ya)
    xb,yb = self:to_pos(xb,yb)
    for y = ya,yb do
        for x = xa,xb do
            self:get_space(x,y)[object] = object
        end
    end
    self.all_object[object] = object
end

function space_hash:remove(object,xa,ya,xb,yb)
    xa,ya = self:to_pos(xa,ya)
    xb,yb = self:to_pos(xb,yb)
    for y = ya,yb do
        for x = xa,xb do
            self:get_space(x,y)[object] = nil
        end
    end
    self.all_object[object] = nil
end

function space_hash:move(obj,xa,ya,xb,yb, xc,yc,xd,yd)
    
end

function space_hash:select(xa,ya,xb,yb)
    local set,count = {},0
    for y = ya,yb do
        for x = xa,xb do
            for obj in pairs(self:get_space(x,y)) do
                set[obj] = obj
                count = count + 1
            end
        end
    end
    return set
end

function space_hash:draw(box_color,draw_num)
    local size = self.space_size
    for y,Lspa in pairs(self.spaces) do
        for x,spa in pairs(L) do
            local dx,dy = self:to_wpos(x,y)
            love.graphics.rectangle("line",dx,dy,size,size)
            if draw_num then
                local num = 0
                for _,_ in pairs(spa) do 
                    num = num + 1
                end
            end
        end
    end
end

return space_hash