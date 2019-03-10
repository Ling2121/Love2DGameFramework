local base_shapes = class("base_shapes"){
    __shapes_type = "base",
}

function base_shapes:__init(type)
    self.__shapes_type = type
end

function base_shapes:get_type()
    return self.__shapes_type
end

return base_shapes