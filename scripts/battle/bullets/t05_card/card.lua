local BulletCard, super = Class(Bullet)



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


---@param a number[]
---@param b number[]
local function vadd(a, b)
    return {a[1] + b[1], a[2]+b[2]}
end

---@param s number
---@param a number[]
local function vsmult(s, a)
    return {s*a[1], s*a[2]}
end

--- Assume a is immutable
---@param a number[]
local function normalize(a)
    if (a[1] ^ 2) + (a[2] ^ 2) == 0 then
        return a
    else
        return vsmult(1/(math.sqrt((a[1]^2) + (a[2]^2))), a)
    end
end

---@param x number
---@param y number
function BulletCard:init(ix, iy, x, y)
    -- Last argument = sprite path
    self.ix, self.iy = ix, iy
    self.remove_offscreen = false
    super.init(self, x, y, "bullets/t05_card/credit_card_object")
    self.scale_x = 1
    self.scale_y = 1
    self:setLayer(-1)
    self.timer = Timer()
    self:addChild(self.timer)

end


local function ps_rander(n)
    local x = math.sin(n * 12.9898) * 43758.5453
    return x - math.floor(x)
end

function BulletCard:onAdd(parent)
    ---@type number[]
    local origin = {self.ix, self.iy}

    -- Where duration is the duration it takes to move there,
    -- and on_finish is what is called when that animation finishes
    -- "out" means starts fast
    -- "in" means starts slow
    -- the only methods are "linear" "in-quad" "out-quad"
    ---@alias MovableInstance { position: number[]|nil, duration: number, interpolate: string, on_finish: function|nil }
    local std_dur = 0.4
    local std_min_dur = 0.17
    local b = 40
    local max_b = 70
    local seed = rander(0, 5, 1)
    local called_count = 1 + seed * 4219
    local on_bounce = function() 
        Game.battle:shakeCamera(3)
        local cx, cy = self:localToScreenPos(self.x, self.y)
        Assets.playSound("snd_impact", 1)
        -- x, y, dir, speed, texture, gravity, rot_vel
        local spread_list = {-75, -65, -60, -50, -45, -40, -20, -5, 30}
        local skip_chance = 0.6
        called_count = called_count + 1
        for j, sp in ipairs(spread_list) do 
            local spinner = ps_rander(called_count + 9235 + j)
            if spinner > skip_chance then
                -- local noise = rander(-10, 10)
                -- local noise2 = rander(-3, 3)
                local noise = (ps_rander(called_count + 154 + j) - 0.5) * 2 * 5
                local noise2 = (ps_rander(called_count + 4629 + j) - 0.5) * 2 * 3
                -- local noise = math.sin(called_count + j * 2.1294) * 10
                -- local noise2 = math.cos(called_count + j * 0.2314) * 3
                local final_angle = -90 + sp + noise
                local clockwise = final_angle > -90

                local rot_vel
                if clockwise then
                    rot_vel = 1
                else
                    rot_vel = -1
                end

                local spawned_bullet = self.wave:spawnBullet("t02_inward_item/gravity_object", 
                cx, cy, final_angle, 7 + noise2, "bullets/pound_symbol", 0.15, (rot_vel)
                )
                -- spawned_bullet.damage = 20
                spawned_bullet:setScale(1.35, 1.35)
                spawned_bullet.remove_offscreen = true
            end
        end


        
    end
    ---@type MovableInstance
    local ctr_instance = {
        position = origin,
        duration = std_dur,
        interpolate = "in-quad",
        on_finish = on_bounce -- maybe change this
    }
    local gen_ctr_instance = function(dur) 
        return {
            position = origin,
            duration = dur,
            interpolate = "in-quad",
            on_finish = on_bounce -- maybe change this
        }
    end

    ---@type MovableInstance[]
    local keyframes = {
        {
            position = nil, -- GHOST do nothing
            duration = std_dur,
            interpolate = "linear",
            on_finish = nil
        },
        ctr_instance,
        {
            position = vadd(origin, vsmult(b, normalize({-1, -1}))),
            duration = std_dur,
            interpolate = "out-quad",
            on_finish = nil
        },
        ctr_instance,
        {
            position = vadd(origin, vsmult(b, normalize({1, -1}))),
            duration = std_dur,
            interpolate = "out-quad",
            on_finish = nil
        },
    }

    -- generate random values between 0.2 and 0.8, and that value * PI will be the angle
    -- angles here work the same way they are taught in hs
    -- the rest position is OUTSIDE, meaning the first entrance must
    -- be to the center
    local loops = 333
    ---@type number[]
    local random_list = {}
    for i = 1, loops do
        table.insert(random_list, rander(0, 1))
    end

    for i =  1, #random_list do
        local premult_angle = random_list[i]
        local angle = premult_angle * math.pi
        local progress = math.min(1, (i - 1)/(8))
        local intensity = b*(1-progress) + max_b*(progress)
        local final_duration = std_dur*(1-progress) + std_min_dur*(progress)

        local vec = {
            math.cos(angle),
            -math.sin(angle)  -- since y's coordinates are flipped
        }
        table.insert(keyframes, gen_ctr_instance(final_duration))
        table.insert(keyframes, {
            position = vadd(origin, vsmult(intensity, normalize(vec))),
            duration = final_duration,
            interpolate = "out-quad",
            on_finish = nil
        })
    end




    -- Now: actually commence these animations
    self.timer:script(function(wait) 
        local no_keyframes = #keyframes
        for i = 1, no_keyframes do
            local keyframe = keyframes[i]
            if keyframe.position then
                self.timer:tween(keyframe.duration, self, {
                    x = keyframe.position[1],
                    y = keyframe.position[2]
                }, keyframe.interpolate
                )
            end
            wait(keyframe.duration + 0.01)
            if keyframe.on_finish then
                keyframe.on_finish()
            end
        end
    end)
end

-- function BulletCard:update()
--     -- For more complicated bullet behaviours, code here gets called every update

--     super.update(self)
-- end

return BulletCard