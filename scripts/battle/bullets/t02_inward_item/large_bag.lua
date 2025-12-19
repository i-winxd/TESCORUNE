local LargeBag, super = Class(Bullet)


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
---@param dir number
---@param speed number
function LargeBag:init(x, y, dir, speed, texture)
    texture = texture or "bullets/conveyor_utils/tesco_bag"
    -- Last argument = sprite path
    super.init(self, x, y, texture)
    self.physics.direction = dir
    self.physics.speed = speed
    self.timer = Timer()
    self.destroy_on_hit = false
    self:addChild(self.timer)
    self.remove_offscreen = false
end

function LargeBag:onAdd(parent)
    -- filled, x, y, width, height, color
    local rectangular_object = RectObject(
        true,
        0, 0,
        2, 200,
        {1, 1, 1, 0.5}
    --    0, 0, 30, 100, {1, 1, 1, 0.5}
    )
    self.wave:spawnObjectTo(self, rectangular_object, 15, -185)


    local spawn_interval = 2
    local max_vel = 3.5
    local min_vel = 1
    local possible_objects = {
        "bullets/tesco_icons/air_frier",
        "bullets/tesco_icons/banana_icon_pixel",
        "bullets/tesco_icons/cereal_box",
        "bullets/tesco_icons/sandwich_icon",
        "bullets/tesco_icons/shopping_cart",
        "bullets/pound_symbol"
    }
    self.timer:every(spawn_interval, function() 
        self.wave:spawnBulletTo(self, "t02_inward_item/gravity_object", 17, 0, 270, 
            (rander(min_vel, max_vel)^1.2) + 0.5,
            possible_objects[rander(1, #possible_objects, 1)],
            0.1
        )
    end)
end

function LargeBag:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return LargeBag