local TemplateBullet, super = Class(Bullet)

---@param x number
---@param y number
function TemplateBullet:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/spr_mettaton_bomb1/spr_mettaton_bomb1_0")
    self:setScale(1, 1)
end

function TemplateBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return TemplateBullet