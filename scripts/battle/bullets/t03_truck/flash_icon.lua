local FlashIcon, super = Class(Bullet)

-- t03_truck/flash_icon / x, y,dir,speed,texture,beep_pitch_table,held_length(0.10)

---@param x number
---@param y number
---@param dir number
---@param speed number
function FlashIcon:init(x, y, dir, speed, texture, beep_pitch_table, held_length, beep_interval)
    -- Last argument = sprite path
    super.init(self, x, y, texture)
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.remove_offscreen = false

    self.bpt = beep_pitch_table or {0, 0}
    self.destroy_on_hit = false
    self.ticking_alpha = 1
    self.beep_interval = beep_interval or 0.14
    self.held_length = held_length or 0.07
    self.timer = Timer()
    self:addChild(self.timer)

end

function FlashIcon:onAdd(parent)
    local repeats = #(self.bpt)
    local times_repeated = 0
    self.timer:everyInstant(self.beep_interval, function() 
        self.timer:script(function(wait) 
            local cur_pitch = self.bpt[times_repeated + 1]
            Assets.playSound("snd_mtt_prebomb", 0.5, (2 ^ (cur_pitch/12)))
            self.alpha = self.ticking_alpha
            wait(self.held_length)
            self.alpha = 0
            times_repeated = times_repeated + 1
            if times_repeated >= (#(self.bpt)) then
                self:remove()
            end
        end)
    end, repeats)
end


return FlashIcon