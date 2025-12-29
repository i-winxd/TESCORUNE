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
        current_index=1,  -- I'm here
        current_progress=0,  -- from 0 to 1
        x=path[1][1],
        y=path[1][2],
        on_finish=on_finish,
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
        local path_len = #self.path
        if self.current_index == path_len then
          if not self.finish_called then
            if self.on_finish then
              self.on_finish()
            end
            self.finish_called = true
          end
          return self.path[self.current_index][1], self.path[self.current_index][2]
        else
          local from_pos = self.path[self.current_index]
          local to_pos = self.path[self.current_index + 1]
          local distance = math.max(0.0001, math.sqrt((to_pos[1] - from_pos[1]) ^ 2 + (to_pos[2] - from_pos[2]) ^ 2))
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
          local cx = self.path[self.current_index][1] * (1-self.current_progress) + self.path[self.current_index + 1][1] * self.current_progress
          local cy = self.path[self.current_index][2] * (1-self.current_progress) + self.path[self.current_index + 1][2] * self.current_progress
          return cx, cy
        end
    end
    return path_object
end
