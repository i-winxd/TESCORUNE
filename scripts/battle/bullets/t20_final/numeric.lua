local BLT, super = Class(Bullet)

-- a numeric is a class that represents a digit
-- and calls wave:onDigitPress(num) when successfully pressed.

local pressed_basename = "bullets/t20_blips/pressed/blip_numbers_pressedl"  -- +num from 1-19 w/ 10 as 0
local selected_basename = "bullets/t20_blips/sel/blip_numbers"
local unsel_basename = "bullets/t20_blips/unsel/blip_numbers_unsel"


local full_alpha = 0.95
local translucent_alpha = 0.5


---@alias Mode 'pressed'|'sel'|'unsel'

--- Returns the path to the texture corresponding with the following...
---@param num number
---@param mode Mode
---@param kanji boolean
local function get_texture(num, mode, kanji, selectable)
    if num == 0 then 
        num = 10
    end
    if kanji and num < 10 then 
        num = num + 10
    end
    local prefix = unsel_basename
    if selectable then
    if mode == 'pressed' then 
        prefix = pressed_basename
    elseif mode == 'sel' then
        prefix = selected_basename
    end
    end
    local path_to_sprite = prefix .. tostring(num)
    return path_to_sprite
end

local hitbox_scale = 0.80

local default_scale = 2

---@param x number
---@param y number
---@param number number
function BLT:init(x, y, number)
    self.alpha = full_alpha
    local current_texture = get_texture(number, "unsel", self.kanji, self.selectable)
    super.init(self, x, y, current_texture)
    self:setScale(default_scale,default_scale)
    self.timer = Timer()
    self:addChild(self.timer)
    self.number = number
    -- STATES (Do not set them directly, but you can read them)
    self.selectable = true  -- whether the button can be selected. if it can't be selected, make it extra translucent 
    self.pressed = false -- overrides hovering, set to true when being clicked on.
    self.hovering = false -- set to true when hovering.
    self.kanji = false -- when true and no other texture-changing state, display values as kanji
    self.can_graze = false
    self:setLayer(BATTLE_LAYERS["below_soul"])

    self.remove_offscreen = false
    self.collider = Hitbox(self, self.width*(1-hitbox_scale)/2, 
                        self.height*(1-hitbox_scale)/2, 
                        self.width*hitbox_scale, 
                        self.height*hitbox_scale)
    -- this one for intersecting with the others
    self.full_collider = Hitbox(self, 0, 0, self.width, self.height)
    self.collides_with_others = false
    self.alpha = full_alpha

end

--- Returns a list of other instances of itself
---@return any[]
function BLT:getOtherNumerics()
    local wave_buttons = self.wave.buttons
    if wave_buttons == nil then return {} end
    local wb2 = {}
    for i = 1, #wave_buttons do 
        if wb2.number ~= self.number then
            table.insert(wb2, wave_buttons[i])
        end
    end
    return wb2
end

function BLT:onAdd()
    self:recalculate_placement()
end

--- Sets the sprite to the correct...
function BLT:_reload_texture()
    local mode
    if self.pressed then 
        mode = "pressed"
    elseif self.hovering then
        mode = "sel"
    else
        mode = "unsel"
    end
    local obtained_texture = get_texture(self.number, mode, self.kanji, self.selectable)
    -- print("Setting sprite to "..obtained_texture)
    self:setSprite(obtained_texture)
    if self.selectable then 
        self.alpha = full_alpha
    else
        self.alpha = translucent_alpha
    end
end
-- WHEN THE NUMBER IS PRESSED.
function BLT:clicked()
    if self.selectable then 
        self.wave:number_pressed(self.number)
    end
end

--- Called on the current frame if at least one soul intersects the button.
function BLT:on_overlap()
    if Input.pressed("confirm", false) then 
        if not self.pressed then 
            self:set_pressed(true)
        end
    end
    if Input.released("confirm") and self.pressed then 
        -- print("I CLICKED "..self.number)
        self:clicked()
        self:set_pressed(false)
    end
end

