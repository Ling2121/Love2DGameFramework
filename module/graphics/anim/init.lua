local anim = ling_import("module/graphics/anim/anim")

local anim_mng = class("anim"){
    all_anim = {},
    anim = nil,
}

function anim_mng:__init(default_anim)
    self:add_anim("default",default_anim)
end

function anim_mng:add_anim(name,_anim)
    if _anim then
        name = name or "default"
        self.all_anim[name] = anim(name,_anim)
    end
    return self
end

function anim_mng:change_anim(name)
    local change = self.all_anim[name]
    if change then
        self.anim = change
    end
    return self
end

function anim_mng:update(dt)
    if self.anim then
        self.anim_mng:update(dt)
    end
end

function anim_mng:draw(...)
    if self.anim then
        self.anim_mng:draw(dt)
    end
end