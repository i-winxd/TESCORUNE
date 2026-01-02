-- Behavior like tesco.lua,
-- but moves three times at once

local TescoBullet2, super = Class(Bullet)

--- Drop-in replacement to rander.
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


---@param x number
---@param y number
function TescoBullet2:init(x, y, movements, gap_mult)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/tesco_sprite_aa")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    -- self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    -- self.physics.speed = speed
    self.destroy_on_hit = false
    self.scale_x = 1.4
    self.scale_y = 1.4
    self.cur_deg = 0
    self.timer = Timer()
    self:addChild(self.timer)
    self.movements = movements or 3
    self.gap_mult = gap_mult or 1

    -- self.wave:spawnBullet("pound_symbol", 0, 0, 0, 6);
end


local function calculateTescoPosition(deg, the_arena, bullet_reach_factor) 
    local cur_deg = deg
    local reach = bullet_reach_factor * math.sqrt((the_arena.width / 2) ^ 2 + (the_arena.height / 2) ^ 2)
    local angle_rad = math.rad(cur_deg)
    local final_x = the_arena.x + math.cos(angle_rad) * reach * 1.2
    local final_y = the_arena.y + math.sin(angle_rad) * reach * 0.8
    return {reach = reach, angle_rad = angle_rad, final_x = final_x, final_y = final_y}
end


function TescoBullet2:onAdd()
    local arena = Game.battle.arena
    local bullet_reach_factor = 2
    local minimum_rotation = 120

    local function calculateNewRotateOffset() 
        local coin_flip = rander(0, 1) > 0.5
        local plus_minus
        if coin_flip then
            plus_minus = 1
        else
            plus_minus = -1
        end
        local rand_value = (rander(minimum_rotation, 240)) * plus_minus
        return rand_value
    end
    local pre_gap = 0.4
    local move_gap = 0.25
    local between_gap = 0.6
    local move_actual_gap = 0.4
    local post_gap = 0.4

    local movements = self.movements
    local time_between_loops = (move_gap + move_actual_gap) * movements + between_gap + post_gap
    local tesco_sounds = { "tesco/tesco_bagging", "tesco/tesco_item", "tesco/tesco_unexpected" };
    self.timer:script(function(waait)
        waait(pre_gap*self.gap_mult) 
        self.timer:everyInstant(time_between_loops*self.gap_mult, function () 
            self.timer:script(function(wait)
                local movement_values = {}
                local base_rotation = 0
                for i = 1, movements do 
                    base_rotation = base_rotation + calculateNewRotateOffset()
                    table.insert(movement_values, base_rotation)
                end
                
                self.cur_deg = base_rotation
                for i = 1, movements do
                    -- TODO: MOVE WARN GAP
                    local new_rotation = movement_values[i]
                    local rotation_info = calculateTescoPosition(new_rotation,
                    arena, bullet_reach_factor)
                    self.wave:spawnBullet(
                        "tesco_warning",
                        rotation_info.final_x,
                        rotation_info.final_y,
                        rotation_info.angle_rad,
                        {i-1},
                        0.25*self.gap_mult
                    )
                    wait(move_gap*self.gap_mult)
                end
                wait(between_gap*self.gap_mult)
                for i = 1, movements do
                    local new_rotation = movement_values[i]
                    local rotation_info = calculateTescoPosition(new_rotation, arena, bullet_reach_factor)
                    local sound_choice = rander(1, #tesco_sounds, 1)
                    Assets.playSound(tesco_sounds[sound_choice], 1)
                    self.timer:tween(math.min(move_actual_gap, 0.4)*self.gap_mult, self, { 
                        x = rotation_info.final_x,
                        y = rotation_info.final_y,
                        rotation = rotation_info.angle_rad 
                    },
                    "out-quint", function() 
                        
                    end)
                    if i ~= movements then
                        wait(move_actual_gap*self.gap_mult)
                    end
                end
                self:spew(1, 5)
                self:spew(1, 40)

            end)
        end)
    end)
    if 1 == 1 then
        return
    end
end

function TescoBullet2:spew(count, entropy)
    for i = 1, count do
        local me_x, me_y = self:getRelativePos(self.width / 2, self.height / 2)
        -- Game.battle.soul.x
        local rand_angle = math.rad(rander(-entropy, entropy))
        local angle_diff = Utils.angle(me_x, me_y, Game.battle.soul.x, Game.battle.soul.y)
        if self.wave ~= nil then
            self.wave:spawnBullet("pound_symbol", me_x, me_y, angle_diff + rand_angle, 7)
        end
    end
end

function TescoBullet2:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return TescoBullet2
