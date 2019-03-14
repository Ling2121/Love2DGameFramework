local signal = class("signal"){
    __all_signal = {},
    __all_connect = {},
}

function signal:signal(name,is_proxy)
    self.__all_signal[name] = new_ssignal(name)
    
    if is_proxy then
        self.__is_proxy = true
    else
        self.__is_proxy = false
    end
end

local function get_args(...)
    local args = {...}
    local a,b,c,d = unpack(args)
    if #args <= 3 then
        return a,false,c,d
    else
        return a,b,c,d
    end
end

function signal:connect(...)
    local connect_signal,proxy_pos,signal_name,connect_name = get_args(...)
    if self.__is_proxy then
        
    else
        local signal = connect_signal.__all_signal[signal_name]
        if signal then
            signal:add_connect(self,connect_name)
            self.__all_connect[signal_name] = signal
        end
    end
end

function signal:release(name,...)
    local signal = self.__all_signal[name]
    if signal then
        signal:release(...)
    end
end

function signal:local_release(name,list,...)
    local signal = self.__all_signal[name]
    if signal then
        signal:local_release(list,...)
    end
end

function signal:disconnect(signal_name)
    if signal_name then
        local signal = self.__all_connect[signal_name]
        if signal then
            signal:disconnect_connect(self)

            self.__all_connect[signal_name] = nil
        end
    else
        for _,signal in pairs(self.self.__all_disconnect) do
            signal:disconnect_connect(self)
        end
        self.__all_connect = {}
    end
end

return signal