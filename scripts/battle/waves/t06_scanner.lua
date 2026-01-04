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
    self.arena_y = (SCREEN_HEIGHT*0.7*0.675)
    self.arena_width = (SCREEN_WIDTH * 0.50)
    self.arena_height = (SCREEN_WIDTH * 0.7 * 0.2)
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
function CURWAVE:onStart()

    -- Get the arena object
    local arena = Game.battle.arena
    local ax, ay = Game.battle.arena:getCenter()
    local ah = Game.battle.arena.height
    local aw = Game.battle.arena.width
    self:spawnBullet("t06_scanner/scanner", ax, ay-(ah/2) - 60)
    -- t02_inward_item/gravity_object
    local icon_textures = {
        "bullets/tesco_icons/air_frier",
        "bullets/tesco_icons/banana_icon_pixel",
        "bullets/tesco_icons/cereal_box",
        "bullets/tesco_icons/sandwich_icon",
        "bullets/tesco_icons/shop_box",
        "bullets/tesco_icons/roundel",
        "bullets/tesco_icons/fries",
        "bullets/tesco_icons/tesco_beer",
    }

    local rain_interval = 0.3
    local rain_bullets_here = 10
    local bullets_spawned = 1
    self.timer:every(rain_interval, function()
        bullets_spawned = bullets_spawned + 1
        local chosen_texture = icon_textures[math.min(#icon_textures, 1+math.floor(ps_rander(bullets_spawned) * (#icon_textures)))]
        local bullet_spawned = self:spawnBullet("t02_inward_item/gravity_object", 
        (ax-aw/2)+ps_rander(bullets_spawned + 344592 + rander(0, 5, 1))*aw, -10, 90, 4, chosen_texture, 0.05, 0)
        bullet_spawned:setScale(2, 2)
        bullet_spawned.remove_offscreen = false -- memory leak time!
    end)




end

function CURWAVE:update()
    super.update(self)
end

return CURWAVE