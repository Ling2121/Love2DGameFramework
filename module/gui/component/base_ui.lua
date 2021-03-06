local area = require"misc/area/area"

local base_ui = class("base_ui",area){
    root = nil,
    style = {},
    drag = false,
    locking = false,
    _drag_ofs = {x = 0,y = 0},
    __at_box = nil,
}

function base_ui:__init_signal__()
    area.__init_signal__(self)
    self:signal("sliding")
    self:signal("add_to_box")
    self:signal("remove_form_box")
end

function base_ui:get_pos()
    local rx,ry = 0,0
    if self.root then
        rx,ry = self.root:get_pos()
    end
    return rx + self.x,ry + self.y
end

function base_ui:get_wpos()
    local x,y = self:get_pos()
    if self.__view_id == 1 then
        local cam = get_node("camera")
        if cam then
            return cam:to_world_pos(x,y)
        end
    end
    return x,y
end

function base_ui:get_root(layer)
    if layer then
        local root = self.root

        if layer == 0 then--获取第一个根
            if root then
                while root.root ~= nil do
                    root = root.root
                end
                return root
            else
                return self
            end
        else
            while layer >= 1 do
                layer = layer - 1
                root = root.root
                if not root then
                    return nil
                end
            end
        end
        return root
    end
    return self.root
end

function base_ui:set_root(root)
    if self.root then
        self.root.child[self] = nil
    end
    self.root = root
    return self
end

function base_ui:set_drag(bool)
    self.drag = bool
    return self
end

function base_ui:drag_move()
    local mox,moy = love.mouse.getPosition()
    self.x = mox - self._drag_ofs.x 
    self.y = moy - self._drag_ofs.y
end

function base_ui:drag_update_offset(mox,moy)
    self._drag_ofs.x = mox - self.x
    self._drag_ofs.y = moy - self.y
end

function base_ui:update()
    if self.drag and self._drag then
        local mox,moy = love.mouse.getPosition()
        self:drag_move(mox,moy)
        self:release("sliding")
    end
end

function base_ui:mousepressed(mox,moy)
    if self.drag then
        self:drag_update_offset(mox,moy)
        self._drag = true
        self.locking = true
    end
end

function base_ui:mousereleased()
    if self._drag then
        self.locking = false
    end

    self._drag = false
end

return base_ui