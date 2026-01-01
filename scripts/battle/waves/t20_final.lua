local CurWave, super = Class(Wave)

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
local function ps_rander(n)
    local x = math.sin(n * 12.9898) * 43758.5453
    return x - math.floor(x)
end

--- Mutates the list and shuffles it.
local function shuffle_list(list)
    for i = #list, 2, -1 do 
        local j = rander(1, i, 1)
        list[i], list[j] = list[j], list[i]
    end
end


---@return string[]
local function clubcard_number_generator()
    local result = {}
    local max_digits = 16
    result[1] = tostring(rander(1,9,1))
    for i = 2, max_digits do 
        local new_digit
        repeat
            new_digit = tostring(rander(0,9,1))
        until new_digit ~= result[i-1]
        result[i] = new_digit
    end
    return result
end


function CurWave:init()
    self.prev_damages = {}
    super.init(self)

    self:setLayer(BATTLE_LAYERS["above_bullets"])


    -- how long the battle lasts in seconds
    self.time = 200
    self.timer = Timer()
    self:addChild(self.timer)
    --     self.arena_x = SCREEN_WIDTH/2 + x
    -- self.arena_y = (SCREEN_HEIGHT - 155)/2 + 10 + y
    -- self.arena_x = (SCREEN_WIDTH * 0.3)
    -- self.arena_y = (SCREEN_HEIGHT - 155) / 2 + 10
    self.arena_x = SCREEN_WIDTH * 0.5
    self.arena_y = SCREEN_HEIGHT * 0.5
    self.arena_height = SCREEN_HEIGHT * 1.1
    self.arena_width = SCREEN_WIDTH * 1.1
    self.clubcard_id = clubcard_number_generator()
    self.clubcard_string = table.concat(self.clubcard_id)
    self.clubcard_string_formatted = self.clubcard_string:gsub("(....)", "%1 "):gsub("%s$", "")

    self.cooling_down = false
    self.buttons = {}

    self.no_correct = 0
end


--- Called whenever a number is pressed
---@param num number
function CurWave:number_pressed(num)
    local num_as_str = tostring(num)
    -- print("NUMBER PRESSED: " .. num)
    local required_number = self:getRequiredNumber(self.no_correct)
    -- print("NUMBER REQUIRED "..required_number)
    if tostring(required_number) == tostring(num) then 
        self:on_correct()
    else
        self:on_incorrect(tonumber(num))
    end
end

function CurWave:getRequiredNumber(num)
    return tostring(self.clubcard_id[num+1])
end

function CurWave:determine_blanks()
    local tbl = {}
    for i = 1, #self.clubcard_id do 
        local cur_blip = self.clubcard_id[i]
        if self.no_correct >= i then 
            table.insert(tbl, cur_blip)
        else
            table.insert(tbl, "_")
        end
    end
    local as_str = table.concat(tbl):gsub("(....)", "%1 "):gsub("%s$", "")
    return as_str
end


function CurWave:set_correct(num)
    self.no_correct = num
    if self.no_correct == 3 then 
        self:shuffle_numerics()
    end
    if self.no_correct == 5 then 
        self:randomize_positions()
    end
    if self.no_correct == 7 then 
        self:randomize_positions()
    end
    if self.no_correct == 8 then 
        self:enable_bounce(3)
    end
    if self.no_correct == 12 then 
        self:shuffle_numerics()
    end
    if self.no_correct == 16 then 
        self.timer:script(function(wait) 
            wait(0.8)
            self:setFinished()
        end)
    end

    if self.no_correct == 7 then 
        local spawned_tesco = self:spawnBullet("t20_final/tesco_independent", SCREEN_WIDTH * 0.7, SCREEN_HEIGHT * 0.5)
        spawned_tesco.intangible = true
        self.timer:script(function(wait) 
            for i = 1, 3 do 
                spawned_tesco.alpha = 0.3
                wait(0.3)
                spawned_tesco.alpha = 0.6
                wait(0.3)
            end
            spawned_tesco.intangible = false
            spawned_tesco.alpha = 1
        end)
    end
end

function CurWave:on_correct()
    local cooldown_period = 0.8
    if self.cooling_down then
        return
    end
    -- self.no_correct = self.no_correct + 1
    self:set_correct(self.no_correct + 1)
    local expected_text = self:determine_blanks()
    self.actual_cc:set_text(expected_text)
    self.cooling_down = true
    self:for_all_buttons(function(n, bt) 
        bt:set_selectable(false)
    end)
    -- print("MUST CALL THE NO COOL DOWN")
    self.timer:script(function(wait) 
        -- print("INTO COOLDOWN THING")
        wait(cooldown_period)
        self.cooling_down = false
        -- print("NO LONGER COOLING DOWN")
        self:for_all_buttons(function(n, bt) 
            bt:set_selectable(true)
        end)
    end)
