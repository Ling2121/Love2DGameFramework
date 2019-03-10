local list_node = require"module/struct/list/node"

local node = class("node",list_node){
    __depth = 0,
    __up_depth = 0,
    __depth_change = false,
}

function node:set_depth(depth)
    self.__up_depth = self.__depth
    self.__depth = depth or self.__depth
    self.__depth_change = true
    return self
end

function node:get_depth()
    return self.__depth
end

return node