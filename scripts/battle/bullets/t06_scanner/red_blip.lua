local THE_BULLET, super = Class(Bullet)

---@param x number Starting position
---@param y number Starting position. This decides the elevation of the scanner.
function THE_BULLET:init(x, y)
    self.destroy_on_hit = false
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/t06_scanner/scan_artifact")
    self.remove_offscreen = false
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.draw_children_below = 0
    -- self:setScale(2, 2)
    self.timer = Timer()
    self:addChild(self.timer)
    self.intangible = false
    self:setLayer(-1)
    self.alpha_decay = 0.7  -- alpha decay per second
    self.transparent_threshold = 0.7 -- below this alpha, this bullet becomes intangible
    -- this bullet self destructs at alpha leq 0
    self:setScale(0.55, 0.75)
    self.destroy_on_hit = false
end

--- *(Override)* Called when the bullet collides with the player's soul, before invulnerability checks.
---@param soul Soul
function THE_BULLET:onCollide(soul)
    if not self.intangible then
        super.onCollide(self, soul)
    end
end


function THE_BULLET:onAdd(parent)
    local arena_width = Game.battle.arena.width
    local arena_height = Game.battle.arena.height
    local ax, ay = Game.battle.arena:getCenter()
    -- where facing is in degrees, offset, VISUALLY COUNTERCLOCKWISE UP
end




function THE_BULLET:update()
    -- For more complicated bullet behaviours, code here gets called every update
    self.alpha = self.alpha - (self.alpha_decay * DT)
    if self.alpha < self.transparent_threshold then
        self.intangible = true
        self.can_graze = false
    end
    if self.alpha <= 0 then 
        self:remove() -- detatch and cease to exist
    end
    super.update(self)
end

return THE_BULLET