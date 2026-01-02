local CURWAVE, super = Class(Wave)

function CURWAVE:init()
    super.init(self)

    -- Initialize timer
    -- self.siner = 0
    
    -- how long the battle lasts in seconds
    self.arena_y = (SCREEN_HEIGHT*0.7*0.375)
    self.arena_width = (SCREEN_WIDTH * 0.35)
    self.time = 20

end

function CURWAVE:onEnd(death)
    super.onEnd(self, death)
end

function CURWAVE:onStart()


    -- Get the arena object
    local arena = Game.battle.arena

    -- local bullet = self:spawnBullet("tesco", arena_x + bullet_reach_factor * arena.width, arena_y,
        -- self)
    local ax, ay = Game.battle.arena:getCenter()
    local card_holder = self:spawnBullet("t05_card/card_platform",
    ax + (SCREEN_WIDTH/4), 
    ay + (SCREEN_HEIGHT*0.7*0.5*0.9))


end

function CURWAVE:update()
    super.update(self)
end

return CURWAVE