local node = require"module/struct/list/node"

local list = class("list"){
    __root_node = {},
    __tail_node = nil,
    node_num = 0,
    __all_node = {}
}

function list:__init()
    self.__tail_node = self.__root_node
end

function list:is_empty()
    return (self.__root_node.__next_node == nil)
end

function list:get_tail()
    return self.__tail_node
end

function list:get_node(index)
    if index <= 0 or index > self.node_num then return end
    local node = self.__root_node
    for i = 1, index do
        node = node.__next_node
    end
    return node
end

function list:find(condition)
    if not condition then return end
    for node in self:items() do
        if condition(node) then
            return node
        end
    end
    return nil
end

function list:insert(index,data)
    if index == self.node_num then
        return self:insert_back(data)
    end
    if index <= self.node_num then
        local onode  = node()
        local node   = self:get_node(index)
        local up_node  = node.__up_node
        onode.__at_list = self
        onode.data = data
        up_node.__next_node = onode
        onode.__next_node = node
        onode.__up_node   = up_node
        node.__up_node    = onode


        self.__all_node[onode] = onode

        if onode.__next_node == nil then
            self.__tail_node = onode
        end
        self.node_num = self.node_num + 1
        return onode
    end
end

function list:insert_back(data)
    local tail = self.__tail_node
    local onode = node()
    onode.__at_list = self
    onode.data = data
    tail.__next_node = onode
    onode.__up_node = tail
    self.node_num = self.node_num + 1
    self.__tail_node = onode
    self.__all_node[onode] = onode
    return onode
end

function list:insert_node(onode,index)
    if index == self.node_num then
        return self:insert_node_back(onode)
    end
    if index <= self.node_num then
        local node   = self:get_node(index)
        local up  = node.__up_node
        onode.data = data
        up.__next_node = onode
        onode.__next_node = node
        onode.__up_node   = up
        node.__up_node    = onode
        if onode.__next_node == nil then
            self.__tail_node = onode
        end
        self.__all_node[onode] = onode
        self.node_num = self.node_num + 1
        onode.__at_list = self
        return onode
    end
end

function list:insert_node_back(onode)
    local tail = self.__tail_node
    tail.__next_node = onode
    onode.__at_list = self
    onode.__up_node = tail
    self.__tail_node = onode
    self.__all_node[onode] = onode
	self.node_num = self.node_num + 1
    return onode
end

function list:insert_self_up(node,inode)--向身前插入节点
    if node == inode then return end
    if not node or not inode then return end
    local up = node.__up_node
    up.__next_node = inode
    inode.__at_list = self
    inode.__up_node = up
    inode.__next_node = node
    node.__up_node = inode
    self.__all_node[inode] = inode
end

function list:insert_self_next(node,inode)--向身后插入节点
    if node == inode then return end
    if not node or not inode then return end
    local next = node.__next_node
    if next then
        next.__up_node = inode
        inode.__next_node = next
        inode.__up_node = node
        node.__next_node = inode
    else
        node.__next_node = inode
        inode.__up_node = node
        inode.__next_node = nil
    end

    if inode.__next_node == nil then
        self.__tail_node = inode
    end

    inode.__at_list = self
    self.__all_node[inode] = inode
end

function list:remove(index)
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

function list:remove_back()
    local node = self.__tail_node
    local tail = node.__up_node
    node.__up_node.__next_node = nil
    self.__all_node[node] = nil
    self.node_num = self.node_num - 1
    self.__tail_node = tail
    return node
end

function list:remove_self(node)--节点自删除
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

function list:swap(index1,index2)--基于位置的交换
    local na = self:remove(index1)
    local nb = self:remove(index2)
    self:insert_node(index2,na,na.key)
    self:insert_node(index1,nb,nb.key)
end

function list:nswap(na,nb)--基于节点的交换
    if na == self.__root_node or nb == self.__root_node then return end

    local na_up = na.__up_node
    local na_ne = na.__next_node
    local nb_up = nb.__up_node
    local nb_ne = nb.__next_node

    if na_ne == nb then--相邻  	    A < - > na < - > nb < - > B
        nb.__up_node      = na_up 		--  A < - - nb - - - na - - - b
		na_up.__next_node = nb     	--  A < - > nb - - - na - - - b
        nb.__next_node    = na	   		--  A < - > nb - - > na - - - b
		na.__up_node	  = nb	   		--  A < - > nb < - > na - - > b
        na.__next_node    = nb_ne		--  A < - > nb < - > na - - > b
		if nb_ne then
			nb_ne.__up_node = na				--  A < - > nb < - > na - - > b
		end
    elseif na_up == nb then--相邻   A < - > nb < - > na < - > B
        na.__up_node      = nb_up		--  A < - - na - - - nb - - - b
		nb_up.__next_node = na  		--  A < - > na - - - nb - - - b
        na.__next_node    = nb			--  A < - > na - - > nb - - - b
		nb.__up_node      = na			--  A < - > na < - > nb - - - b
		nb.__next_node	   = na_ne      --  A < - > na < - > nb - - > b
		if na_ne then
			na_ne.__up_node   = nb			--  A < - > na < - > nb < - > b
        end
    else
        na_up.__next_node = nb 			--  A - - > nb - - - B - - - na - - - C
        nb.__up_node = na_up				--  A < - > nb - - - B - - - na - - - C
        nb.__next_node = na_ne 			--  A < - > nb - - > B - - - na - - - C
        if na_ne then
            na_ne.__up_node = nb   		--  A < - > nb < - > B - - - na - - - C
        end
        nb_up.__next_node = na 			--  A < - > nb < - > B - - > na - - - C
        na.__up_node = nb_up   			--  A < - > nb < - > B < - > na - - - C
        na.__next_node = nb_ne 			-- 	A < - > nb < - > B < - > na - - > C
        if nb_ne then
            nb_ne.__up_node = na   	    -- 	A < - > nb < - > B < - > na < - > C
        end
    end
    if na.__next_node == nil then
        self.__tail_node = na
    end
    if nb.__next_node == nil then
        self.__tail_node = nb
    end
end

function list:items()
    local node = self.__root_node

    return function()
        node = node.__next_node
        return node
    end
end

return list
