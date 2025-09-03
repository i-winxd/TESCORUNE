local TescoAttack, super = Class(Wave)

function TescoAttack:init()
    super.init(self)

    -- Initialize timer
    -- self.siner = 0
    
    -- how long the battle lasts in seconds
    self.time = 10
end

function TescoAttack:onStart()
    -- Get the arena object
    local arena = Game.battle.arena
    -- Game.battle.swapSoul()

    local x = SCREEN_WIDTH / 2
    local y = SCREEN_HEIGHT / 2

    local arena_x = arena.x
    local arena_y = arena.y


    local bullet_reach_factor = 2
    local bullet = self:spawnBullet("gaster_blaster", x, y, math.rad(0), 1)
    
end

function TescoAttack:update()



    -- Increment timer for arena movement
    -- self.siner = self.siner + DT

    -- Calculate the arena Y offset
    -- local offset = math.sin(self.siner * 1.5) * 60

    -- Move the arena
    -- Game.battle.arena:setPosition(self.arena_start_x, self.arena_start_y + offset)

    super.update(self)
end

return TescoAttack