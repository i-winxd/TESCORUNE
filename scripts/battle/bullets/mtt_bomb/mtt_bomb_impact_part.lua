local BombExplodePart, super = Class(Bullet)

--- small impact zone
--- vertical by default
---@param x number spawn it centered here
---@param y number spawn it centered here
---@param rot? number in degrees
function BombExplodePart:init(x, y, rot)
    rot = rot or 0
    -- Last argument = sprite path
    -- self:setSprite(texture, 0.25, true)
    -- 
    local bomb_explode_impact_path = "bullets/spr_mettaton_bomb3/spr_mettaton_bomb3"
    super.init(self, x, y)
    self:setSprite(bomb_explode_impact_path, (1/30), false, function(spr) 
        self:remove()
    end)
    self.can_graze = false
    self.destroy_on_hit = false
    self:setScale(1, 1)
    self.rotation = math.rad(rot)
    self.collider = Hitbox(self, self.width/4, 0, self.width/2, self.height)
    self.remove_offscreen = false


end

function BombExplodePart:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return BombExplodePart