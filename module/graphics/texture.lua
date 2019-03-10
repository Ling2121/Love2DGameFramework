local texture = class("texture"){
    data = nil
}

function texture:__init(data_or_path)
    if type(data_or_path) == "string" then
        self.data = love.graphics.newImage(data_or_path)
    else
        self.data = data_or_path 
    end
end

function texture:draw(...)
    love.graphics.draw(self.data,...)
end

return texture