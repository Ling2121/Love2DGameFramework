local signal = class("signal"){
    __all_signal = {},
    __all_connect = {},
}

function signal:signal(name)
    local signal = {
        name = name,
        all_connect = {}
    }

    function signal:release(...)
        for signal,connect_name in pairs(self.all_connect) do
            signal[connect_name](signal,...)
        end
    end

    function signal:local_release(list,...)
        for signal in ipairs(list) do
            local connect_name = self.all_connect[signal]
            signal[connect_name](signal,...)
        end
    end

    function signal:add_connect(signal,connect_name)
        self.all_connect[signal] = connect_name
    end

    function signal:disconnect_connect(signal)
        self.all_connect[signal] = nil
    end
	
	self.__all_signal[name] = signal
end

function signal:connect(signal,signal_name,connect_name)
    local signal = signal.__all_signal[signal_name]
    if signal then
        signal:add_connect(self,connect_name)
        self.__all_connect[signal_name] = signal
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