--- Called on the current frame if all souls don't intersect the button.
function BLT:on_no_overlap()
    if Input.released("confirm") and self.pressed then 
        self:set_pressed(false)
    end
end

function BLT:recalculate_placement()
    local pressed_called = false
    if self.stage ~= nil then 
        for _, soul in ipairs(self.stage:getObjects(Soul)) do
            if self.collider:collidesWith(soul) then 
                if not pressed_called then 
                    self:on_overlap()
                end           
                pressed_called = true
                
                if not self.hovering then
                    self:set_hovering(true)
                    -- print("HOVERING")
                end
            else
                if self.hovering then
                    self:set_hovering(false)
                    -- print("NOT HOVERING")
                end
            end
        end
        if not pressed_called then 
            self:on_no_overlap()
        end
    end
end

local size_amp = 1.2

-- this just makes it easier because I don't want to couple it too much
---@alias CollisionInfo {x: number, y: number, radius: number}

function BLT:handle_collision_with_other(other)
    local sx, sy = self.x, self.y
    local s_half = self.width * size_amp / 2
    local ox, oy = other.x, other.y
    local o_half = other.width * size_amp / 2

    local dx = sx - ox
    local dy = sy - oy
    local overlap_x = s_half + o_half - math.abs(dx)
    local overlap_y = s_half + o_half - math.abs(dy)

    -- Check for collision
    if overlap_x > 0 and overlap_y > 0 then
        -- Reflect directions along the axis of least penetration
        if overlap_x < overlap_y then
            -- Horizontal collision
            self.physics.direction = math.pi - self.physics.direction
            other.physics.direction = math.pi - other.physics.direction

            -- Resolve overlap
            if dx > 0 then
                self.x = self.x + overlap_x / 2
                other.x = other.x - overlap_x / 2
            else
                self.x = self.x - overlap_x / 2
                other.x = other.x + overlap_x / 2
            end
        else
            -- Vertical collision
            self.physics.direction = -self.physics.direction
            other.physics.direction = -other.physics.direction

            -- Resolve overlap
            if dy > 0 then
                self.y = self.y + overlap_y / 2
                other.y = other.y - overlap_y / 2
            else
                self.y = self.y - overlap_y / 2
                other.y = other.y + overlap_y / 2
            end
        end
    end
end

function BLT:handle_wall_collisions()
    -- HANDLE WALL COLLISIONS
    local radius = self.width / 2
    if self.x - radius < 0 then 
        self.x = radius
        self.physics.direction = math.pi - self.physics.direction
    end
    if self.x + radius > SCREEN_WIDTH then 
        self.x = SCREEN_WIDTH - radius
        self.physics.direction = math.pi - self.physics.direction
    end
    if self.y - radius < 0 then 
        self.y = radius
        self.physics.direction = -self.physics.direction
    end
    if self.y + radius > SCREEN_HEIGHT then 
        self.y = SCREEN_HEIGHT - radius
        self.physics.direction = -self.physics.direction
    end

    -- HANDLE COLLISIONS WITH OTHER
end

function BLT:update()
    -- For more complicated bullet behaviours, code here gets called every update
    self:recalculate_placement()
    super.update(self) 
    if self.physics.speed >= 0.02 and self.collides_with_others then 
        self:handle_wall_collisions()
        local other_numerics = self:getOtherNumerics()
        for i = 1, #other_numerics do 
            local other = other_numerics[i]
            self:handle_collision_with_other(other)
        end
    end
end


function BLT:_on_selectable_change()
    self:_reload_texture()
end

function BLT:set_selectable(cond)
    self.selectable = cond
    self:_on_selectable_change()
end
function BLT:set_pressed(cond)
    self.pressed = cond
    self:_on_selectable_change()
end
function BLT:set_hovering(cond)
    self.hovering = cond
    self:_on_selectable_change()
end
function BLT:set_kanji(cond)
    self.kanji = cond
    self:_on_selectable_change()
end


function BLT:onAdd()

end

function BLT:onCollide(soul)
    -- do nothing since this texture is intangible
end


return BLT