local CurWave, super = Class(Wave)

function CurWave:init()
    super.init(self)
    -- how long the battle lasts in seconds
    self.time = 200
    self.timer = Timer()
    self:addChild(self.timer)
    --     self.arena_x = SCREEN_WIDTH/2 + x
    -- self.arena_y = (SCREEN_HEIGHT - 155)/2 + 10 + y
    self.arena_x = (SCREEN_WIDTH * 0.3)
    self.arena_y = (SCREEN_HEIGHT - 155) / 2 + 10
    self.arena_height = SCREEN_HEIGHT * 0.35
    self.arena_width = SCREEN_HEIGHT * 0.5

    self.bloon_count = 0
    self.abs = false
    self.too_early = true

    self.spawn_finish = false
    self.last_finish = false

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
    -- self:spawnBullet("BloonStatic", SCREEN_WIDTH*0.8, ay, "rainbow", 1)
    -- self:spawnBullet("BloonSeeker", SCREEN_WIDTH*0.8, ay-40, "ceramic", 10)
    
    ---@alias BloonWave {delay: number, bloon: string, count: number, spacing: number, center: number, spread: number}
    
    ---@type BloonWave[]
    local bloon_waves = {
        {
            delay = 0,
            bloon = 'red',
            count = 6,
            spacing = 0.15,
            center = 0.5,
            spread = 0.75
        },
        {
            delay = 1.4,
            bloon = 'blue',
            count = 10,
            spacing = 0.3,
            center = 0.5,
            spread = 0.9
        },
        {
            delay = 1.4,
            bloon = 'green',
            count = 5,
            spacing = 0.3,
            center = 0.5,
            spread = 0.9
        },
        {
            delay = 4,
            bloon = 'yellow',
            count = 4,
            spacing = 0.3,
            center = 0.5,
            spread = 0.9
        },
        {
            delay = 0.2,
            bloon = 'pink',
            count = 6,
            spacing = 0.3,
            center = 0.5,
            spread = 0.9
        },
        {
            delay = 6,
            bloon = 'black',
            count = 3,
            spacing = 0.3,
            center = 0.5,
            spread = 0.9
        },
        {
            delay = 0.2,
            bloon = 'white',
            count = 3,
            spacing = 0.3,
            center = 0.5,
            spread = 0.9
        },
        {
            delay = 7,
            bloon = 'zebra',
            count = 2,
            spacing = 0.6,
            center = 0.5,
            spread = 0.9
        },
        {
            delay = 7,
            bloon = 'rainbow',
            count = 2,
            spacing = 0.6,
            center = 0.5,
            spread = 0.9
        },
                {
            delay = 8,
            bloon = 'ceramic',
            count = 2,
            spacing = 1,
            center = 0.5,
            spread = 0.9
        },

    }

    ---@param ofst number
    ---@
    local function get_spawn_y_pos(ofst) 
        local lowest_pos = SCREEN_HEIGHT*0.7*0.2
        local highest_pos = SCREEN_HEIGHT*0.7*(1-0.2)

        return lowest_pos*(1-ofst)+(ofst)*highest_pos
    end

    self.timer:script(function (wait) 
        for i = 1, #bloon_waves do 
            local bw = bloon_waves[i]
            wait(bw.delay)
            self.timer:script(function (wait2) 
                for j = 1, bw.count do 
                    wait2(bw.spacing)
                    self:spawnBullet("BloonSeeker", SCREEN_WIDTH*1+20, get_spawn_y_pos(bw.center + rander(-0.5,0.5)*bw.spread), bw.bloon)
                end
                if i == #bloon_waves then 
                    self.last_finish = true
                end
            end)
        end
        self.spawn_finish = true
    end)



end

function CurWave:update()
    -- print(self.bloon_count)
    super.update(self)
    if self.spawn_finish and self.last_finish then
        if self.bloon_count == 0 then 
            self:setFinished()
        end
    end
end

return CurWave