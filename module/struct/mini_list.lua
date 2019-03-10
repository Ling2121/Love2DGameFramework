local function new_node(data,up,next)
    return {
        index = nil,
        data = data,
        up = up,
        next = next
    }
end

local mini_list = class("mini_list"){
    root = {},
    tail = nil,
    index = {},
    length = 0,

    new_node = new_node,
}

function mini_list:init()
    self.tail = self.root
end

function mini_list:is_empty()
    return self.root.next == nil
end

function mini_list:get_node(i_or_k)
    if type(i_or_k) == "number" then
        if i_or_k > 0 and i_or_k <= self.length then
            local node = self.root
            for i = 1,i_or_k do
                node = node.next
            end
			return node
        end
    else
        return self.index[i_or_k]
    end
end

function mini_list:push_back(data,index)
    local node = new_node(data, self.tail, nil)
    node.index = index or node
    self.tail.next = node
    self.tail = node
    if not self.index[node.index] then
        self.index[node.index] = node
    else
        error("节点索引("..tostring(node.index)..")重复辣，请仔细检查")
    end
    self.length = self.length + 1
    return node
end

function mini_list:pop_back()
    if not self:is_empty() then
        local data = self.tail.data
        local up_node = self.tail.up
        self.index[self.tail.index] = nil
        up_node.next = nil
        self.tail = up_node
        self.length = self.length  - 1
        return data
    end
end

function mini_list:insert(data,i,index)
    if i > 0 then
        local node = new_node(data)
        node.index = index or node
        if i == 1 then--head
            local root = self.root
            local ins_node = self.root.next
            root.next = node
            node.up = root
            node.next = ins_node
            ins_node.up = node
        elseif i > self.length then--tail
            node = self:push_back(data,index)
        else
            local next = self:get_node(i)
            local up = next.up
            next.up = node
            up.next = node
            node.next = next
            node.up = up
        end
        return node
    end
end

function mini_list:remove(i_or_k)
    if type(i_or_k) == "number" then
        if i_or_k > 0 and i_or_k <= self.length then
            if i_or_k >= self.length then
                return self:pop_back()
            elseif i_or_k == 1 then
                local root = self.root
                local rm_node = root.next
                local next = rm_node.next
                next.up = root
                root.next = next
                self.index[rm_node.index] = nil
                return rm_node.data
            end
            local rm_node = self:get_node(i_or_k)
            if rm_node then
                local up = rm_node.up
                local next = rm_node.next
                up.next = next
                next.up = up
                self.index[rm_node.index] = nil
                return rm_node.data
            end
        end
    else

    end
end

function mini_list:items()
    local node = self.root
    return function()
        node = node.next
        return node
    end
end

return mini_list
