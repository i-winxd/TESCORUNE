local MttBombPath, super = Class(YellowSoulBullet)

--- see: PATHER
---     local path_object = {
---        path = table_copy(path),
---        current_index=1,  -- I'm here
---        current_progress=0,  -- from 0 to 1
---        x=path[1][1],
---        y=path[1][2],
---        velocity=velocity, -- pixels to move a second
---        on_finish=on_finish,
---        finish_called = false
---    }
--- restart()
--- step(dt) -- dt: number
--- 
--- NOTE: the on_destroy is not to be set in the argument.
--- I set it here. on_destory is a STATIC method.
function MttBombPath:init(path_obj, vel, ondestroy)
    local init_path = path_obj.path[1]
    -- print("PATH OBJECT LENGTH: ", #path_obj)
    local cx = init_path[1]
    local cy = init_path[2]
    self.path_obj = path_obj
    self.painful = false
    self.path_obj.on_finish = function() 
        self.painful = true
        self:destroy() -- while obvious to many, using the : means auto one argument
    end

    -- super.init(self, cx, cy)
    super.init(self, cx, cy, "bullets/spr_mettaton_bomb1/spr_mettaton_bomb1_0")
    self:setScale(1, 1)
    self.destroy_on_hit = false
    self.remove_offscreen = false
    self.bomb_vel = vel or 10
    self.vv_on_destroy = ondestroy

    


end

function MttBombPath:update()
    if not self.path_obj.finish_called then
        local cx, cy = self.path_obj:step(DT, self.bomb_vel)
        if cx ~= nil and cy ~= nil then 
            self.x = cx
            self.y = cy
        end
            
    end

    super.update(self)
end

function MttBombPath:destroy()
    if self.vv_on_destroy ~= nil then
        self.vv_on_destroy()
    end
    self:spawnExploder()
    super.destroy(self)
end

function MttBombPath:spawnExploder()
    local rx, ry = self:localToScreenPos(self.width / 2 + (0), self.height / 2 + (0))
    local iframes
    if self.painful then
        iframes = 2/3
    else
        iframes = (4/3)
    end
    self.wave:spawnBullet("mtt_bomb/mtt_bomb_kaboom", rx, ry, 0, iframes)
end

return MttBombPath
