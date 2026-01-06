local TescoBullet, super = Class(Bullet)

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
function TescoBullet:init(x, y, muted)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/tesco_sprite_aa")
    self.muted = muted
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    -- self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    -- self.physics.speed = speed
    self.destroy_on_hit = false
    self.scale_x = 1.4
    self.scale_y = 1.4
    local hitbox_mult = 0.25
    self.collider = Hitbox(self, self.width*((1-hitbox_mult)/2), self.height*((1-hitbox_mult)/2), self.width*hitbox_mult, self.height*hitbox_mult)

    self.timer = Timer()
    self:addChild(self.timer)

    -- self.wave:spawnBullet("pound_symbol", 0, 0, 0, 6);
end
local function linspace(N, a, b)
    local result = {}

    if N == 1 then
        result[1] = a
        return result
    end

    local step = (b - a) / (N - 1)

    for i = 0, N - 1 do
        result[i + 1] = a + i * step
    end

    return result
end
function TescoBullet:onAdd()
    local muted = self.muted
    local arena = Game.battle.arena
    local bullet_reach_factor = 2
    local cur_deg = 0
    local minimum_rotation = 120
    self.timer:script(function(wait)
        wait(0.5)
        self.timer:everyInstant(1.5, function()
        self.timer:script(function(wait)
            -- wait(0.01)
            local coin_flip = rander(0, 1) > 0.5
            local plus_minus
            if coin_flip then
                plus_minus = 1
            else
                plus_minus = -1
            end
            local selected_deg = cur_deg + (plus_minus * (rander(minimum_rotation, 360)))
            cur_deg = selected_deg
            local reach = bullet_reach_factor * math.sqrt((arena.width / 2) ^ 2 + (arena.height / 2) ^ 2)
            local angle_rad = math.rad(selected_deg)
            local final_x = arena.x + math.cos(angle_rad) * reach * 1.2
            local final_y = arena.y + math.sin(angle_rad) * reach * 0.8
            local pitch_table = {0, 0}
            if self.muted then 
                pitch_table = {nil, nil}
            end
            if self.wave ~= nil then
                self.wave:spawnBullet("tesco_warning", final_x, final_y, angle_rad, pitch_table)
            end
            wait(0.55)

            local tesco_sounds = { "tesco/tesco_bagging", "tesco/tesco_item", "tesco/tesco_unexpected" };
            local sound_choice = rander(1, #tesco_sounds, 1)
            if not self.muted then
                Assets.playSound(tesco_sounds[sound_choice], 1)
            end
            self.timer:tween(0.5, self, { x = final_x, y = final_y, rotation = angle_rad },
                "out-quint")
            -- wait(0.6)
            wait(0.45)
            local linspace_res = linspace(3, -25, 35)
            for i = 1, 3 do
                local me_x, me_y = self:getRelativePos(self.width / 2, self.height / 2)
                -- Game.battle.soul.x
                -- local rand_angle = math.rad(rander(-15, 15))
                local rand_angle = math.rad(linspace_res[i]) + math.rad(rander(-6, 6))
                local angle_diff = Utils.angle(me_x, me_y, Game.battle.soul.x, Game.battle.soul.y)
                if self.wave ~= nil then
                    self.wave:spawnBullet("pound_symbol", me_x, me_y, angle_diff + rand_angle, 7)
                end
                wait(0.05)
            end
            local me_x, me_y = self:getRelativePos(self.width / 2, self.height / 2)
            local rand_angle = math.rad(rander(-7, 7))

            local angle_diff = Utils.angle(me_x, me_y, Game.battle.soul.x, Game.battle.soul.y)
            if self.wave ~= nil then
                self.wave:spawnBullet("pound_symbol", me_x, me_y, angle_diff + rand_angle, 7)
            end  

        end)
        end)
    end)
end

function TescoBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return TescoBullet
