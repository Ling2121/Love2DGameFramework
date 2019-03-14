local function new_ssignal(name)
    local signal = {
        name = name,
        all_connect = {}
    }
    function signal:signal_pos()
        return self
    end

    function signal:release(...)
        for signal,connect_name in pairs(self.all_connect) do
            local signal = signal:signal_pos()
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

    return signal
end

local signal = class("signal"){
    __all_signal = {},
    __all_connect = {},
    __all_agent = {},
}

function signal:signal(name)
	self.__all_signal[name] = new_ssignal(name)
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
    local connect_signal,agent_pos,signal_name,connect_name = get_args(...)
    if connect_pos then
        connect_signal:signal(signal_name)
        local sig = signal()
        sig._agent = connect_signal
        sig._agent_pos = agent_pos  --从代理对象中获取代理位置  function(agent) return agent.xxx end
        

        signal:add_connect(self,connect_name)
        self.__all_connect[signal_name] = sig
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