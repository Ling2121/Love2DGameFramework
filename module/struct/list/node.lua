local node = class("node"){
    data = nil,
    __at_list = nil,
    __root_node = nil,
    __tail_node = nil,
    __next_node = nil,
    __up_node = nil,
}

function node:get_list()
    return self.__at_lsit
end

return node