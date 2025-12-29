local MttBombKaboom, super = Class(Bullet)

---@param x number
---@param y number
function MttBombKaboom:init(x, y, x_mov, iframes)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/spr_mettaton_bomb1/spr_mettaton_bomb1_0")
    self:setScale(1, 1)
    self.timer = Timer()
    self:addChild(self.timer)
    self:setScale(1, 1)
    self.destroy_on_hit = false
    self.remove_offscreen = false
    if x_mov ~= nil then
        self.x_mov = x_mov
    else
        self.x_mov = 15
    end
    self.explosion_iframes = iframes or (4/3)

end

function MttBombKaboom:onAdd()
    local regular_sprite = "bullets/spr_mettaton_bomb1/spr_mettaton_bomb1_0"
    local inverted_sprite = "bullets/spr_mettaton_bomb1/spr_mettaton_bomb1_1"
    local frame_time = 0.04
    self.timer:tween(1, self, {x = (self.x + self.x_mov)}, "out-quint")
    self.timer:script(function (wait) 
        wait(frame_time)
        for i = 1, 2, 1 do
            Assets.playSound("snd_mtt_prebomb", 0.8)
            self:setSprite(inverted_sprite)
            wait(frame_time)
            self:setSprite(regular_sprite)
            wait(frame_time)
        end
        wait(frame_time * 2)
        self:spawnExploder()
        super.remove(self)
    end)
end

function MttBombKaboom:spawnExploder()
    local rx, ry = self:getRelativePos(self.width / 2 + (0), self.height / 2 + (0))
    self.wave:spawnBullet("mtt_bomb/mtt_bomb_impact", rx, ry, self.explosion_iframes)
end

function MttBombKaboom:update()
    -- For more complicated bullet behaviours, code here gets called every update
    super.update(self)
end

return MttBombKaboom