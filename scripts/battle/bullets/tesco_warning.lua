local TescoWarningBullet, super = Class(Bullet)

---@param x number
---@param y number
---@param rot number
---@param beep_pitch_table table[number] how many beeps shall be done and the pitch for these beeps  
function TescoWarningBullet:init(x, y, rot, beep_pitch_table, held_length)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/tesco_outline")
    self.held_length = held_length or 0.07
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    -- self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    -- self.physics.speed = speed
    self.bpt = beep_pitch_table or {0, 0}
    self.destroy_on_hit = false
    self.scale_x = 1.4
    self.scale_y = 1.4
    self.rotation = rot
    self.timer = Timer()
    self:addChild(self.timer)
end

function TescoWarningBullet:onAdd(parent)
    local repeats = #(self.bpt)
    local times_repeated = 0
    self.timer:everyInstant(self.held_length * 2, function() 
        self.timer:script(function(wait) 
            local cur_pitch = self.bpt[times_repeated + 1]
            if cur_pitch ~= nil then 
                Assets.playSound("snd_mtt_prebomb", 0.7, (2 ^ (cur_pitch/12)))
            end
            self.alpha = 0.6
            wait(self.held_length)
            self.alpha = 0
            times_repeated = times_repeated + 1
            if times_repeated >= (#(self.bpt)) then
                self:remove()
            end
        end)
    end, repeats)
end

function TescoWarningBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

function TescoWarningBullet:onCollide()
    -- this bullet is always intangible
end

return TescoWarningBullet
