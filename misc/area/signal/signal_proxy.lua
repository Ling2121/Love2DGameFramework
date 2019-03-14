local signal_proxy = class("signal_proxy"){
    __all_connect = {},
    __agent = nil,--代理人
    __proxy = nil,--代理对象
    __all_proxy = {},
}

function signal_proxy:__init(agent,porxy)
    self.__agent = agent
    self.__proxy = porxy--可以是函数 proxy = __porxy(agent)
end

function signal_proxy:add_proxy(proxy_name)
    
end

function signal_proxy:connect(conn_obj,sig_name,conn_func_name)

end

return signal_proxy

