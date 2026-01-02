local IntangibleTexture, super = Class(Bullet)

-- t01_moving_solid/item_trigger - x,y,scale,texture
---@param x number
---@param y number
---@param scale number
---@param texture string
function IntangibleTexture:init(x, y, scale, texture, on_collide)
    super.init(self, x, y, texture)
    self:setScale(scale,scale)
    self.timer = Timer()
    self:addChild(self.timer)
    self.can_graze = false
    self.osc = false
    self.siner = 0
    self.base_x = x
    self.base_y = y
    self.on_collide = on_collide or function() end
    self.frozen = false

end



function IntangibleTexture:onCollide(soul)
    -- do nothing since this texture is intangible
    local collide_result = self.on_collide()
    if collide_result == true then 
        self:remove()
    end
end



function IntangibleTexture:update()
    -- For more complicated bullet behaviours, code here gets called every update

    if self.osc and not self.frozen then 
        self.siner = self.siner + DT
        -- self.x = self.base_x 
        self.y = self.base_y - math.cos(2*math.pi/4*self.siner) * 5
    else
        
    end


    super.update(self)
end

return IntangibleTexture