local fsm_callback = {
    "keypressed",
	"keyreleased",
	"mousemoved",
	"mousepressed",
	"mousereleased",
	"wheelmoved",
	"textedited",
	"textinput"
}

local fsm_unit = class("fsm_unit"){}

function fsm_unit:init(callback_event)
    self.enter = callback_event.enter or self.fsm_enter
    self.exit = callback_event.exit or self.fsm_exit
    self.switch = callback_event.switch    --可转换状态
    self.parallel = callback_event.parallel--可并行状态

    for i,call_name in ipairs(love_callback) do
        if callback_event[call_name] then
            self[call_name] = function(object,fsm,...)
                callback_event[call_name](object,fsm,...)
            end
        end
    end
end

function fsm_unit.enter(object,fsm) return false end--进入条件
function fsm_unit.exit(object,fsm) return true end--退出条件
function fsm_unit.enter_event(object,fsm,is_par)end--进入状态时执行事件
function fsm_unit.parallel_enter_event(object,fsm)end--并行进入时状态时执行事件
function fsm_unit.exit_event(object,fsm,is_par)end--并行退出时执行事件
function fsm_unit.parallel_exit_event(object,fsm)end--退出状态时执行事件

local fsm = class("fsm"){
    status = {
        cur_status = nil,
        --数组部分为parallel
    },
    all_status = {},
    exec_obj = nil,
}

for i,name in ipairs(fsm_callback) do
    fsm[name] = function(self,...)
        local cursta = self.status.cur_status
        if cursta then
            if cursta[name] then
                cursta[name](self.exec_obj,self,...)
            end

            if self.status[1] ~= nil then
                for i,par in ipairs(self.status) do
                    if par[name] then
                        par[name](self.exec_obj,self,...)
                    end
                end
            end
        end
    end
end

function fsm:init(exec_obj)
    self.exec_obj = exec_obj
end

function fsm.new_status(name,info)
    local unit = fsm_unit(info)
    unit.name = name
    return unit
end

function fsm:add_status(unit)
    if not unit then error("") end
    if not unit.name then error("") end

    if not  self.all_status[unit.name] then
        self.all_status[unit.name] = #self.all_status + 1
        table.insert( self.all_status,unit)
    end
end

function fsm:clear_parallel()
    for i,par in ipairs(self.status) do
        par:parallel_exit_event(self.exec_obj,self)
        self.status[i] = nil
        self.status[par.name] = nil
    end
end

function fsm:change_status(name)
    local up_status = self.status.cur_status
    if up_status then
        if up_status.name ~= name then
            local i = self.all_status[name]
            if not i then error("没有这个状态") end
            up_status:exit_event(self.exec_obj,self)
            self:clear_parallel()
            self.all_status[i].enter_event(self.exec_obj,self)
            self.status.cur_status = self.all_status[i]
        end
    else
        local i = self.all_status[name]
        self.all_status[i].enter_event(self.exec_obj,self)
        self.status.cur_status = self.all_status[i]
    end
end

function fsm:parallel_status(name)
    local i = self.all_status[name]

    if i then
        if not self.status[name] then
            local par = self.all_status[i]
            table.insert(self.status,par)
            self.status[name] = true
            par.parallel_enter_event(self.exec_obj,self)
        end
    end
end

local function test_all_sta(self)
    for i,sta in ipairs(self.all_status) do
        if sta.enter(self.exec_obj,self) then
            self:change_status(sta.name)
            return
        end
    end
end

local function test_all_par(self)
    for i,sta in ipairs(self.all_status) do
        if sta.enter(self.exec_obj,self) then
            self:parallel_status(sta.name)
        end
    end
end

function fsm:test_status()
    local cursta = self.status.cur_status
    if cursta then
        if cursta.switch then
            for _i,name in ipairs(cursta.switch) do
                local  i = self.all_status[name]
                if i then
                    local sta = self.all_status[i]
                    if sta.enter(self.exec_obj,self) then
                        self:change_status(name)
                    end
                end
            end
        end
        cursta = self.status.cur_status

        if cursta.parallel == "all" then
            test_all_par(self)
        elseif type(cursta.parallel) == "table" then
            for _i,name in ipairs(cursta.parallel) do
                local  i = self.all_status[name]
                if i then
                    local sta = self.all_status[i]
                    if sta.enter(self.exec_obj,self) then
                        self:parallel_status(name)
                    end
                end
            end
        end
    else
        test_all_sta(self)
    end
end

function fsm:update(dt)
    self:test_status()
    local cursta = self.status.cur_status
    if cursta then
        if not cursta.exit(self.exec_obj,self) then
            cursta.update(self.exec_obj,self,dt)

            if self.status[1] ~= nil then
                for i,par in ipairs(self.status) do
                    if par.exit(self.exec_obj,self) then
                        par.parallel_exit_event(self.exec_obj,self)
                        table.remove(self.status,i)
                        self.status[par.name] = nil
                    else
                        par.update(self.exec_obj,self,dt)
                    end
                end
            end
        else
            self.status.cur_status:exit_event(self.exec_obj,self)
            self:clear_parallel()
            self.status.cur_status = nil
        end
    end
end

return fsm
