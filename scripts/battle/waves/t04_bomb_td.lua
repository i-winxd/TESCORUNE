local BombTD, super = Class(Wave)


function BombTD:init()
    super.init(self) -- remember this!!!
    self.time = 45
    -- self.arena_x = (SCREEN_WIDTH * 0.4)
    -- self.arena_y = (SCREEN_HEIGHT - 155) / 2 + 10
    self.arena_height = (SCREEN_HEIGHT - 155) * 0.6
    self.arena_width = 25
    self.arena_x = SCREEN_WIDTH * 0.3
    self.arena_y = SCREEN_HEIGHT * 0.7 * 0.5
    self.timer = Timer()
    self.all_removed = false
    self.bombs = {}
    self:addChild(self.timer)
    self.ending = false


    self.destroyed = 0
    self.total_bombs = 9999
end

function BombTD:onEnd(death)
    if not death and self._original_soul then
        Game.battle:swapSoul(self._original_soul)
        self._original_soul = nil
    end
end

function BombTD:setFinished()
    self.finished = true
end

function BombTD:onStart()
    self._original_soul = Game.battle.soul
    local standard_soul = YellowSoul()
    Game.battle:swapSoul(standard_soul)


    local ax, ay = Game.battle.arena:getCenter()
    local ah = Game.battle.arena.height
    local aw = Game.battle.arena.width
    local spawn_these_many = 8
    -- the bullet is called mtt_bomb_path
    local aty = ay - (ah / 2)
    local unit_move = 40
    local top_fr = 0.05
    local bottom_fr = 0.95
    -- path as follows:
    local path = { { SCREEN_WIDTH, aty + ah * top_fr } }
    local C = 5
    local x = path[1][1]
    local y = path[1][2]
    for i = 1, C do
        x = x - unit_move
        table.insert(path, { x, y })
        y = aty + ah * bottom_fr
        table.insert(path, { x, y })
        x = x - unit_move
        table.insert(path, { x, y })
        y = aty + ah * top_fr
        table.insert(path, { x, y })
    end
    local top_x, top_y = ax, (ay - ah / 2) - 30
    table.insert(path, { path[#path][1], top_y })
    table.insert(path, { top_x, top_y })
    print("INSERTED path length:", #path)
    

    local bullet_count = 8
    local timer_delay = 0.3

    -- self.timer:everyInstant(timer_delay, function()
    --     -- local mtt_path_thing = mtt_bomb_path(the_path)

    --     end)
    --     self:spawnBullet("mtt_bomb_path", the_path, 200)
    -- end, bullet_count)

    -- bomb wave structure
    -- {wait this long, spawn this many, at a gap of __, with a speed of}
    local all_bombs_spawned = false
    self.timer:script(function(wait) 
        local spawn_waves = {{0.4, 8, 0.3, 80}, {4, 13, 0.2, 120}, {4, 2, 0.6, 150}}
        local total_bombs = 0
        for i = 1, #spawn_waves do 
            total_bombs = total_bombs + spawn_waves[i][2]
        end
        self.total_bombs = total_bombs
        for i = 1, #spawn_waves do
            local wait_time = spawn_waves[i][1]
            local spawn_count = spawn_waves[i][2]
            local velo = spawn_waves[i][4]
            local gap = spawn_waves[i][3]
            wait(wait_time)
            for j = 1, spawn_count do
                local the_path = self:create_path_obj(path, function() end)
                local spawned_bomb = self:spawnBullet("mtt_bomb_path", the_path, velo, function() 
                    
                    self.destroyed = self.destroyed + 1
                    print("KABOOM!", self.destroyed, "Have been destroyed./", self.total_bombs)
                    if self.destroyed >= self.total_bombs then 
                                            self.timer:script(function(wait) 
                        wait(0.4)
                        self:setFinished()
end)
                    end
                end)
                table.insert(self.bombs, spawned_bomb)
                wait(gap)
            end
        end
        all_bombs_spawned = true
    end)
end

-- function BombTD:update()
--     local not_finished = false

--     if self.all_bombs_spawned and not self.all_removed then 
--         for b in self.bombs do 
--             if not b:isRemoved() then 
--                 not_finished = true
--                 break
--             end
--             print("A bomb was finsihed")
--         end
--     else
--         not_finished = true
--     end


--     if not not_finished then
--         print("ENDING THIS WAVE")
--         self.ending = true
--         self.timer:script(function(wait) 
--             wait(0.4)
--             self:setFinished()
--         end)
--     end
--     super.update(self)
-- end

--- This is technically a static function but I need to wrap this
function BombTD:create_path_obj(path, on_finish)
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

return BombTD
