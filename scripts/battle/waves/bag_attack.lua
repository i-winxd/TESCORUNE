local BagAttack, super = Class(Wave)

function BagAttack:init()
    super.init(self)
    -- how long the battle lasts in seconds
    self.time = 7
    self.timer = Timer()
    self:addChild(self.timer)
    self.arena_x = (SCREEN_WIDTH * 0.4)
    self.arena_y = (SCREEN_HEIGHT - 155) / 2 + 10
    self.arena_height = SCREEN_HEIGHT * 0.35
end

function BagAttack:onStart()
    -- Get the arena object
    local arena = Game.battle.arena
    local x = SCREEN_WIDTH / 2
    local y = SCREEN_HEIGHT / 2
    local w_oob = SCREEN_WIDTH * 1.15

    local arena_x = arena.x
    local arena_y = arena.y
    --- % of height
    ---@param pc number
    local function htp(pc)
        return SCREEN_HEIGHT * pc
    end

    local bullet_reach_factor = 2
    -- x, y, rot, target_x, target_y, target_rot, wait_time, blast_time, play_sound
    -- local bullet = self:spawnBullet("gaster_blaster", 0, 0, 180, x, y, 270, 0.5, 0.5, true)
    -- local bullet2 = self:spawnBullet("gaster_blaster", arena_x, arena_y, -180, 0.5)
    -- local bullet = self:spawnBullet("tesco", arena_x + bullet_reach_factor * arena.width, arena_y,
        -- self)
    -- self:spawnBag(w_oob, htp(0.5), arena_x, arena_y, w_oob, htp(0.5), 1, 0.2, 1)

    -- bag_wave_spawn(w_oob, htp(0.5), arena_x, arena_y, 10, 5)
    ---@param x0 number
    ---@param y0 number
    ---@param x1 number
    ---@param y1 number
    ---@param count number
    ---@param gap number
    local function spawn_bag_wave(x0, y0, x1, y1, count, gap, patience)
        self.timer:script(function (wait)
            local n = math.floor(count) - 1
            for i = 0, n do
                wait(0.15)
                self:spawnBag(x0 + i * gap, y0, x1 + i * gap, y1, x0, y0, 2, patience, 1)
            end
        end)
    end
    -- 0.000 to 0.020 is about half
    local arena = Game.battle.arena
    local times_called = 1
    self.timer:everyInstant(1.2, function()
        local pusher = 0
        local actual_patience = 0.15 * (times_called - 1)
        if times_called % 2 == 0 then
            pusher = Utils.random(0.0, 0.5)    
        else
            pusher = Utils.random(-0.5, -0.0)
        end
        spawn_bag_wave(w_oob, 
        arena_y + arena.height * (pusher * 0.5), arena_x + arena.width * 1,
        arena_y + arena.height * pusher, 5, 10, actual_patience)

        times_called = times_called + 1
    end)
end


function BagAttack:spawnBag(x0, y0, x1, y1, x2, y2, d1, d2, d3) 
    local bagBullet = self:spawnBullet("tesco_bag", x0, y0, x1, y1, x2, y2, d1, d2, d3)
    return bagBullet
end


function BagAttack:update()



    -- Increment timer for arena movement
    -- self.siner = self.siner + DT

    -- Calculate the arena Y offset
    -- local offset = math.sin(self.siner * 1.5) * 60

    -- Move the arena
    -- Game.battle.arena:setPosition(self.arena_start_x, self.arena_start_y + offset)

    super.update(self)
end

return BagAttack