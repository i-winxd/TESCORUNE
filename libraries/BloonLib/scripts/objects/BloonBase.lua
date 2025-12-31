-- the name of the thing is the FILE NAME not the
-- name of the instance

local BloonBase, super = Class(Bullet, "BloonBase")

local snd_mult = 1.3

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

local children_map = {
    red = {},
    blue = {'red'},
    green = {'blue'},
    yellow = {'green'},
    pink = {'yellow'},
    black = {'pink', 'pink'},
    white = {'pink', 'pink'},
    purple = {'pink', 'pink'},
    lead = {'black', 'black'},
    zebra = {'black', 'white'},
    rainbow = {'zebra', 'zebra'},
    ceramic = {'rainbow', 'rainbow'},
    moab = {'ceramic','ceramic','ceramic','ceramic'},
    bfb = {'moab','moab','moab','moab'},
    zomg = {'bfb','bfb','bfb','bfb'},
    ddt = {'ceramic','ceramic','ceramic','ceramic','ceramic','ceramic'},
    bad = {'zomg','zomg','zomg','ddt','ddt'}
}

local speed_mult = 3.2

local bloon_speed = {
    red = 1,
    blue = 1.4,
    green = 1.8,
    yellow = 3.2,
    pink = 3.5,
    black = 1.8,
    white = 2,
    purple = 3,
    lead = 1,
    zebra = 1.8,
    rainbow = 2.2,
    ceramic = 2.5,
    moab = 1,
    bfb = 0.25,
    zomg = 0.18,
    ddt = 2.64,
    bad = 0.18
}

local bloon_hp = {
    ceramic = 10,
    moab = 200,
    bfb = 700,
    zomg = 4000,
    ddt = 400,
    bad = 20000
}
---@param b_type string
---@return number
local function get_bloon_hp(b_type)
    local b_retrieve = bloon_hp[b_type]
    return b_retrieve or 1
end

local function get_bloon_speed(b_type)
    return (bloon_speed[b_type] or 1) * speed_mult
end


---@alias StoredBloon {type: string, health: number}

--- Determine any new bloons that should be spawned when this
--- bloon takes some damage. Note that this bloon
--- is unmodified, and damage to itself, including its removal,
--- shall be handled elsewhere.
---@param cur_bloon StoredBloon
---@param damage number
---@return StoredBloon[]
local function decide_spawns_local(cur_bloon, damage)
    local cur_hp = cur_bloon.health
    local damage_dealt = math.min(cur_hp, damage)
    local remaining_damage = damage - damage_dealt
    if damage_dealt < cur_hp then
        print("Wouldn't have broken")
        return {}
    end

    local children_types = (children_map[cur_bloon.type]) or {}
    if #children_types == 0 then
        print("Not in the children map")
        return {}
    end
    ---@type StoredBloon[]
    local surviving_bloons = {}
    for i = 1, #children_types do 
        local child_type = children_types[i]
        ---@type StoredBloon
        local new_child = {type = child_type, health = get_bloon_hp(child_type)}
        if remaining_damage >= 1 then 
            local children_result = decide_spawns_local(new_child, remaining_damage)
            for j = 1, #children_result do 
                table.insert(surviving_bloons, children_result[j])
            end
        else
            table.insert(surviving_bloons, new_child)
        end
    end
    return surviving_bloons
end



local spawn_entropy = 40
-- if the bloon survives, nothing happens

--- Immediately spawn bloons here as if self took damage.
--- @param damage number
--- @param bullet_id string new spawns are immune to this bullet id
function BloonBase:make_spawns(damage, bullet_id)
    local cx, cy = self.x, self.y
    ---@type StoredBloon
    local bloon_instance = {type = self.bloon_type, health = self.shot_health}
    local spawns = decide_spawns_local(bloon_instance, damage)

    -- local CLS, SuperClass = CLASS_NAME_GETTER(classOfSelf)
    -- print("This class is")
    -- print(CLS)
    
    local objp = self.object_path

    for i = 1, #spawns do 

        local new_spawn = spawns[i]

        local ex, ey = rander(-spawn_entropy/2, spawn_entropy/2), rander(-spawn_entropy/4, spawn_entropy/4)
        -- local new_instance = BloonStatic(cx+ex, cy+ey, new_spawn.type, new_spawn.health)
        -- self.wave:spawnBullet(new_instance)
        -- print("Spawning RIGHT NOW " .. objp .. " - " .. new_spawn.type)
        
        local new_bloon = self.wave:spawnBullet(objp, cx+ex, cy+ey, new_spawn.type, new_spawn.health)
        new_bloon.immune_to = bullet_id or "bruh_sfx_2"
    end
end

local bloon_file_prefix = "battle/bullets/bloons/"
---@param st string
---@return string
local function px(st)
    return bloon_file_prefix .. st
end
local texture_files = {
    red = px("red"),
    blue = px("blue"),
    green = px("green"),
    yellow = px("yellow"),
    pink = px("pink"),
    black = px("black"),
    white = px("white"),
    purple = px("purple"),
    lead = px("lead"),
    zebra = px("zebra"),
    rainbow = px("rainbow"),
    ceramic = px("ceramic_A"),
    moab = "",
    bfb = "",
    zomg = "",
    ddt = "",
    bad = ""
}

