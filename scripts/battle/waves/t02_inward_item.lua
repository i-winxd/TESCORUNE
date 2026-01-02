local T02InwardItem, super = Class(Wave)


function T02InwardItem:init()
    super.init(self)  -- remember this!!!
    self.time = 15
    -- self.arena_x = (SCREEN_WIDTH * 0.4)
    -- self.arena_y = (SCREEN_HEIGHT - 155) / 2 + 10
    self.arena_height = SCREEN_HEIGHT * 0.35
    self.arena_width = SCREEN_WIDTH * 0.50
    self.arena_x = SCREEN_WIDTH * 0.5
    self.arena_y = SCREEN_HEIGHT * 0.7 * 0.5
    self.timer = Timer()
    self:addChild(self.timer)
end

function T02InwardItem:onEnd(death)
    super.onEnd(self,death)
end


function T02InwardItem:onStart()


    local ax, ay = Game.battle.arena:getCenter()
    local ah = Game.battle.arena.height
    local aw = Game.battle.arena.width
    local conveyor_path = "bullets/conveyor_utils/conveyor_sprites/conveyor"
    local spawn_these_many = 8
    local conveyor_width = 80
    local start_point = ax - math.floor(conveyor_width * (spawn_these_many / 2))
    local conveyor_basis = ay+(ah*0.80)
    for i = 1, spawn_these_many, 1 do
        local spawned_bullet = self:spawnBullet("t02_inward_item/animated_sprite", 
        start_point + (i-0.5)*conveyor_width, 
        conveyor_basis, 
        0, 0.25, conveyor_path)
    end
    self.timer:everyInstant(1, function() 
        self:spawnBullet("t02_inward_item/large_bag", start_point - 30, conveyor_basis - 40, 0, 2)
    end)
end

return T02InwardItem