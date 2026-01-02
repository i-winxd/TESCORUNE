local IntangibleTexture, super = Class(Bullet)

---@param x number
---@param y number
---@param radius number
function IntangibleTexture:init(x, y, radius)
    super.init(self, x, y)
    self.radius = radius
    self.timer = Timer()
    self:addChild(self.timer)
    self.can_graze = false
end

function IntangibleTexture:onAdd()

end

function IntangibleTexture:onCollide(soul)
    -- do nothing since this texture is intangible
end


function IntangibleTexture:draw()
    love.graphics.push("all")
    Draw.setColor(1, 1, 1, 0.3)
    love.graphics.circle("fill", 0, 0, self.radius)
    Draw.setColor()
    love.graphics.pop()
end


function IntangibleTexture:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return IntangibleTexture