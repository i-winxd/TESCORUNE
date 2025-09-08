local MovingKartStack, super = Class(Bullet)

---@param x number
---@param y number
function MovingKartStack:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y)
    self:setScale(1, 1)
    self.timer = Timer()
    self:addChild(self.timer)
    self.destroy_on_hit = true
end

function MovingKartStack:onAdd()
    local arena = Game.battle.arena
    local x = SCREEN_WIDTH / 2
    local y = SCREEN_HEIGHT / 2
    local arena_x = arena.x
    local arena_y = arena.y
    -- self:spawnBullet("mtt_bomb", arena_x + 160, arena_y)
    local kart_stack = self:spawnKartStack(SCREEN_WIDTH, arena_y + 90)
    self.timer:tween(6, kart_stack, { x = -50 }, "out-quad")
end

function MovingKartStack:spawnKartStack(x, y)
    return self.wave:spawnBullet("kart/kart_stack", x, y)
end

function MovingKartStack:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return MovingKartStack