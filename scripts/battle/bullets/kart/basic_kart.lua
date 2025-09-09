local BasicKartItem, super = Class(YellowSoulAbsorber)

---@param x number
---@param y number
---@param texture string
function BasicKartItem:init(x, y, texture)
    -- Last argument = sprite path
    super.init(self, x, y, texture)
    self:setScale(2, 2)
    self.destroy_on_hit = false
    self.remove_offscreen = false
end

function BasicKartItem:update()
    -- For more complicated bullet behaviours, code here gets called every update
    super.update(self)
end

return BasicKartItem