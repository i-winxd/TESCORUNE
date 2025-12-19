local BasicBullet, super = Class(Bullet)

---@param x number
---@param y number
---@param dir number
---@param speed number
function BasicBullet:init(x, y, dir, speed, texture)
    -- Last argument = sprite path
    super.init(self, x, y, texture)
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.remove_offscreen = false
end

return BasicBullet