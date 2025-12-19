local GravityObject, super = Class(Bullet)

---@param x number
---@param y number
---@param dir number
---@param speed number
function GravityObject:init(x, y, dir, speed, texture, gravity)
    texture = texture or "bullets/tesco_icons/banana_icon"
    -- Last argument = sprite path
    super.init(self, x, y, texture)
    self.physics.direction = math.rad(dir)
    self.physics.speed = speed
    self.physics.gravity = gravity or 10
    self.scale_x = 1
    self.scale_y = 1
    self.remove_offscreen = false
end

function GravityObject:onAdd(parent)
    
end

function GravityObject:update()
    -- For more complicated bullet behaviours, code here gets called every update
    if self.y > SCREEN_HEIGHT + 10 then
        self:remove()
    end
    super.update(self)
end

return GravityObject