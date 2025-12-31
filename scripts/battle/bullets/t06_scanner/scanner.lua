local THE_BULLET, super = Class(Bullet)

---@param x number Starting position
---@param y number Starting position. This decides the elevation of the scanner.
function THE_BULLET:init(x, y, movement_pattern)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/t06_scanner/scanner")
    self.remove_offscreen = false
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.draw_children_below = 0
    self:setScale(2, 2)
    self.movement_pattern = movement_pattern or {}
    self.timer = Timer()
    self.destory_on_hit = false

    self:addChild(self.timer)
end

local function ps_rander(n)
    local x = math.sin(n * 12.9898) * 43758.5453
    return x - math.floor(x)
end
---@return T06Position[]
function THE_BULLET:setup_positions()
    local arena_width = Game.battle.arena.width
    local arena_height = Game.battle.arena.height
    local ax, ay = Game.battle.arena:getCenter()
    ---@type T06Position[]
    local positions = {}
    local C = 35
    local init_x = self.x
    local init_y = self.y
    local base_duration = 0.8
    local fastest_duration = 0.5
    local fastest_at = 9
    local previous_rander_value = -99

    for i = 1, C do
        local progress = math.min(1, (i)/fastest_at)
        local rander_value = ps_rander(i)
        local radius = 0.17
        local prev = previous_rander_value
        local lower = math.max(0, prev - radius)
        local upper = math.min(1, prev + radius)
        if lower <= rander_value and rander_value <= upper then
            if rander_value - lower < upper - rander_value then
                rander_value = lower
            else
                rander_value = upper
            end
        end
        if i == 1 then
            rander_value = 0.85
        end
        previous_rander_value = rander_value
        table.insert(positions, {
            position = {(rander_value * arena_width) + (ax - arena_width/2), init_y},
            duration = base_duration*(1-progress) + fastest_duration*progress,
            interpolate = "out-cubic",
            facing = 90
        })
    end
    return positions
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
function THE_BULLET:onAdd(parent)
    local arena_width = Game.battle.arena.width
    local arena_height = Game.battle.arena.height
    local ax, ay = Game.battle.arena:getCenter()
    -- where facing is in degrees, offset, VISUALLY COUNTERCLOCKWISE UP
    ---@alias T06Position { position: number[]|nil, duration: number, interpolate: string, facing: number }
    ---@type T06Position[]
    local positions = self:setup_positions()
    local scan_gap = 0.24
    local scan_patience = 0.7
    
    self.timer:script(function(wait) 
        -- self.rotation
        local previous_scanner = nil
        for i, pos in ipairs(positions) do
            if not pos.position then
                -- do nothing
            else
                self.timer:tween(pos.duration, self,
                    {x = pos.position[1], y = pos.position[2],
                    rotation = math.rad(pos.facing-90)
                    },
                    pos.interpolate
                )
                wait(pos.duration + 0.01 + scan_gap * (pos.duration/0.8))
                -- self.wave:spawnBullet("t06_scanner/red_blip", )
                if previous_scanner ~= nil then
                    if previous_scanner.remove ~= nil then
                        previous_scanner:remove()
                    end
                end
                local scw = self:getScaledWidth()
                local sch = self:getScaledHeight()
                previous_scanner = self.wave:spawnBulletTo(self, "t06_scanner/red_blip", scw * 0.255, sch * 0.95)
                Assets.playSound("tesco/tesco_beep", 0.25, (2 ^ (math.floor((ps_rander(i+32195))*3)/12))  )
                wait(scan_patience * (pos.duration/0.8))
            end
        end
    end)
end




function THE_BULLET:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return THE_BULLET