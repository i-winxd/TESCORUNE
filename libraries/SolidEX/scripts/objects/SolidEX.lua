local SolidEX, super = Class(Solid)


function SolidEX:init(...)
    self.stage = Game.battle:getStage()
    super.init(self, ...)
end


local function resolveHitboxSoulCollision(hitbox, soul)
    local soul_col = soul.collider or soul
    if not hitbox:collidableCheck(soul_col) then return false end
    local pushed = false
    local max_iters = 100
    for i = 1, max_iters do
        if not hitbox:collidesWith(soul_col) then break end
        local sx, sy = hitbox:getPointFor(soul, 0, 0)
        local nx = math.max(hitbox.x, math.min(sx, hitbox.x + hitbox.width))
        local ny = math.max(hitbox.y, math.min(sy, hitbox.y + hitbox.height))
        local dx = sx - nx
        local dy = sy - ny
        if dx == 0 and dy == 0 then
            dy = -1
        end
        local len = math.sqrt(dx * dx + dy * dy)
        if len == 0 then break end
        dx, dy = dx / len, dy / len
        local tf = hitbox:getTransform()
        if tf then
            local local_x1, local_y1 = sx, sy
            local local_x2, local_y2 = sx + dx, sy + dy
            local wx1, wy1 = tf:transformPoint(local_x1, local_y1)
            local wx2, wy2 = tf:transformPoint(local_x2, local_y2)
            local move_x, move_y = wx2 - wx1, wy2 - wy1
            soul:setPosition(soul.x + move_x, soul.y + move_y)
        else
            soul:setPosition(soul.x + dx, soul.y + dy)
        end
        pushed = true
    end
    return pushed
end


function SolidEX:update()
    local collider=  self.collider
    if collider == nil then
        return
    end
    if self.collidable then
        for _, soul in ipairs(self.stage:getObjects(Soul)) do
            resolveHitboxSoulCollision(collider, soul)
        end
    end
end

-- absolutely nothing happens when a squish happens
function SolidEX:onSquished(soul)

end

return SolidEX