local T03Truck, super = Class(Wave)


function T03Truck:init()
    super.init(self)  -- remember this!!!
    self.time = 15
    -- self.arena_x = (SCREEN_WIDTH * 0.4)
    -- self.arena_y = (SCREEN_HEIGHT - 155) / 2 + 10
    self.arena_height = SCREEN_HEIGHT * 0.40
    self.arena_width = SCREEN_WIDTH * 0.30
    self.arena_x = SCREEN_WIDTH * 0.5
    self.arena_y = SCREEN_HEIGHT * 0.7 * 0.5
    self.timer = Timer()
    self:addChild(self.timer)
    self.trucks_spawned = 0


    self.truck_spawning_sequence = {



    }


end

function T03Truck:onEnd(death)
    if not death and self._original_soul then
        Game.battle:swapSoul(self._original_soul)
        self._original_soul = nil
    end
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
function T03Truck:psRander(a, b, c)
    -- from a to b rounded to nearest c
    local sequence_number = self.trucks_spawned
    local rdn
    if sequence_number % 5 == 3 then
        local tmp = rander(1, 2, 1)
        if tmp >= 1.5 then
            rdn = a
        else
            rdn = b
        end
    else 
        rdn = rander(a,b,c)
    end


    self.trucks_spawned = self.trucks_spawned + 1
    return rdn
end

function T03Truck:onStart()
    self._original_soul = Game.battle.soul
    local standard_soul = Soul()
    Game.battle:swapSoul(standard_soul)

    local ax, ay = Game.battle.arena:getCenter()
    local ah = Game.battle.arena.height
    local aw = Game.battle.arena.width

    local lanes = 4

    local get_lane_center = function(lane_no) 
        local lane_start = ay - (ah/2)
        local lane_end = ay + (ah/2)
        local lane_width = (lane_end - lane_start) / lanes
        return lane_start + (lane_no - 0.5) * lane_width
    end
    local truck_speed = 20
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
            warning_position = Game.battle.arena.x - warning_offset
            warning_texture = "bullets/t03_truck/warning_sign_RIGHT"
        else
            warning_position = Game.battle.arena.x + warning_offset
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
            wait(0.35)
            immediately_spawn_truck(lane_no, facing_right)
        end)
    end

    local spawn_truck_every = 1.25
    local interval_decay = 0.15
    local minimum_truck_spawn = 0.75

    local truck_spawner = function() 
        local position = self:psRander(1, lanes, 1)
        local face_right_bool = rander(0, 1)
        local face_right = false
        if face_right_bool > 0.5 then
            face_right = true
        end
        make_truck_wave(position, face_right)
    end

    self.timer:script(function(wait) 
        wait(0.5)
        local truck_interval = spawn_truck_every
        while true do
            truck_spawner()
            wait(truck_interval)

            truck_interval = math.max(minimum_truck_spawn, truck_interval - interval_decay)
        end

        -- self.timer:everyInstant(spawn_truck_every, function() 
        --     local position = rander(1, lanes, 1)
        --     local face_right_bool = rander(0, 1)
        --     local face_right = false
        --     if face_right_bool > 0.5 then
        --         face_right = true
        --     end
        --     make_truck_wave(position, face_right)
        -- end)
    end)

end

return T03Truck