local area = ling_import"misc/area/area"

local base_ui = class("base_ui",area){
    root = nil,
    style = {},
    drag = false,
    locking = false,
    exe_root_cb = true,
    _drag = false,
    _drag_ofs = {x = 0,y = 0},
}

function base_ui:__init(...)
    area.__init(self,...)
    self:signal("sliding")
end

function base_ui:get_pos()
    local root = self.root
    local x,y = self.x,self.y
    if root then
        local rx,ry = root:get_pos()
        return rx + x,ry + y
    end
    return x,y
end

function base_ui:get_transform_pos()
    local mng = self.__at_scene
    local x,y = self:get_pos()
    return mng.ox + x,mng.oy + y
end

function base_ui:get_world_pos()
    local x,y = self:get_transform_pos()
    if self.__at_scene then
        local camera = self.__at_scene.camera
        if self.__view_id == 1 then
            return camera:world_to_camera(x,y)
        else
            return x,y
        end
    else
        return x,y
    end
end

function base_ui:set_root(root)
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
    local x,y = self:get_transform_pos()
    local mng = self.__at_scene

    self._drag_ofs.x = mox - x + mng.ox
    self._drag_ofs.y = moy - y + mng.oy
end

function base_ui:update(mox,moy)
    if self.drag and self._drag then
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