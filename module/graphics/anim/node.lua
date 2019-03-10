local node = class("node"){
    __name = nil,
    textrue = nil,
    x = 0,
    y = 0,
    r = 0,
}

function node:__init(texture,name,x,y,r)
    self.__name = name or self
    self:set_texture(texture)
    self.x = x or 0
    self.y = y or 0
    self.r = r or 0
end

function node:set_texture(textrue)
    self.textrue = textrue
end

function node:update(dt)
    if self.textrue and self.textrue.update then
        self.textrue:update(dt)
    end
end    

function node:draw(body_x,body_y,...)
    if self.textrue then
        local x,y,r = body_x + self.x,body_y + y,self.r 
        self.textrue:draw(x,y,r)
    end
end

return node