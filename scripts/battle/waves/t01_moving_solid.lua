local T01MovingSolid, super = Class(Wave)

--- Spawns a solid object that collides with the soul.
--- Undefined behavior if the soul gets squished. idk
--- otherwise. Returns the solid instance.
--- @param x number
--- @param y number
--- @param w number
--- @param h number
--- @return Solid
function T01MovingSolid:spawn_solid(x, y, w, h)
    local sol = SolidEX(true, x, y, w, h)
    self:spawnObject(sol)
    return sol
end

-- The soul moves once per second.
function T01MovingSolid:init()
    super.init(self)  -- remember this!!!
    self.time = 20
    -- self.arena_x = (SCREEN_WIDTH * 0.4)
    -- self.arena_y = (SCREEN_HEIGHT - 155) / 2 + 10
    self.arena_height = SCREEN_HEIGHT * 0.50
    self.arena_width = SCREEN_WIDTH * 0.70
    self.arena_x = SCREEN_WIDTH * 0.5
    self.arena_y = SCREEN_HEIGHT * 0.7 * 0.5
    
    -- Game.battle.arena:setSize(600, 600)

    local fpw = self:fencePointToWorld({0.5, 0.5}, 6, 4)
    self.soul_start_x = fpw[1]
    self.soul_start_y = fpw[2]

end

function T01MovingSolid:onEnd(death)
    if not death and self._original_soul then
        Game.battle:swapSoul(self._original_soul)
        self._original_soul = nil
    end
    
end

function T01MovingSolid:onStart()
    self._original_soul = Game.battle.soul
    local standard_soul = Soul()
    Game.battle:swapSoul(standard_soul)
    
    local fences = {
        {{1,0},{1,3}},
        {{2,0},{2,1}},
        {{2,2},{2,4}},
        {{3,1},{3,2}},
        {{2,2},{3,2}},
        {{3,1},{4,1}},
        {{3,3},{4,3}},
        {{4,2},{4,3}},
        {{4,2},{6,2}}
    }
    self:spawnWalls(fences, 6, 4)
end

--- NOTE: ARENA MUST BE SET or I'm going to scream
function T01MovingSolid:fencePointToWorld(point, grid_width, grid_height)
    local aw
    local ah
    local ac
    local arena = Game.battle.arena
    if arena ~= nil then
        aw = arena.width
        ah = arena.height
        local ap1, ap2 = arena:getCenter()
        ac = {ap1, ap2}
    else 
        aw = self.arena_width
        ah = self.arena_height
        ac = {self.arena_x, self.arena_y}
        if aw == nil or ah == nil or ac[1] == nil or ac[2] == nil then
            error("Anything that involves getting the fence position called during init, you MUST initialize the arena width, height, and center.")
        end
    end
    

    local slice_x = aw / grid_width
    local slice_y = ah / grid_height

    local cx = ac[1]
    local cy = ac[2]
    local ox = cx - aw  / 2
    local oy = cy - ah / 2

    return {
        ox + point[1] * slice_x,
        oy + point[2] * slice_y
    }
end

function T01MovingSolid:spawnWalls(fences, grid_width, grid_height)
    local arena = Game.battle.arena

    local thickness = 5

    for _, fence in ipairs(fences) do
        local p1 = fence[1]
        local p2 = fence[2]

        local x1, y1 = p1[1], p1[2]
        local x2, y2 = p2[1], p2[2]

        -- Horizontal fence
        if y1 == y2 then
            local start_x = math.min(x1, x2)
            local end_x   = math.max(x1, x2)

            local world_start = self:fencePointToWorld({start_x, y1}, grid_width, grid_height)
            local world_end   = self:fencePointToWorld({end_x,   y1}, grid_width, grid_height)

            local x = world_start[1]
            local y = world_start[2]
            local w = world_end[1] - world_start[1] + thickness

            self:spawn_solid(x, y, w, thickness)

        -- Vertical fence
        elseif x1 == x2 then
            local start_y = math.min(y1, y2)
            local end_y   = math.max(y1, y2)

            local world_start = self:fencePointToWorld({x1, start_y}, grid_width, grid_height)
            local world_end   = self:fencePointToWorld({x1, end_y}, grid_width, grid_height)

            local x = world_start[1]
            local y = world_start[2]
            local h = world_end[2] - world_start[2] + thickness

            self:spawn_solid(x, y, thickness, h)

        -- No diag case
        else
        end
    end
end



function T01MovingSolid:update()
    -- Code here gets called every frame

    super.update(self)
end

return T01MovingSolid