local TescoBagPath, super = Class(YellowSoulBullet)


function TescoBagPath:init(path_obj, vel, ondestroy)

    local init_path = path_obj.path[1]
    -- print("PATH OBJECT LENGTH: ", #path_obj)
    local cx = init_path[1]
    local cy = init_path[2]
    self.path_obj = path_obj
    self.path_obj.on_finish = function() 
        self:destroy() -- while obvious to many, using the : means auto one argument
    end

    -- super.init(self, cx, cy)
    super.init(self, cx, cy,"bullets/tesco_icons/bag_of_area")
    -- self:setScale(1, 1)
    self.destroy_on_hit = false
    self.remove_offscreen = false
    self.bomb_vel = vel or 10
    self.vv_on_destroy = ondestroy

end

function TescoBagPath:destroy()
    if self.vv_on_destroy ~= nil then
        self.vv_on_destroy()
    end
    -- self:spawnExploder()
    super.destroy(self)
end

function TescoBagPath:update()
    if not self.path_obj.finish_called then
        local cx, cy = self.path_obj:step(DT, self.bomb_vel)
        if cx ~= nil and cy ~= nil then 
            self.x = cx
            self.y = cy
        end
            
    end

    super.update(self)
end

return TescoBagPath