end

function CurWave:on_incorrect(num)
    if num == 0 then 
        num = 10
    end
    local attackers = self:getAttackers()
    local highest_atk = 1
    local strongest_attacker = nil
    for i = 1, #attackers do 
        local attack_stat = attackers[i].attack or 1
        if attack_stat > highest_atk then 
            highest_atk = attack_stat
            strongest_attacker = attackers[i]
        end
    end
    -- highest_atk is the damage
    if strongest_attacker ~= nil then 
        local damage_to_deal = highest_atk * 5
        local damage = damage_to_deal / 3
        local target = strongest_attacker.current_target
        -- local target = strongest_attacker:getTarget()
        local soul = Game.battle.soul
        local battlers = Game.battle:hurt(damage, false, target, false)
        soul.inv_timer = 1
        soul:onDamage(self.buttons[num], damage)
    end
end

---@param func fun(n:number,btn:any) Apply this fn to this button, for all buttons, where n is the number of that button
function CurWave:for_all_buttons(func)
    for i = 0, 9 do 
        if i == 0 then 
            i = 10
        end
        local btn = self.buttons[i]
        func(i, btn)
    end
end

--- Turns on item movement and bouncing.
---@param speed number
function CurWave:enable_bounce(speed)
    local get_angle = function(i) 
        if i < 2 then -- 0, 1
            return math.pi/4 
        elseif i < 5 then  -- 2, 3, 4
            return math.pi*(3/4)
        elseif i < 8 then -- 5, 6, 7
            return math.pi*(5/4)
        else
            return math.pi*(7/8)
        end 
    end
    self:for_all_buttons(function(n, btn) 
        local that_angle = get_angle(n)
        btn.collides_with_others = true
        btn.physics.speed = speed
        btn.physics.direction = that_angle
    end)
end

