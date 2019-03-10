local textrue = ling_import("module/graphics/texture")
local node = ling_import("module/graphics/anim/node")

local anim = class("frame"){
    name = "default",
    all_frame = {},
    __frame_len = 0,
    play_speed = 0.5,
    play_status = true,
    play_clock = 0,
    play_pos = 1,
}

function anim:__init(name,frames)
    self.name = name or "default"
    self:load_frames(frames)
end

function anim:load_frames(frames)
    if frames then
        for _,frame in ipairs(frames) do
            self:add_frame(frames)
        end
    end
    return self
end

function anim:add_frame(data_or_path)
    if data_or_path then
        local frame = {
            texture = nil,
            all_node = {},
        }

        if type(data_or_path) == "string" then
            frame.texture = textrue(data_or_path)
        else
            frame.texture = data_or_path
        end

        function frame:add_node(textrue,name,x,y,r)
            local n = node(textrue,name,x,y,r)
            name = name or n
            table.insert(self.all_node,n)
            if type(name) ~= "number" then
                self.all_node[name] = n
            end
            return self
        end

        function frame:get_node(name)
            return self.all_node[name]
        end

        function frame:update(dt)
            for _,node in ipairs(self.all_node) do
                node:update(dt)
            end
        end

        function frame:draw(...)
            self.textrue:draw(...)
            for _,node in ipairs(self.all_node) do
                node:draw(...)
            end
        end

        self.__frame_len = __frame_len + 1
    end
    return self
end

function anim:set_speed(speed)
    self.play_speed = speed or self.play_speed
    return self
end

function anim:pause()
    self.play_status = false
    return self
end

function anim:play()
    self.play_status = true
    return self
end

function anim:set_play_pos(pos)
    if pos then
        if pos <= self.__frame_len then
            self.play_pos = pos
        else
            self.play_pos = self.__frame_len
        end
    else
        self.play_pos = 1
    end
end

function anim:update(dt)
    self.play_clock = self.play_clock + dt
    if self.play_clock >= self.play_speed then
        self.play_pos = self.play_pos + 1
        if self.play_pos > self.__frame_len then
            self.play_pos = 1
        end
    end
    local frame = self.all_frame[self.play_pos]
    frame:update(dt)
end

function anim:draw(...)
    local frame = self.all_frame[self.play_pos]
    frame:draw(...)
end

return frame
