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

---@param tbl any[]
---@param sort boolean?
---@param remove boolean?
local function pick(tbl, sort, remove)
    if sort then
        local indexes = {}
        for i, v in ipairs(tbl) do
            if sort(v) then
                table.insert(indexes, i)
            end
        end
        local i = indexes[love.math.random(#indexes)]
        if remove then
            return table.remove(tbl, i)
        else
            return tbl[i]
        end
    else
        if remove then
            return table.remove(tbl, love.math.random(#tbl))
        else
            return tbl[love.math.random(#tbl)]
        end
    end
end

local entry_point = {0.5, 0.5}
-- local entry_point = {2.2, 3.5}
local bag_location = {5, 3}

-- The soul moves once per second.
function T01MovingSolid:init()

    super.init(self)  -- remember this!!!
    self.time = 10000
    -- self.arena_x = (SCREEN_WIDTH * 0.4)
    -- self.arena_y = (SCREEN_HEIGHT - 155) / 2 + 10
    self.arena_height = SCREEN_HEIGHT * 0.50
    self.arena_width = SCREEN_WIDTH * 0.70
    self.arena_x = SCREEN_WIDTH * 0.5
    self.arena_y = SCREEN_HEIGHT * 0.7 * 0.5
    self.fence_solids = {}
    -- Game.battle.arena:setSize(600, 600)

    local fpw = self:fencePointToWorld(entry_point, 6, 4)
    self.soul_start_x = fpw[1]
    self.soul_start_y = fpw[2]

    self.cur_state = 0  -- 0: the bag is visible. 1: run back. 2: nek BW. 3: nek full
    self.timer = Timer()
    self:addChild(self.timer)

    self.freeze_these = {}
    self.left_threshold = self:fencePointToWorld({3.2, 0}, 6, 4)[1]
end

function T01MovingSolid:freeze_all()
    self.saved_speed = Game.battle.soul.speed
    Game.battle.soul.speed = 0
    for i = 1, #self.freeze_these do 
        local freezer = self.freeze_these[i]
        freezer.frozen = true
    end
    Game.battle.arena.color = {0.4, 0.4, 0.4}
    for i = 1, #self.fence_solids do 
        self.fence_solids[i].color = {0.4, 0.4, 0.4}
    end

end

function T01MovingSolid:unfreeze_all()
    Game.battle.soul.speed = (self.saved_speed or 4) * 1.25
    for i = 1, #self.freeze_these do 
        local freezer = self.freeze_these[i]
        freezer.frozen = false
    end
    Game.battle.arena.color = {0.90, 0, 0}
    for i = 1, #self.fence_solids do 
        self.fence_solids[i].color = {0.90, 0, 0}
    end

end

local icon_textures = {
        "bullets/tesco_icons/air_frier",
        "bullets/tesco_icons/banana_icon_pixel",
        "bullets/tesco_icons/cereal_box",
        "bullets/tesco_icons/sandwich_icon",
        "bullets/tesco_icons/shop_box",
        "bullets/tesco_icons/fihs",
        "bullets/tesco_icons/roundel",
        "bullets/tesco_icons/fries",
        "bullets/tesco_icons/tesco_beer",
    }

function T01MovingSolid:onEnd(death)
    if self.saved_speed then 
        Game.battle.soul.speed = self.saved_speed
    end
    if not death and self._original_soul then
        Game.battle:swapSoul(self._original_soul)
        self._original_soul = nil
    end
end

local bag_texture = "bullets/tesco_icons/bag_of_area"
local exit_texture = "bullets/way_out_sign"


function T01MovingSolid:setFinished()
    self.finished = true
end

--- DO NOT HANDLE THE LOGIC THAT MOVES THE LIGHT
function T01MovingSolid:onBagClaimed()
    Assets.playSound("snd_coin")
    local cloc = self:fencePointToWorld(entry_point, 6, 4)
    local item_trigger_thing = self:spawnBullet("t01_moving_solid/item_trigger",
        cloc[1], 
        cloc[2]-0.35, 
        2, 
        exit_texture,
        function()
            self.timer:script(function(wait) 
                wait(0.15)
                self:setFinished()
            end)
            return false  -- returning true immediately removes this bullet afterwards
        end
    )
    item_trigger_thing.can_graze = false
    item_trigger_thing:setScale(0.5, 0.5)
---@diagnostic disable-next-line: inject-field
    item_trigger_thing.osc = true
    table.insert(self.freeze_these, item_trigger_thing)
    self.cur_state = 1
end

function T01MovingSolid:spawnNek() 
    self.cur_state = 2

    local bag_path = {
        {5, 3},
        {5, 3.9},
        {3.5, 3.9},
        {2.5, 3.9},
        {2.5, 3.25},
        {4, 1.5},
        {5.25, 1},
        {4, 0.5},
        {2.5, 0.5},
        {2.5, 1.5},
        {1.65, 1.5},
        {1.65, 0.5},
        {1.65, 3.5},
        {0.5, 3.5},
        {0.5, 0.5}
    }
    local bag_path_transformed = {}
    for i = 1, #bag_path do 
        local bt = self:fencePointToWorld(bag_path[i], 6, 4)
        table.insert(bag_path_transformed, bt)
    end
    local the_path = self:create_path_obj(bag_path_transformed, function() end)
    local spawn_text_here = self:fencePointToWorld({5, 1.5}, 6, 4)
    local nek = self:spawnBullet("t01_moving_solid/nek", the_path)
    self:freeze_all()
    self.timer:script(function(wait)
        local actual_text = self:spawnBullet("text_display", 
            spawn_text_here[1], 
            spawn_text_here[2], 
            16, false, "")
        actual_text:setLayer(BATTLE_LAYERS["above_bullets"])
        actual_text.shaking = true
        local movements = {
            0.21,
            1.10-0.21,
            1.62-1.10,
            2.55-1.62,
            3.23-2.55
        }
        Assets.playSound("nekta", 1.4)
        -- 0.21 NEK
        -- 1.10 TA
        -- 1.62 RYN
        -- 2.55 KI
        -- 3.25
        wait(movements[1])
        actual_text:set_text("NEK")
        wait(movements[2])
        actual_text:set_text("NEKTA")
        wait(movements[3])
        actual_text:set_text("NEKTARYN")
        wait(movements[4])
        actual_text:set_text("NEKTARYNKI")
        wait(movements[5])
        -- HE STARTS MOVING
        actual_text:remove()
        Assets.playSound("snd_jackolantern_laugh", 1.4)
        self:unfreeze_all()
        nek:beginMove()

        self.timer:tween(7, nek, {path_speed = 135}, "linear")
        
    end)
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
    local th = 6
    local tw = 4
    local cloc = self:fencePointToWorld(bag_location, th, tw)
    local cir = self:spawnBullet("t01_moving_solid/solid_circle", 
                    cloc[1], cloc[2], 20)


    local spawned_solids = self:spawnWalls(fences, th, tw)
    self.fence_solids = spawned_solids -- TODO: make these black and white
    -- in the your taking too long section
    -- the default color is {0, 0.75, 0} and you can set the color by doing solid.color = {1,0,1}

    -- t01_moving_solid/osc_bullet
    -- x1, y1, x2, y2, period, texture
    local nd = 0.1
    ---@type T01MovingBullet[]
    local arena_items = {
        {
            p1 = {0+nd, 2},
            p2 = {1-nd, 2},
            texture = pick(icon_textures)
        },
        {
            p1 = {0+nd, 3+0.25},
            p2 = {2-nd, 3+0.25},
            texture = pick(icon_textures)
        },
        {
            p2 = {0+nd, 4-0.25},
            p1 = {2-nd, 4-0.25},
            texture = pick(icon_textures)
        },
        {
            p1 = {1+nd,1+nd},
            p2 = {2-nd,2-nd},
            texture = pick(icon_textures)
        },
        {
            p1={2+0.25, 0+nd},
            p2={3-0.25, 2-nd},
            texture = pick(icon_textures)
        },
        {
            p2={3-0.25, 0+nd},
            p1={2+0.25, 2-nd},
            texture = pick(icon_textures)
        },
        {
            p1={4+nd,0+0.25},
            p2={6-nd,0+0.25},
            texture = pick(icon_textures)
        },
                {
            p2={4+nd,1+0.00},
            p1={6-nd,1+0.00},
            texture = pick(icon_textures)
        },
        {
            p2={4+nd,0+0.25},
            p1={4+nd,2-0.25},
            texture = pick(icon_textures)
        },
        {
            p1={2+0.25, 2+nd},
            p2={2+0.25, 4-nd},
            texture = pick(icon_textures)
        },
        {
            p2={3-0.25, 2+nd},
            p1={3-0.25, 4-nd},
            texture = pick(icon_textures)
        },
        {
            p1={2+nd, 2+0.5},
            p2={4-nd, 2+0.5},
            texture = pick(icon_textures)
        },
        -- {
        --     p1={3+nd, 1+0.5},
        --     p2={6+nd, 1+0.5},
        --     texture = pick(icon_textures)
        -- }
    }
    local moving_bullets = self:spawnMovingBullets(arena_items, th, tw)
    -- t01_moving_solid/item_trigger - x,y,scale,texture
    local item_trigger_thing = self:spawnBullet("t01_moving_solid/item_trigger",
        cloc[1], 
        cloc[2]-0.35, 
        2, 
        bag_texture,
        function() 
            local new_light_center = self:fencePointToWorld(entry_point, th, tw)
            self.timer:tween(1, cir, {x=new_light_center[1],y=new_light_center[2]}, "out-cubic")
            self:onBagClaimed()
            return true  -- returning true immediately removes this bullet afterwards
        end
    )
    item_trigger_thing.can_graze = false
    
    ---@diagnostic disable-next-line: inject-field
    item_trigger_thing.osc = true
    for i = 1, #moving_bullets do 
        table.insert(self.freeze_these, moving_bullets[i])
    end
end

local base_period = 3

---@alias T01MovingBullet {p1: number[], p2: number[], texture: number}

---
---
--- @param points T01MovingBullet[]
--- @param grid_width number
--- @param grid_height number
--- @return any[]
function T01MovingSolid:spawnMovingBullets(points, grid_width, grid_height)
    local collected_bullets = {}
    for _, fence in ipairs(points) do 
        local p1x, p1y = fence.p1[1], fence.p1[2]
        local p2x, p2y = fence.p2[1], fence.p2[2]
        local c1 = self:fencePointToWorld({p1x,p1y}, grid_width, grid_height)
        local c2 = self:fencePointToWorld({p2x, p2y}, grid_width, grid_height)
        local x1, y1 = c1[1], c1[2]
        local x2, y2 = c2[1], c2[2]
        local spawned_bullet = self:spawnBullet("t01_moving_solid/osc_bullet", 
            x1, y1, x2, y2, base_period, fence.texture)
        table.insert(collected_bullets, spawned_bullet)
    end
    return collected_bullets
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
    local collected_solids = {}
    for _, fence in ipairs(fences) do
        local p1 = fence[1]
        local p2 = fence[2]

        local x1, y1 = p1[1], p1[2]
        local x2, y2 = p2[1], p2[2]
        if y1 == y2 then
            local start_x = math.min(x1, x2)
            local end_x   = math.max(x1, x2)

            local world_start = self:fencePointToWorld({start_x, y1}, grid_width, grid_height)
            local world_end   = self:fencePointToWorld({end_x, y1}, grid_width, grid_height)

            local x = world_start[1]
            local y = world_start[2]
            local w = world_end[1] - world_start[1] + thickness

            local sol_col = self:spawn_solid(x, y, w, thickness)
            table.insert(collected_solids, sol_col)
        elseif x1 == x2 then
            local start_y = math.min(y1, y2)
            local end_y   = math.max(y1, y2)

            local world_start = self:fencePointToWorld({x1, start_y}, grid_width, grid_height)
            local world_end   = self:fencePointToWorld({x1, end_y}, grid_width, grid_height)

            local x = world_start[1]
            local y = world_start[2]
            local h = world_end[2] - world_start[2] + thickness

            local sol_col = self:spawn_solid(x, y, thickness, h)
            table.insert(collected_solids, sol_col)
        -- No diag case
        else
        end
    end
    return collected_solids
end


function T01MovingSolid:update()
    -- Code here gets called every frame
    local soul_x = Game.battle.soul.x
    if self.cur_state == 1 and soul_x <= self.left_threshold then 
        self:spawnNek()
    end
    super.update(self)
end

function T01MovingSolid:create_path_obj(path, on_finish)
    --- For some reason, this is a drop in function
    --- because I DONT KNOW HOW TO EXPORT STUFF
    --- Creates an object that represents a path.
    --- From somewhere. To somewhere. Or something.
    --- I can then traverse this path and it gives me the coordinates.
    --- @param path number[][] list of 2D coordinates constructing the path. MUST BE NONEMPTY
    --- @param on_finish function run this callback, if applicable, when the path is finish
    local function create_pather(
        path,
        on_finish
    )
        local function table_copy(t)
            local copy = {}
            for k, v in pairs(t) do
                copy[k] = v
            end
            return copy
        end
        -- these are private attributes and there is no reason to access these anywhere else.
        local path_object = {
            path = table_copy(path),
            current_index = 1,      -- I'm here
            current_progress = 0,   -- from 0 to 1
            x = path[1][1],
            y = path[1][2],
            on_finish = on_finish,
            finish_called = false
        }
        -- restarts the path.
        -- returns cur x and y pos.
        function path_object:restart()
            self.x = self.path[1][1]
            self.y = self.path[1][2]
            self.current_index = 1
            self.current_progress = 0
            return self.x, self.y
        end

        --- performs a step and returns the coordinates I should be in.
        function path_object:step(difference_time, velocity)
            if self == nil then
                return nil, nil
            end
            local path_len = #self.path
            if self.current_index >= path_len then
                if not self.finish_called then
                    self.finish_called = true
                    if self.on_finish then
                        self.on_finish()
                    end
                end
                return self.path[self.current_index][1], self.path[self.current_index][2]
            elseif self.finish_called then
                return nil, nil
            else
                local from_pos = self.path[self.current_index]
                local to_pos = self.path[self.current_index + 1]
                local distance = math.max(0.0001,
                    math.sqrt((to_pos[1] - from_pos[1]) ^ 2 + (to_pos[2] - from_pos[2]) ^ 2))
                -- velocity travels this many units per second.
                -- there is no overflow here, because I don't want to deal
                -- with the overflow case. this does not matter after all.
                local units_to_move = difference_time * velocity
                local percent_moved = math.min(1, units_to_move / distance)
                local next_progress = self.current_progress + percent_moved
                if next_progress >= 1 then
                    self.current_progress = 0
                    self.current_index = self.current_index + 1
                else
                    self.current_progress = next_progress
                end
                if self.current_index + 1 <= #(self.path) then
                    local cpx, cpy = self.path[self.current_index][1], self.path[self.current_index][2]
                    local npx, npy = self.path[self.current_index + 1][1], self.path[self.current_index + 1][2]
                    local cx = (cpx * (1 - self.current_progress) + npx * self.current_progress)
                    local cy = (cpy * (1 - self.current_progress) + npy * self.current_progress)
                    return cx, cy
                else
                    return nil, nil
                end

            end
        end

        return path_object
    end
    return create_pather(path, on_finish)
end



return T01MovingSolid