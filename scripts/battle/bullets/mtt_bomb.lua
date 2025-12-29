local MttBomb, super = Class(YellowSoulBullet)

---@param x number
---@param y number
function MttBomb:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/spr_mettaton_bomb1/spr_mettaton_bomb1_0")
    self:setScale(1, 1)
    self.destroy_on_hit = false
    self.remove_offscreen = false
end

function MttBomb:update()
    -- For more complicated bullet behaviours, code here gets called every update
    super.update(self)
end

function MttBomb:destroy()
    self:spawnExploder()
    super.destroy(self)
end

function MttBomb:spawnExploder()
    local rx, ry = self:localToScreenPos(self.width / 2 + (0), self.height / 2 + (0))
    self.wave:spawnBullet("mtt_bomb/mtt_bomb_kaboom", rx, ry)
end



return MttBomb