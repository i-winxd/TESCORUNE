local CurWave, super = Class(Wave)

function CurWave:init()
    super.init(self)
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
function CurWave:onStart()
    local arena = Game.battle.arena
    local ax, ay = Game.battle.arena:getCenter()
    local ah = Game.battle.arena.height
    local aw = Game.battle.arena.width
    



end

function CurWave:update()

end

return CurWave