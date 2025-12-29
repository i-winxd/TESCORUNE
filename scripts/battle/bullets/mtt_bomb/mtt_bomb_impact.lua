local MttBombImpact, super = Class(Bullet)

---@param x number
---@param y number
function MttBombImpact:init(x, y, explosion_iframes)
    -- Last argument = sprite path
    super.init(self, x, y)
    self:setScale(1, 1)
    self.gap = 24
    self.spread = 40
    self.remove_offscreen = false
    self.explosion_iframes =  explosion_iframes or 4/3

end

function MttBombImpact:onAdd()
    local x = self.x
    local y = self.y
    for i = 0, (self.spread-1), 1 do
        local offset_down = i * self.gap
        local offset_up = (-i-1) * self.gap
        -- horizontal
        self:spawnImpactPart(x+offset_down,y, 90)
        self:spawnImpactPart(x+offset_up,y, 90)
        -- vertical
        self:spawnImpactPart(x,y+offset_down, 0)
        self:spawnImpactPart(x,y+offset_up, 0)
    end
    Assets.playSound("bullet_destroyed", 0.8)
    self:remove()
end

---@param x number
---@param y number
---@param rot number
function MttBombImpact:spawnImpactPart(x, y, rot)
    -- print("Myself that is ", self)
    self.wave:spawnBullet("mtt_bomb/mtt_bomb_impact_part", x, y, rot, self.explosion_iframes)
end

function MttBombImpact:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return MttBombImpact