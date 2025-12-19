---@class RectObject : Object
---@
---@overload fun(filled?:boolean, x?:number, y?:number, width?:number, height?:number, color?:table) : RectObject
local RectObject, super = Class(Object)

---@param filled? boolean
---@param x? number
---@param y? number
---@param width? number
---@param height? number
---@param color? table  {r, g, b, a}
function RectObject:init(filled, x, y, width, height, color)
    super.init(self, x, y, width, height)

    self.layer = BATTLE_LAYERS["above_arena"]

    if width and height then
        self:setHitbox(0, 0, width, height)
    end

    self.color = color or {0, 0.75, 0, 1}
    self.draw_filled = filled or false
    self.collidable = false
end

function RectObject:draw()
    if self.collider then
        if self.draw_filled then
            self.collider:drawFill(self.color)
        else
            self.collider:draw(self.color)
        end
    end

    super.draw(self)
end

return RectObject
