local IntangibleTexture, super = Class(Bullet)

---@param x number
---@param y number
---@param scale number
---@param lifespan number
---@param texture string
function IntangibleTexture:init(x, y, scale, lifespan, texture)
    super.init(self, x, y, texture)
    self:setScale(scale,scale)
    self.timer = Timer()
    self:addChild(self.timer)
    self.lifespan = lifespan
end

function IntangibleTexture:onAdd()
    self.timer:script(function(wait) 
        wait(self.lifespan)
        self:remove()
    end)
end

function IntangibleTexture:onCollide(soul)
    -- do nothing since this texture is intangible
end



function IntangibleTexture:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return IntangibleTexture