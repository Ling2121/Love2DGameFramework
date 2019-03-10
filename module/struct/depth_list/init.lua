local list = require"library/list"
local node = require"library/depth_list/node"

local function ins_node(self,node)
    if self:is_empty() then
        list.insert_node_back(self,node)
    else
        local find_node = self:find(function(fnode)
            return fnode.__depth >= node.__depth 
        end)
        if find_node == nil then
            list.insert_node_back(self,node)
        else
            list.insert_self_up(self,find_node,node)
        end
    end
    return node
end

local depth_list = class("depth_list"){
    __root_node = {},
    __tail_node = nil,
    node_num = 0,
    __all_node = {}
}

function depth_list:__init()
    list.__init(self)
end

function depth_list:is_empty()
    return (self.__root_node.__next_node == nil)
end

function depth_list:get_tail()
    return self.__tail_node
end

function depth_list:get_node(index)
    if index <= 0 or index > self.node_num then return end
    local node = self.__root_node
    for i = 1, index do
        node = node.__next_node
    end
    return node
end

function depth_list:find(condition)
    if not condition then return end
    for node in self:items() do
        if condition(node) then
            return node
        end
    end
    return nil
end

function depth_list:update_node_depth(set_node,depth)
    local depth = set_node.__depth or depth
    if depth >= set_node.__up_depth then--向后排序
        local node = set_node.__next_node
        while node ~= nil do
            if node.__depth < depth then
                list.nswap(self,node,set_node)
            end
            node = node.__next_node
        end
    else
        local node = set_node.__up_node--向前排序
        while node ~= nil and node ~= self.__root_node do
            if node.__depth > depth then
                list.nswap(self,node,set_node)
            end
            node = node.__up_node
        end
    end
    set_node.__depth_change = false
end

function depth_list:insert(data,depth)
    if not data then return end
    depth = depth or 0
    local node = node()
    node.data = data
    return ins_node(self,node)
end

function depth_list:insert_node(node,depth)
    if not node then return end
    node.__depth = depth or node.__depth
    return ins_node(self,node)
end

function depth_list:remove_self(node)--节点自删除
    if not node then return end
    local up = node.__up_node
    local next = node.__next_node

    if next == nil then
        self:remove_back()
    else
        up.__next_node = next
        next.__up_node = up
        if up.__next_node == nil then
            self.__tail_node = up
        end
    end
    self.__all_node[node] = nil
    self.node_num = self.node_num - 1
end

function depth_list:remove_back()
    local node = self.__tail_node
    local tail = node.__up_node
    node.__up_node.__next_node = nil
    self.__all_node[node] = nil
    self.node_num = self.node_num - 1
    self.__tail_node = tail
    return node
end

function depth_list:remove(index)
    local node = self:get_node(index)
    if node then
        local up = node.__up_node
        local next = node.__next_node

        up.__next_node = next
        if next then
            next.__up_node = up
        end

        self.__all_node[node] = nil
        if up.__next_node == nil then
            self.__tail_node = up
        end

        self.node_num = self.node_num - 1
        return node
    end
end

function depth_list:items()
    local node = self.__root_node

    return function()
        node = node.__next_node
        return node
    end
end

return depth_list