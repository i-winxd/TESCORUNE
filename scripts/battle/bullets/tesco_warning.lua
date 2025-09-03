local TescoWarningBullet, super = Class(Bullet)

---@param x number
---@param y number
---@param rot number
function TescoWarningBullet:init(x, y, rot)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/tesco_outline")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    -- self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    -- self.physics.speed = speed
    self.destroy_on_hit = false
    self.scale_x = 1.4
    self.scale_y = 1.4
    self.rotation = rot
    self.timer = Timer()
    self:addChild(self.timer)
    local repeats = 2
    local times_repeated = 0
    self.timer:everyInstant(0.14, function() 
        self.timer:script(function(wait) 
            Assets.playSound("snd_mtt_prebomb", 0.7)
            self.alpha = 0.6
            wait(0.07)
            self.alpha = 0
            times_repeated = times_repeated + 1
            if times_repeated == 2 then
                self:remove()
            end
        end)
    end, repeats)

end

function TescoWarningBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return TescoWarningBullet
