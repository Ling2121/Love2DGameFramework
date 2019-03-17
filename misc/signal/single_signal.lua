--[[
    单个信号
--]]
local single_signal = class("single_signal"){
    name = "",
    all_connect = {},
}

function single_signal:connect(object,conn_func_name)
    local i = #self.all_connect + 1
    local conn = {
        object = object,
        fname = conn_func_name,
        index = i
    }
    table.insert(self.all_connect,conn)--先到先得
    self.all_connect[object] = conn--快速删除，免得搜索
end

function single_signal:release(...)
    for i,connect in ipairs(self.all_connect) do
        local obj = connect.object
        local conn_func = obj[connect.fname]
        conn_func(obj,...)--执行对应连接函数
    end
end

function single_signal:local_release(list)
    for object in ipairs(list) do
        local conn = self.all_connect[object]
        if conn then
            local conn_func = obj[conn.fname]
            conn_func(object)
        end
    end
end

function single_signal:disconnect(object)
    local conn = self.all_connect[object]
    if conn then
        self.all_connect[conn.index] = nil
        self.all_connect[object] = nil
    end
end

return single_signal