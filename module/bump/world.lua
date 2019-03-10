local world = require"library/hc.spatialhash"

function world:is_at_world(object)
    if not object then return end
    return self.all_shapes[object] ~= nil
end

function world:is_test(object_a,object_b)
    local body_a = object_a:get_bump_body()
    local body_b = object_b:get_bump_body()

    if not body_a._wait and not body_b._wait then
        if body_a._layer == body_b._layer then
            return body_a._id ~= body_b._id
        end
    end
end

function world:add_object(object)
    if not object then return end
    if self.all_shapes[object] then return end
    local body = object:get_bump_body()
    body.at_world = self
    self:register(object,body:get_shapes():bbox())
end

function world:remove_object(object)
    if not object then return end
    local body = object:get_bump_body()
    self:remove(object,body:get_shapes():bbox())
end

function world:move_object(object,move_x,move_y)
    if not self:is_at_world(object) then return end
    local body = object:get_bump_body()
    local shapes = body:get_shapes()
    local x1,y1,x2,y2 = shapes:bbox()
    local items,count = self:inSameCells(x1,y1,x2,y2)
    local is_bump = false
    local bump_items = {}

    rawset(items,body,nil)--自己和自己不会进行碰撞测试
    shapes:move(move_x,move_y)
    if count > 1 then--只有一个表示只有自己
        for sps in pairs(items) do
            local test_body = sps:get_bump_body()
            local test_shapes = test_body:get_shapes()
            if self:is_test(body,test_body) then
                local _is_bump,back_x,back_y = shapes:collidesWith(test_shapes)
                if _is_bump then
                    bump_items[sps] = sps
                    is_bump = true
                    shapes:move(back_x,back_y)
                end
            end
        end
    end
    self:update(object,x1,y1,x2,y2,shapes:bbox())

    return is_bump,bump_items
end

return world