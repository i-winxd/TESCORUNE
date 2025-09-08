-- the name of the thing is the FILE NAME not the
-- name of the instance

local YellowSoulAbsorber, super = Class(Bullet, "YellowSoulAbsorber")


function YellowSoulAbsorber:onYellowShot(damage)
    return true, false
end

-- function ShotBullet:onYellowShot(damage)
--     self.shot_health = self.shot_health - damage
--     if self.shot_health <= 0 then
--         super.destroy(self)
--     end
--     return "a", false
-- end

function YellowSoulAbsorber:destroy()
    super.remove(self)
end

return YellowSoulAbsorber