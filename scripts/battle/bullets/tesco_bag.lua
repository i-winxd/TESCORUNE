local TescoBag, super = Class(YellowSoulBullet)



-- function TescoBag:onYellowShot(damage)
--     self.shot_health = self.shot_health - (damage or 1)
--     if self.shot_health <= 0 then
--         self.destroy(self)
--     end
--     return "a", false
-- end

-- function TescoBag:destroy()
--     Game:giveTension(self.shot_tp or 0)
--     super.remove(self)
-- end


-- function TescoBag:onYellowShot(shot, damage)
--     self:destroy(shot)
--     return "a", false
-- end

-- this bag spawns at (x0, y0)
-- and moves to (x1, y1)
-- then spawns a mini pound symbol that faces
-- the direction to the player
-- then returns back to the origin
---@param x0 number bag spawns here
---@param y0 number
---@param x1 number bag goes to here to fire
---@param y1 number
---@param x2 number bag leaves away to here
---@param y2 number bag leaves away to here
---@param d1 number how long it takes for the bag to enter
---@param d2 number (nonnegative) fire this no. of seconds early prior to bag arriving
---@param d3 number how long it takes for the bag to leave
function TescoBag:init(x0, y0, x1, y1, x2, y2, d1, d2, d3)
    -- Last argument = sprite path
    super.init(self, x0, y0, "bullets/tesco_icons/bag_of_area")
    self.shot_health = 1
    self.shot_tp = 0.2
    self.remove_offscreen = false
    self.timer = Timer()
    self:addChild(self.timer)
    self.destroy_on_hit = false

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    -- self.physics.direction = dir
    -- -- Speed the bullet moves (pixels per frame at 30FPS)
    -- self.physics.speed = speed
    self.x1 = x1
    self.y1 = y1
    self.x2 = x2
    self.y2 = y2
    self.d1 = (d1 or 1)
    self.d2 = (d2 or 0)
    self.d3 = (d3 or 1)
end

function TescoBag:onAdd()
    local in_time = self.d1
    local out_time = self.d3

    self.timer:script(function (wait) 
        self.timer:tween(in_time, self, {x = self.x1, y = self.y1}, "out-quint")
        wait(math.max(in_time - self.d2, 0))
        -- spawn bullet that faces the soul

        local me_x, me_y = self:getRelativePos(self.width / 2, self.height / 2)
        local angle_diff = Utils.angle(me_x, me_y, Game.battle.soul.x, Game.battle.soul.y)
        self.wave:spawnBullet("small_pound", me_x, me_y, angle_diff, 7)
        -- if self.d2 > 0 then
        --     wait(self.d2)
        -- end
        wait(math.max(self.d2, 0))
        self.timer:tween(out_time, self, {x = self.x2, y = self.y2}, "in-quint",
        function ()
            self:destroy()
        end
        )
    end
    )
end

function TescoBag:update()
    -- For more complicated bullet behaviours, code here gets called every update
    super.update(self)
end

return TescoBag