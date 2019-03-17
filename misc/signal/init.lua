--[[
    信号机制
--]]
local single_signal = require"misc/signal/single_signal"

local signal = class("signal"){
    __all_signal = {},
    __all_connect = {},
}

function signal:signal(name)
    self.__all_signal[name] = single_signal(name)
end

function signal:connect(conn_obj,sig_name,conn_name)
    local single_signal = conn_obj.__all_signal[sig_name]
    if single_signal then
        single_signal:connect(self,conn_name)
        self.__all_connect[sig_name] = single_signal
    end
end

function signal:release(name,...)
    local single_signal = self.__all_signal[name]
    if single_signal then
        single_signal:release(...)
    end
end

function signal:local_release(name,list,...)
    local single_signal = self.__all_signal[name]
    if single_signal then
        single_signal:local_release(list,...)
    end
end

function signal:disconnect(signal_name)
    if signal_name then
        local signal = self.__all_connect[signal_name]
        if signal then
            signal:disconnect(self)
            self.__all_connect[signal_name] = nil
        end
    else--没有传入名称时与所有信号断开连接
        for _,signal in pairs(self.self.__all_disconnect) do
            signal:disconnect(self)
        end
        self.__all_connect = {}
    end
end

return signal