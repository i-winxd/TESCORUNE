local BLT, super = Class(Bullet)


local base_scale = 0.2
local final_scale = 1
-- bullets/nek/nekta
-- bullets/nek/nekta1

local base_texture = "bullets/nek/nekta1"
local animated_texture = "bullets/nek/nekta"


-- t01_moving_solid
---@param path_obj any
function BLT:init(path_obj)
    local init_path = path_obj.path[1]
    ---@type number
    local cx = init_path[1]
    ---@type number
    local cy = init_path[2]
    self.path_obj = path_obj
    self.path_obj.on_finish = function() 
        self.moving = false
    end
    super.init(self, cx, cy, base_texture)
    -- the moving phase where it follows the path as stated
    self.path_speed = 0
    self.moving = false
    self.timer = Timer()
    self:addChild(self.timer)
    self.scale_x = base_scale
    self.scale_y = final_scale
    self.damaging = false
    local hitbox_scale = 0.85
    self.collider = Hitbox(self, self.width*(1-hitbox_scale)/2, 
                        self.height*(1-hitbox_scale)/2, 
                        self.width*hitbox_scale, 
                        self.height*hitbox_scale)    
    
    self.timer = Timer()
    self:addChild(self.timer)
    self.destroy_on_hit = false
end

local spawn_duration = 1

function BLT:beginMove()
    self.moving = true
    self:setSprite(animated_texture, (1/10), true)
end

function BLT:onAdd(parent)
    super.onAdd(self, parent)
    -- self.scale_x
    self.timer:tween(
        spawn_duration, self, {scale_x = final_scale, scale_y = final_scale}, 
        "out-elastic"
    )
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
function BLT:onCollide(soul)
    if self.damaging then
        super.onCollide(self, soul)
    else
        self.damaging = true
        self:triggerFling()
    end
end



function BLT:triggerFling()
    self.moving = false
    local fling_base = 0.4
    local fling_final = 0.15
    local max_flinger = 4
    self.damage = (self.attacker and self.attacker.attack * 2.5) or 10
    local prev_angle = 0
    self.timer:script(function(wait) 
        for i = 1, 7 do 
            local fling_progress = math.min(1, (i-1)/max_flinger)
            local fling_timer = (1-fling_progress)*fling_base + fling_progress*fling_final
            self.inv_timer = fling_timer
            local fx, fy, prev_angle_a = self:flingSoul(prev_angle)
            prev_angle = prev_angle_a
            self.timer:tween(math.max(0.01, fling_timer), self, {x=fx,y=fy}, "linear")
            wait(fling_timer)
        end
        self.wave:setFinished()
    end)
end



function BLT:flingSoul(prev)
    local max_entropy = 35
    local sx, sy = Game.battle.soul.x, Game.battle.soul.y
    local random_a = prev + rander(math.pi-0.4,math.pi+0.4)
    local bx, by = math.cos(random_a)*max_entropy, math.sin(random_a)*max_entropy
    return sx + bx, sy+ by, random_a
end

function BLT:update()
    if self.moving and self.path_speed > 0 then 
        local cx, cy = self.path_obj:step(DT, self.path_speed)
        if cx ~= nil and cy ~= nil then 
            self.x = cx
            self.y = cy
        end
    end
    super.update(self)
end

return BLT