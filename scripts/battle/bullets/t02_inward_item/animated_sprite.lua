local AnimatedSprite, super = Class(Bullet)

---@param x number
---@param y number
---@param dir number
---@param speed number
function AnimatedSprite:init(x, y, dir, speed, texture)
    -- Last argument = sprite path
    super.init(self, x, y)

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self:setSprite(texture, speed, true)
end

function AnimatedSprite:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return AnimatedSprite