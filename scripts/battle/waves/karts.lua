local Karts, super = Class(Wave)

function Karts:init()
    super.init(self)
    -- how long the battle lasts in seconds
    self.time = 9.5
    self.timer = Timer()
    self:addChild(self.timer)
    --     self.arena_x = SCREEN_WIDTH/2 + x
    -- self.arena_y = (SCREEN_HEIGHT - 155)/2 + 10 + y
    self.arena_x = (SCREEN_WIDTH * 0.4)
    self.arena_y = (SCREEN_HEIGHT - 155) / 2 + 10
    self.arena_height = SCREEN_HEIGHT * 0.35
end

function Karts:onEnd(death)
    super.onEnd(self,death)
end

function Karts:onStart()
    self._original_soul = Game.battle.soul
    local standard_soul = YellowSoul()
    Game.battle:swapSoul(standard_soul)


    -- Get the arena object
    -- self:spawnBullet("mtt_bomb", arena_x + 160, arena_y)
    ---@type number[]
    local kart_delays = {0, 1.25, 0.85, 0.65, 0.65, 1, 0.75, 1}    
    self.timer:script(function(wait) 
        for i = 1, #kart_delays do
            wait(kart_delays[i])
            local kart_stack = self:spawnKartStack(SCREEN_WIDTH, Game.battle.arena.y + 90)
            -- self.timer:tween(6, kart_stack, { x = -50 }, "out-quad")
        end
    end)
end

---@param x number
---@param y number
function Karts:spawnKartStack(x, y)
    return self:spawnBullet("kart/kart_stack", x, y, 1, 1)
    -- return self:spawnBullet("kart/moving_kart_stack", x, y)
end
--     local kart_stack = self:spawnKartStack(SCREEN_WIDTH, arena_y + 90)
    -- self.timer:tween(6, kart_stack, { x = -50 }, "out-quad")
-- 
-- 
-- function MovingKartStack:spawnKartStack(x, y)
--     return self.wave:spawnBullet("kart/kart_stack", x, y)
-- end

function Karts:update()
    super.update(self)
end

return Karts