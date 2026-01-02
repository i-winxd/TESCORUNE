local TescoAttack, super = Class(Wave)

function TescoAttack:init()
    super.init(self)

    -- Initialize timer
    -- self.siner = 0
    
    -- how long the battle lasts in seconds
    self.time = 12
end



function TescoAttack:onStart()

    -- Get the arena object
    local arena = Game.battle.arena
    -- local soul_x_pos = 60
    -- local soul_y_pos = 60
    -- local soul_loc, soul_loc_2 = Game.battle:getSoulLocation();


    local x = SCREEN_WIDTH / 2
    local y = SCREEN_HEIGHT / 2

    local arena_x = arena.x
    local arena_y = arena.y


    local bullet_reach_factor = 2
    -- x, y, rot, target_x, target_y, target_rot, wait_time, blast_time, play_sound
    -- local bullet = self:spawnBullet("gaster_blaster", 0, 0, 180, x, y, 270, 0.5, 0.5, true)
    -- local bullet2 = self:spawnBullet("gaster_blaster", arena_x, arena_y, -180, 0.5)
    local bullet = self:spawnBullet("tesco", 
    arena_x + bullet_reach_factor * arena.width, arena_y, false)
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