local rect = class("rect"){
    mode = "fill",
    w = 10,
    h = 10,
    color = {},
}

function rect:__init(mode,w,h,color)
    color = color or {255,255,255,255}
    self.mode = mode or "fill"
    self.w = w or 10
    self.h = h or 10
    self.color[1] = color[1] or 255
    self.color[2] = color[2] or 255
    self.color[3] = color[3] or 255
    self.color[4] = color[4] or 255
end

function rect:draw(x,y)
    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle(self.mode,x,y,self.w,self.h)
    love.graphics.setColor(255,255,255,255)
end

return rect
