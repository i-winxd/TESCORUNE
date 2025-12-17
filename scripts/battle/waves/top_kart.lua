local TopKart, super = Class(Wave)

--- Drop-in replacement to Utils.random.
--- Can't move files, must be compatible with the
--- branch in september!
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


function TopKart:init()
    super.init(self)
    -- how long the battle lasts in seconds
    self.time = 11
    self.timer = Timer()
    self:addChild(self.timer)
    self.arena_x = (SCREEN_WIDTH * 0.4)

end

function TopKart:onStart()
    -- Get the arena object
    local arena = Game.battle.arena
    local x = SCREEN_WIDTH / 2
    local y = SCREEN_HEIGHT / 2
    local arena_x = arena.x
    local arena_y = arena.y
    -- self:spawnKartArray(arena_x, arena_y - 100, 4, 0, 10)
    self.timer:script(function (wait) 
        
    end)

    local kart_spawn_interval = 2
    local aspect_ratio = SCREEN_WIDTH / SCREEN_HEIGHT
    self.timer:everyInstant(kart_spawn_interval * 2, function() 
        self.timer:script(function (wait) 
            self:spawnKartArray((arena.x - arena.width/2), -30, 3, 0, 5)
            self:spawnKartArray((arena.x + arena.width / 2), SCREEN_HEIGHT + 30, 3, 180, 5 * aspect_ratio)
            wait(kart_spawn_interval)
            self:spawnKartArray(0, (arena.y + arena.height/2), 3, -90, 5)
            self:spawnKartArray(arena.x + SCREEN_WIDTH/4, (arena.y - arena.height / 2), 3, 90, 5 * aspect_ratio)
        end)
    end)
    local blasts = (1 + rander(0, 20, 5))
    local random_values = {0.06833506337494677, 0.6018319606252894, 0.6993382027676447, 0.43543916353742895, 0.6410912380006216, 0.27046775288910074, 0.20343955259325885, 0.8544953868679634, 0.3986672759155404, 0.8317283169857723, 0.5993500327734311, 0.23006427258260642, 0.7533953967428109, 0.2428209297084148, 0.9536111180887491, 0.2190210280951389, 0.5101117572730457, 0.383274622656924, 0.8716209991967329, 0.513512750575775612}
    self.timer:every(kart_spawn_interval * 0.8, function() 
        -- local aspect_ratio = 1
        -- local random_angle = rander(0, math.pi*2)
        local random_angle = random_values[((blasts - 1)%(#random_values))+1] * math.pi*2
        blasts = blasts + 1
        local ax, ay = math.cos(random_angle) * aspect_ratio, math.sin(random_angle)
        local auav_norm = math.sqrt(math.pow(ax, 2) + math.pow(ay, 2))
        local ax2, ay2 = ax/auav_norm, ay/auav_norm
        local actual_angle_radians = math.atan2(ay2, ax2)
        local actual_angle_degrees = math.deg(actual_angle_radians)
        local reach = SCREEN_HEIGHT * 0.4
        local far_reach = SCREEN_HEIGHT * 0.9
        
        local pa = actual_angle_degrees+90
        local rx, ry = arena.x, arena.y
        local blaster = self:spawn_blaster(rx+ax2*far_reach,
        ry+ay2*far_reach,pa,rx+ax2*reach,ry+ay2*reach,pa,
        18,4,true)
        blaster.scale_x = 1.6
    end)




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

    local w_oob = SCREEN_WIDTH * 1.15
    -- 0.000 to 0.020 is about half
    local arena = Game.battle.arena
    local times_called = 1
    self.timer:everyInstant(4, function()
        local pusher = 0
        local actual_patience = 1 * (times_called - 1)
        if times_called % 2 == 0 then
            pusher = rander(0.0, 0.5)    
        else
            pusher = rander(-0.5, -0.0)
        end
        spawn_bag_wave(w_oob, 
        arena_y + arena.height * (pusher * 0.5), arena_x + arena.width * 1.4,
        arena_y + arena.height * pusher, 5, 10, actual_patience)

        times_called = times_called + 1
    end)


end



function TopKart:spawnBag(x0, y0, x1, y1, x2, y2, d1, d2, d3) 
    local bagBullet = self:spawnBullet("tesco_bag", x0, y0, x1, y1, x2, y2, d1, d2, d3)
    return bagBullet
end

---@param x number
---@param y number
---@param count number
---@param angle number spawn the kart array facing this angle. the velocity will add pi/2
---@param vel number
function TopKart:spawnKartArray(x, y, count, angle, vel)
    local spacing = 30
    local angle_radians = math.rad(angle)
    local unit_x = math.cos(angle_radians)
    local unit_y = math.sin(angle_radians)

    local unit_x2 = math.cos(angle_radians + math.pi/2)
    local unit_y2 = math.sin(angle_radians + math.pi/2)
    for i = 1, count, 1 do
        local b_xpos = x + (unit_x * (spacing * (i-1)))
        local b_ypos = y + (unit_y * (spacing * (i-1)))
        local spawned_bullet = self:spawnBullet("standard_bullet", b_xpos, b_ypos, "bullets/tesco_icons/top_down_shopping_kart")
        spawned_bullet.rotation = angle_radians
        spawned_bullet.destroy_on_hit = false
        spawned_bullet.rotation = angle_radians
        spawned_bullet:setSpeed(unit_x2 * vel, unit_y2 * vel)
    end
end


---@param x number blaster spawns here initially
---@param y number blaster spawns here initially
---@param rot number blaster faces this direction initially (default -> +=cw), degrees
---@param target_x number blaster goes here eventually
---@param target_y number blaster goes here eventually
---@param target_rot number blaster faces this direction eventually
---@param wait_time number time spent before blasting
---@param blast_time number time spent during blasting
---@param play_sound boolean play the blast sound
function TopKart:spawn_blaster(x, y, rot, target_x, target_y, target_rot, wait_time, blast_time, play_sound)
    return self:spawnBullet("gaster_blaster", x, y, rot, target_x, target_y, target_rot, wait_time, blast_time, play_sound)
end



function TopKart:update()
    super.update(self)
end

return TopKart