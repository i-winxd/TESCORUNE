local CardPlatform, super = Class(Bullet)

---@param x number
---@param y number
function CardPlatform:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/t05_card/credit_card_holder")
    self.remove_offscreen = false
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.draw_children_below = 0
end

function CardPlatform:onAdd(parent)
    local ix, iy = self.width/2, self.height/2 - 10
    local card = self.wave:spawnBulletTo(self, "t05_card/card", ix, iy, 80, -20)
end

function CardPlatform:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return CardPlatform