function CurWave:randomize_positions()
    local mh = 10
    local mw = 0
    local points = {}
    local border = 200
    local margin = 10
    local max_attempts = 2000
    local W = SCREEN_WIDTH
    local H = SCREEN_HEIGHT
    local failed = false
    for i = 1, #self.buttons do 
        local R = self.buttons[i].width / 2
        for attempt = 1, max_attempts do 
            local x = rander(R+border+mw,W-R-border)
            local y = rander(R+border+mh, H-R-border)
            local valid = true
            for j = 1, #points do 
                local pt = points[j]
                local px = pt[1]
                local py = pt[2]
                if math.abs(x - px) < 2 * R + margin and math.abs(y-py) < 2 * R + margin then 
                    valid = false
                    break
                end
            end
            if valid then 
                table.insert(points, {x, y})
                break
            end
            if attempt == max_attempts then 
                failed = true
            end
        end
        if failed then 
            break
        end
    end
    if failed or #points ~= #self.buttons then
        -- print("Could not randomize the points for some reason")
        return
    end
    -- print("POINTS COLLECTED: ".. #points)
    -- print("POINT CONTENTS: " .. points[1][1] .. "," .. points[1][2])
    self:for_all_buttons(function (n, btn)
        -- print("All buttons being called w/ n = "..n)
        local points_acquired = points[n]
        btn.x = points_acquired[1]
        btn.y = points_acquired[2]
    end)
end

function CurWave:shuffle_numerics()
    local collected_pos = {}
    for j = 1, #self.buttons do
        table.insert(collected_pos, {self.buttons[j].x, self.buttons[j].y})
    end
    shuffle_list(collected_pos)
    for j = 1, #self.buttons do 
        local cpos = collected_pos[j]
        self.buttons[j].x = cpos[1]
        self.buttons[j].y = cpos[2]
    end
end

function CurWave:onEnd(death)
    local attackers = self:getAttackers()
    for i = 1, #attackers do 
        if i >= 1 and i <= #self.prev_damages and i <= #attackers then 
            attackers[i].attack = self.prev_damages[i]
        end
    end
    if not death and self._original_soul then
        Game.battle:swapSoul(self._original_soul)
        self._original_soul = nil
    end
end


---@alias ClubcardPosInfo {number:number,x:number,y:number}

function CurWave:onStart()
    local attackers = self:getAttackers()
    for i = 1, #attackers do 
        table.insert(self.prev_damages, attackers[i].attack)
        attackers[i].attack = attackers[i].attack / 2
    end


    self._original_soul = Game.battle.soul
    local standard_soul = Soul()
    Game.battle:swapSoul(standard_soul)

    local arena = Game.battle.arena
    local ax, ay = Game.battle.arena:getCenter()
    local ah = Game.battle.arena.height
    local aw = Game.battle.arena.width
    
    local cx, cy = SCREEN_WIDTH/2, SCREEN_HEIGHT/2
    local xgap = 100
    local ygap = 70
    local x0 = 0
    local y0 = 100
    
    ---@type ClubcardPosInfo[]
    local numeric_locations = {
        { number = 1, x = cx - xgap, y = cy - ygap * 2 },
        { number = 2, x = cx,        y = cy - ygap * 2 },
        { number = 3, x = cx + xgap, y = cy - ygap * 2 },

        { number = 4, x = cx - xgap, y = cy - ygap },
        { number = 5, x = cx,        y = cy - ygap },
        { number = 6, x = cx + xgap, y = cy - ygap },

        { number = 7, x = cx - xgap, y = cy },
        { number = 8, x = cx,        y = cy },
        { number = 9, x = cx + xgap, y = cy },

        { number = 0, x = cx,        y = cy + ygap }
    }
    
    for i = 1, #numeric_locations do 
        local numeric_instance = numeric_locations[i]
        local btn = self:spawnBullet("t20_final/numeric", numeric_instance.x + x0, numeric_instance.y + y0, numeric_instance.number)
        table.insert(self.buttons, btn)
    end

    local enter_your = self:spawnBullet("text_display", cx, 20, 16, true, "Verify your Clubcard number (Press Z on the dial)")
    local base_cc = self:spawnBullet("text_display", cx, 45, 16, true, "(It's ".. self.clubcard_string_formatted .. ")")
    local actual_cc = self:spawnBullet("text_display", cx, 70, 16, false, "____ ____ ____ ____")
    self.actual_cc = actual_cc
    -- self:spawnBullet("t20_final/numeric", ax, ay, 2)
    local get_wt = function() 

        local min_wt = 0.45
        local max_wt = 0.8
        local progression = math.max(1,math.min(0,math.floor((self.no_correct-6)/10)))
        return (1-progression)*max_wt + progression*min_wt

    end
    local sl = 1
    local wt = 0.65
    local function spawn_bag_wave(x0, y0, x1, y1, count, gap, patience)
        self.timer:script(function (wait)
            local n = math.max(1, math.floor(count/2) - 1)
            for i = 0, n do
                wait(0.15)
                local bag_spawned = self:spawnBag(x0 + i * gap, y0, x1 + i * gap, y1, x0, y0, 2, patience, 1)
            end
        end)
    end
    local arena = {
        x = SCREEN_WIDTH / 2,
        y = SCREEN_HEIGHT / 2,
        width = SCREEN_WIDTH * 0.3,
        height = SCREEN_HEIGHT * 0.3
    }
    local w_oob = SCREEN_WIDTH * 1.15
    local bag_waves_spawned = 1

        local summon_bag_waves = function() 
            local ay = arena.y
            local ah = arena.height
            local ax = arena.x
            local aw = arena.width
            local pusher = 0
            local actual_patience = 0.15 * (bag_waves_spawned - 1)
            if bag_waves_spawned % 2 == 0 then
                pusher = rander(0.0, 0.5)    
            else
                pusher = rander(-0.5, -0.0)
            end
            spawn_bag_wave(w_oob, 
            ay + ah * (pusher * 0.5), ax + aw * 1,
            ay + ah * pusher, 5, 10, actual_patience)

            bag_waves_spawned = bag_waves_spawned + 1
        end


    self.timer:script(function(wait) 
        for i = 1, 99999 do
            wait(get_wt())
            if self.no_correct >= 1 and rander(0, 10) < self.no_correct * 1.3 then 
                print("SPAWNING BAG WAVE")

                summon_bag_waves()
        
            end
            wait(get_wt())


            if self.no_correct >= 3 then 

                if rander(0,10) < self.no_correct then
                    print("SPAWNING GRENADE WAVE")
                    self.timer:script(function(wait2) 
                        wait2(1)
                        for k = 1, math.floor(self.no_correct / 3) do 
                            wait2(0.3)
                            self:spawn_grenade_wave(i, k+i*100+4238)
                        end
                    end)
                end
            end
            wait(get_wt())

            if self.no_correct >= 7 then 
                if rander(0, 40) < self.no_correct then 
                    print("SPAWNING KART STACK")
                    self:spawnBullet("kart/kart_stack", SCREEN_WIDTH, SCREEN_HEIGHT/2+90, 0.3, 0.4)
                end
            end
            wait(get_wt())

            if self.no_correct >= 9 then 
                
            end
            wait(get_wt())

            if self.no_correct >= 9 then 
                if rander(0, 16) < self.no_correct then 
                    self:spawnTruck()
                end
            end
            wait(get_wt())

            if self.no_correct >= 14 then 

            end
            wait(get_wt())
            
            
            
            sl = sl + 1
        end
    end)

end



function CurWave:spawnBag(x0, y0, x1, y1, x2, y2, d1, d2, d3) 
    local bagBullet = self:spawnBullet("tesco_bag", x0, y0, x1, y1, x2, y2, d1, d2, d3)
    bagBullet.intangible = true
    bagBullet.can_graze = false
    return bagBullet
end


---@param i number
---@param rand_seed number
function CurWave:spawn_grenade_wave(i, rand_seed)
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
    local rand_value = rand_seed
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
end


function CurWave:update()
    super.update(self)
end


function CurWave:spawnTruck()
    local ax, ay = SCREEN_WIDTH/2, SCREEN_HEIGHT/2
    local ah = SCREEN_HEIGHT * 0.8
    local aw = SCREEN_WIDTH * 0.6

    local lanes = 8

    local get_lane_center = function(lane_no) 
        local lane_start = ay - (ah/2)
        local lane_end = ay + (ah/2)
        local lane_width = (lane_end - lane_start) / lanes
        return lane_start + (lane_no - 0.5) * lane_width
    end
    local truck_speed = 10
    local ts = 0.5
    local truck_spawn_offset = 200

    local immediately_spawn_truck = function(lane_no, facing_right) 
        local spawned_bullet
        Assets.playSound("snd_drive", 0.7)
        if facing_right then
            -- x, y, dir, speed, texture
            local spawned_bullet = self:spawnBullet("basic_bullet", 
                0 - truck_spawn_offset,
                get_lane_center(lane_no),
                0,
                truck_speed,
                "bullets/t03_truck/tesco_truck"
            )
            spawned_bullet.scale_x = spawned_bullet.scale_x * ts
            spawned_bullet.scale_y = spawned_bullet.scale_y * ts
            spawned_bullet.destroy_on_hit = false
        else 
            local spawned_bullet = self:spawnBullet("basic_bullet", 
                SCREEN_WIDTH + truck_spawn_offset,
                get_lane_center(lane_no),
                math.rad(180),
                truck_speed,
                "bullets/t03_truck/tesco_truck_flipped"
            )
            spawned_bullet.scale_x = -spawned_bullet.scale_x * ts
            spawned_bullet.scale_y = spawned_bullet.scale_y * ts
            spawned_bullet.destroy_on_hit = false
        end
    end


    -- immediately_spawn_truck(1, true)
    local pitch_table_length = 2
    local pa_offset = -1
    local warning_gap = 0.75
    local warning_offset = 200
    local warning_held_length = 0.1
    local warning_beep_length = 0.2

    local make_truck_wave = function(lane_no, facing_right) 
        --t03_truck/flash_icon / x, y,dir,speed,texture,beep_pitch_table,held_length(0.10)
        local pitch_table = {}
        for i = 1, pitch_table_length, 1 do
            table.insert(pitch_table, lane_no + pa_offset)
        end
        local y_coord_center = get_lane_center(lane_no)
        
        local warning_position
        local warning_texture
        if facing_right then
            warning_position = ax - warning_offset
            warning_texture = "bullets/t03_truck/warning_sign_RIGHT"
        else
            warning_position = ay + warning_offset
            warning_texture = "bullets/t03_truck/warning_sign_LEFT"
        end
        self.timer:script(function(wait) 
            local warning_symbol = self:spawnBullet("t03_truck/flash_icon", 
            warning_position,
            y_coord_center,
            0,
            0,
            warning_texture,
            pitch_table,
            warning_held_length,
            warning_beep_length
            )
            wait(1)
            immediately_spawn_truck(lane_no, facing_right)
        end)
    end

    local spawn_truck_every = 1.25
    local interval_decay = 0.15
    local minimum_truck_spawn = 0.75

    local truck_spawner = function() 
        local position = rander(1, lanes, 1)
        local face_right_bool = rander(0, 1)
        local face_right = false
        if face_right_bool > 0.5 then
            face_right = true
        end
        make_truck_wave(position, face_right)
    end

    truck_spawner()
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
function CurWave:spawn_grenade(x,y,dir,speed,texture,gravity,rot_vel,fuse,frags,frag_speed)
    return self:spawnBullet("t07_grenades/grenade",x,y,dir,speed,texture,gravity,rot_vel,fuse,frags,frag_speed)
end

return CurWave