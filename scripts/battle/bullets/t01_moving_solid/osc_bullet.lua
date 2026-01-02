-- A bullet that oscillates between two points.


local BasicBullet, super = Class(Bullet)

function BasicBullet:init(x1, y1, x2, y2, period, texture)
    super.init(self, x1, y1, texture)
    self.remove_offscreen = false
    self.siner = 0
    self.period = period
    self.x1 = x1
    self.y1 = y1
    self.x2 = x2
    self.y2 = y2
    self.frozen = false
    self.speed_mult = 1
    self.destroy_on_hit = false
    self.tp = 0.01
    self.intangible = false
end

function BasicBullet:freeze()
    self.frozen = true
end
function BasicBullet:unFreeze()
    self.frozen = false
end
function BasicBullet:setOscSpeed(val)
    self.speed_mult = val
end
function BasicBullet:onCollide(soul)
    if not self.intangible then 
        super.onCollide(self, soul)
    end
end

function BasicBullet:onCollide(soul)
    if not self.frozen then 
        super.onCollide(self,soul)
    end
end

function BasicBullet:update()
    if not self.frozen then
        self.siner = self.siner + (DT * self.speed_mult)
        local p = (-math.cos(self.siner*math.pi*2/self.period)+1)/2
        self.x = self.x1*(1-p) + self.x2*p
        self.y = self.y1*(1-p) + self.y2*p
    end
    super.update(self)
end

return BasicBullet