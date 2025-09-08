-- the name of the thing is the FILE NAME not the
-- name of the instance

local ShotBullet, super = Class(Bullet, "YellowSoulBullet")

function ShotBullet:init(x, y, texture)
    super.init(self, x, y, texture)
    self.shot_health = 1
    self.shot_tp = 1
end

--- Run this whenever the bullet health hits 0.
--- Plays a sound by default. Super call is
--- not needed.
function ShotBullet:onDeplete()
    Game:giveTension(self.shot_tp)
    Assets.playSound("bullet_destroyed", 0.4)
end

function ShotBullet:onYellowShot(damage)
    -- Kristal.Console:log(string.format("Ouch damage was %d", damage))
    self.shot_health = self.shot_health - (damage)
    if self.shot_health <= 0 then
        self:onDeplete()
        self.destroy(self)
    end
    return "a", false
end

-- function ShotBullet:onYellowShot(damage)
--     self.shot_health = self.shot_health - damage
--     if self.shot_health <= 0 then
--         super.destroy(self)
--     end
--     return "a", false
-- end

function ShotBullet:destroy()
    super.remove(self)
end

return ShotBullet