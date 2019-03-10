local hc_shapes = ling_import"library/HC.shapes"
local body = ling_import"module/bump/bump_body"

return {
    new_world = ling_import"module/bump/world",
    new_body  = body,
    new_rectangle = function(x,y,w,h)
        local s = hc_shapes.newPolygonShape(x,y,x + w,y,x+w,y+h,x,y + h)
        return body(s)
    end,
    new_polygon = function(...)
        local s = hc_shapes.newPolygonShape(...)
        return body(s)
    end,
    new_circle = function(x,y,r)
        local s = hc_shapes.newCircleShape(x,y,r)
        return body(s)
    end,
    new_point = function(x,y)
        local s = hc_shapes.newPointShape(x,y)
        return body(s)
    end
}