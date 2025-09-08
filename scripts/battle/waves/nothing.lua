local StandardAttack, super = Class(Wave)

function StandardAttack:init()
    super.init(self)
    -- how long the battle lasts in seconds
    self.time = 7
    self.timer = Timer()
    self:addChild(self.timer)
end

function StandardAttack:onStart()
    -- Get the arena object
    local arena = Game.battle.arena
    local x = SCREEN_WIDTH / 2
    local y = SCREEN_HEIGHT / 2
    local arena_x = arena.x
    local arena_y = arena.y
end


function StandardAttack:update()
    super.update(self)
end

return StandardAttack