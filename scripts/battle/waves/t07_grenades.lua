local CURWAVE, super = Class(Wave)

--- Tip: the scanner will never be in exactly the same place it was before.
--- If you entered the scanner's fading red light,
--- you will have enough time to move to an area that won't be covered by
--- the scanner on the next move.
function CURWAVE:init()
    super.init(self)

    -- Initialize timer
    -- self.siner = 0
    
    -- how long the battle lasts in seconds
    -- self.arena_y = (SCREEN_HEIGHT*0.7*0.675)
    self.arena_width = (SCREEN_WIDTH * 0.25)
    self.arena_height = (SCREEN_WIDTH * 0.7 * 0.35)
    self.time = 20
    
    self.timer = Timer()
    self:addChild(self.timer)
end

function CURWAVE:onEnd(death)
    super.onEnd(self,death)
end

local function ps_rander(n)
    local x = math.sin(n * 12.9898) * 43758.5453
    return x - math.floor(x)
end
local function rander(a, b, c)
    local function roundToMultiple(value, to)
        if to == 0 then
            return 0
        end

        return math.floor((value + (to / 2)) / to) * to
    end

    if not a then
        return love.math.random()
    elseif not b then
        return love.math.random() * a
    else
        local n = love.math.random() * (b - a) + a
        if c then
            n = roundToMultiple(n, c)
        end
        return n
    end
end

---@param x number
---@param y number
---@param dir number THIS IS IN DEGREES
---@param speed number
---@param texture string
---@param gravity number
---@param rot_vel number THIS IS IN DEGREES
---@param fuse number
---@param frags number
---@param frag_speed number
function CURWAVE:spawn_grenade(x,y,dir,speed,texture,gravity,rot_vel,fuse,frags,frag_speed)
    return self:spawnBullet("t07_grenades/grenade",x,y,dir,speed,texture,gravity,rot_vel,fuse,frags,frag_speed)
end

function CURWAVE:onStart()

    -- Get the arena object
    local arena = Game.battle.arena
    local ax, ay = Game.battle.arena:getCenter()
    local ah = Game.battle.arena.height
    local aw = Game.battle.arena.width
    -- t07_grenades/grenade
    -- x, y, dir, speed, texture, gravity, rot_vel, fuse, frags, frag_speed
    local rand_value = rander(0, 10, 1)
    local max_throws = 200

    local right_spawn = SCREEN_WIDTH + 10
    local left_spawn = -10
    local right_rot_vel = -15
    local left_rot_vel = 15
    local left_min_deg = -60
    local left_max_deg = 60
    local right_max_deg = 180+60
    local right_min_deg = 180-60
    local height_falloff = 0.15
    local low_spawn = SCREEN_HEIGHT * 0.7 * height_falloff
    local high_spawn = SCREEN_HEIGHT * 0.7 * (1-height_falloff)

    local calc_wait_time = function(counter) 
        return 0.2
    end

    self.timer:script(function(wait)
        for i = 1, max_throws do
            local rander_3 = ps_rander(i+rand_value+98182)
            local rander_4 = ps_rander(i+rand_value+2394)
            local grenade_speed = 6
            local lr_rander = ps_rander(i+rand_value+34925)
            local gre_fuse, gre_frags, gre_frag_speed = 0.8+rander_4*0.8, math.min(6, 2+math.floor(rander_3*(i/5))), (4+math.min(3, math.floor(i/6)*rander_3))/1.5
            local spawnpoint  -- for X
            local gravity = 0.06
            local rot_vel
            local min_deg
            local max_deg
            if lr_rander > 0.5 then
                spawnpoint = right_spawn
                rot_vel = right_rot_vel
                min_deg = right_min_deg
                max_deg = right_max_deg
            else
                spawnpoint = left_spawn
                rot_vel = left_rot_vel
                min_deg = left_min_deg
                max_deg = left_max_deg
            end
            local yspawn_rand = ps_rander(i+rand_value+12144)
            local y_spawn_point = low_spawn*(1-yspawn_rand) + (yspawn_rand) * high_spawn
            local rander_2 = ps_rander(i+rand_value+62382)
            local angle = min_deg*(1-rander_2) + max_deg*rander_2
            local spawned_grenade = self:spawn_grenade(spawnpoint, y_spawn_point, angle-rot_vel*1, grenade_speed, "bullets/t07_grenades/grenade", gravity, rot_vel, gre_fuse, gre_frags, gre_frag_speed)
            spawned_grenade:setScale(2,2)
            local wait_time = calc_wait_time(i)
            wait(wait_time)
        end
    end)
end

function CURWAVE:update()
    super.update(self)
end

return CURWAVE