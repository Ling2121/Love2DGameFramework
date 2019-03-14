local signal_proxy = class("signal_proxy"){
    __agent = nil,--代理人
    __proxy = nil,--代理对象
}

function signal_proxy:__init(agent,porxy)
    self.__agent = agent
    self.__proxy = porxy
end

