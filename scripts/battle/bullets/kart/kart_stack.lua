local KartStack, super = Class(Bullet)

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


--- Computes bezier y for given xInput using custom control points
---@param xInput number must be between 0 to 1
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
local function bezierEase(xInput, x1, y1, x2, y2)
    local function cubicBezier(t, p0, p1, p2, p3)
        local u = 1 - t
        return u^3 * p0 + 3 * u^2 * t * p1 + 3 * u * t^2 * p2 + t^3 * p3
    end
    local epsilon = 1e-6
    local maxIter = 20
    local t0, t1 = 0, 1
    local t = 0.5


    for i = 1, maxIter do
        t = (t0 + t1) / 2
        local x = cubicBezier(t, 0, x1, x2, 1)
        if math.abs(x - xInput) < epsilon then
            break
        elseif x < xInput then
            t0 = t
        else
            t1 = t
        end
    end
    local y = cubicBezier(t, 0, y1, y2, 1)
    return y
end


---@param x number
---@param y number
function KartStack:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y)
    self:setScale(1, 1)
    self.kart_textures = {
        "bullets/tesco_icons/air_frier",
        "bullets/tesco_icons/banana_icon_pixel",
        "bullets/tesco_icons/cereal_box",
        "bullets/tesco_icons/sandwich_icon",
        "bullets/tesco_icons/shop_box",
    };
    self.destroy_on_hit = true
    self.elapsed = 0
    self.remove_offscreen = false
end

function KartStack:onAdd()
    local item_height = 28
    local no_items = 8

    -- select a random value between 2 and 5
    local rand = rander(3, 6, 1)
    local bomb_top = rander(0, 1, 1) == 1

    for i = 1, no_items, 1 do
        local item_height_offset = (i - 1) * item_height
        if i == rand then
            if bomb_top then
                local bag = self:spawnVulnKart(0, 0 - item_height_offset, "bullets/tesco_icons/bag_of_area")
                bag:setScale(1.4, 1.4)
            else
                self:spawnBomb(0, 0 - item_height_offset)
            end
        elseif i == (rand + 1) then
            if bomb_top then
                self:spawnBomb(0, 0 - item_height_offset)
            else
                local bag = self:spawnVulnKart(0, 0 - item_height_offset, "bullets/tesco_icons/bag_of_area")
                bag:setScale(1.4, 1.4)
            end
        else
            local texture = ""
            if i == 1 then
                texture = "bullets/tesco_icons/shopping_cart"
            else
                texture = self.kart_textures[rander(1, #self.kart_textures, 1)]
            end
            self:spawnBasicKart(0, 0 - item_height_offset, texture)
        end

    end
end

---@param x number
---@param y number
---@param texture string
function KartStack:spawnBasicKart(x, y, texture)
    return self.wave:spawnBulletTo(self, "kart/basic_kart", x, y, texture)
end

---@param x number
---@param y number
---@param texture string
function KartStack:spawnVulnKart(x, y, texture)
    return self.wave:spawnBulletTo(self, "kart/basic_kart_vuln", x, y, texture)
end

---@param x number
---@param y number
function KartStack:spawnBomb(x, y)
    return self.wave:spawnBulletTo(self, "mtt_bomb", x, y)
end

function KartStack:update()
    -- For more complicated bullet behaviours, code here gets called every update
    self.elapsed = self.elapsed + DT
    self.x = self:requiredXPos(self.elapsed)
    super.update(self)
end

---@param t number
function KartStack:requiredXPos(t)
    local max_time = 4
    local completion = math.max(0, math.min(t /max_time, max_time))
    local progression = bezierEase(completion, 0.2, 0.37, 0.8, 0.59)
    return SCREEN_WIDTH * (1 - (progression * 1.25))
end








return KartStack