local ceramic_hp_stages = {
    px("ceramic_A"),
    px("ceramic_B"),
    px("ceramic_C"),
    px("ceramic_D"),
    px("ceramic_E"),
}

---@param cur_hp number
---@param max_hp number
---@return string
local function get_ceramic_texture(cur_hp, max_hp)
    local hp_percent = 1 - math.max(0.0, math.min(1.0, cur_hp / max_hp))
    local phase = math.floor(hp_percent * (#ceramic_hp_stages)) + 1
    return ceramic_hp_stages[math.max(1, math.min(#ceramic_hp_stages, phase))]
end


function BloonBase:getSpeed()
    return get_bloon_speed(self.bloon_type)
end
function BloonBase:is_ceramic_or_moab()
    return self.bloon_type == 'ceramic' or self.bloon_type == 'ceramic' or self.bloon_type == 'moab' or self.bloon_type == 'bfb' or self.bloon_type == 'zomg' or self.bloon_type == 'ddt' or self.bloon_type == 'bad'
end

function BloonBase:init(x, y, bloon_type, health)
    self.time_bonus = 0
    self.tp = 0.1
    self.grazed = true
    
    if bloon_type == "red" or bloon_type == "blue" or bloon_type == "green" or bloon_type == "yellow" or bloon_type == "pink" then 
        self.can_graze = false
    end

    self.immune_to = "blegh"
    self.object_path = self.object_path or "BloonStatic"
    local texture = texture_files[bloon_type] or ""
    self.bloon_type = bloon_type
    super.init(self, x, y, texture)
    self.shot_health = health or get_bloon_hp(bloon_type)
    self.shot_tp = 0
    
    self.remove_offscreen = false
    self:setCeramicTexture()
    -- self.timer = Timer()
    -- self:addChild(self.timer)
    -- self.intangible = true
end

function BloonBase:setCeramicTexture()
    local ceramic_max = bloon_hp.ceramic
    if self.bloon_type ~= "ceramic" then
        return
    end
    local c_texture = get_ceramic_texture(self.shot_health, ceramic_max)
    self:setSprite(c_texture, 0.25, true)

end

function BloonBase:onAdd(...)
    -- print("ADDING BLOON")
    if self.wave.bloon_count ~= nil then
        self.wave.bloon_count = self.wave.bloon_count + 1
    end
    super.onAdd(self, ...)
end

local pop_textures = {"battle/bullets/bloons_popped/bloons_popped1",
        "battle/bullets/bloons_popped/bloons_popped2",
        "battle/bullets/bloons_popped/bloons_popped3"
    }

--- Run this whenever the bullet health hits 0.
--- Plays a sound by default. Super call is
--- not needed.
function BloonBase:onDeplete()
    Game:giveTension(self.shot_tp)
    local pit = rander(-3, 3, 0.25)
    
    local sfx
    local vol
    if self.bloon_type == 'ceramic' then
        sfx = "ceramic_broken"
        vol = 1*snd_mult
    else
        sfx = "bloon_pop"
        vol = 0.34*snd_mult
    end
    vol = vol * rander(0.85, 1)
    self.wave:spawnBullet("intangible_texture", self.x, self.y, 2, 0.15, pop_textures[rander(1,#pop_textures,1)])
    Assets.playSound(sfx, vol, 2^(pit/12))
end

function BloonBase:playDamageSound()
    local damage_sound = ""
    local vol = 0.25*snd_mult
    local pit = rander(-3, 3, 0.25)
    if self.bloon_type == 'ceramic' then 
        damage_sound = "ceramic_hit"
        vol = 0.2*snd_mult
    end
    if damage_sound ~= "" then 
        Assets.playSound(damage_sound, vol * rander(0.85, 1), 2^(pit/12))
    end
end

function BloonBase:onYellowShot(damage, bullet_id)
    local damage_reduction_quotient = rander(1.2, 3)
    if bullet_id == self.immune_to then
        return "a", false
    end
    self.immune_to = bullet_id
    -- Kristal.Console:log(string.format("Ouch damage was %d", damage))
    if not self:is_ceramic_or_moab() then
        -- print("Damage is" .. damage)
        damage = math.max(math.floor(damage/damage_reduction_quotient), 1)
        -- damage = 1
        -- if the current layer is a ceramic, 
    else
        if self.bloon_type == 'ceramic' then
            if damage > self.shot_health then
                local overflow_damage = damage - self.shot_health
                local actual_overflow_damage = math.max(math.floor(overflow_damage/damage_reduction_quotient), 0)
                damage = self.shot_health + actual_overflow_damage
            end
        end
    end
    self:make_spawns(damage, bullet_id)
    self.shot_health = self.shot_health - (damage)
    if self.shot_health <= 0 then
        self:onDeplete()
        self.destroy(self)
    else
        self:playDamageSound()
    end
    self:setCeramicTexture()
    return "a", false
end

function BloonBase:remove()
    if self.wave.bloon_count ~= nil then
        self.wave.bloon_count = self.wave.bloon_count - 1
    end
    super.remove(self)
end

function BloonBase:destroy()
    -- super.remove(self)
    self:remove()
end

return BloonBase