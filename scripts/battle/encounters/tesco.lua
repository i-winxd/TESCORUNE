local Tesco, super = Class(Encounter)

function Tesco:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* An unexpected item appears in the bagging area!"

    -- Battle music ("battle" is rude buster)
    -- self.music = "UNEXPECTEDITEM_02"
    self.music = "BIGSHOT"
    -- self.music = "UNEXPECTEDITEM_02"
    -- Enables the purple grid battle background
    self.background = true

    -- Add the dummy enemy to the encounter
    self:addEnemy("tesco")

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
    self.cur_frame_bg_only = 0
    self.cur_frame_tracks_only = 0
    self.bg_speed = 1
end

function Tesco:getVictoryText(text, money, xp)
    if Game.battle and Game.battle.used_violence then 
        return super.getVictoryText(self, text, money, xp)
    else
        return "* Clubcard accepted. Thanks for shopping at Tesco."
    end
end


local background_image = Assets.getTexture("battle_bg/tesco_panover_2") -- assets/sprites/battle_bg/tesco_bg.png"
local track_image = Assets.getTexture("battle_bg/tracks_transparent")
local kart = Assets.getTexture("battle_bg/stage_kart")

-- WHERE fade is between 0 to 1
function Tesco:drawBackground(fade)
    local distance_per_second  = -40
    local base_track_y = 45 + 7
    local track_increase = 45
    local track_sf = 2
    local img_scale = 1.5

    self.cur_frame_tracks_only = self.cur_frame_tracks_only + DT * self.bg_speed
    self.cur_frame_bg_only = self.cur_frame_bg_only + DT * self.bg_speed

    local track_position = self.cur_frame_tracks_only * distance_per_second
    local bg_position = self.cur_frame_bg_only * distance_per_second

    local track_width = track_image:getWidth()
    local bg_width = background_image:getWidth()

    if track_position <= -track_width then
        self.cur_frame_tracks_only = 0
    end

    if bg_position <= -bg_width then
        self.cur_frame_bg_only = 0
    end


    love.graphics.push()
    love.graphics.scale(img_scale, img_scale)
    love.graphics.setColor(1, 1, 1, (fade))

    love.graphics.draw(background_image, bg_position, -100)
    love.graphics.draw(background_image, bg_position + bg_width, -100)

    love.graphics.pop()

    love.graphics.push()
    love.graphics.setColor(0, 0, 0, fade * 0.6)
    love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    love.graphics.pop()

    love.graphics.push()
    love.graphics.setColor(0, 0, 0, fade)
    love.graphics.rectangle("fill", 0, 80, SCREEN_WIDTH, SCREEN_HEIGHT)
    love.graphics.pop()
    local x_offset = {2, 8, 8}
    for i = 1, 3 do
        local ty = base_track_y + (i - 1) * track_increase

        love.graphics.push()
        love.graphics.scale(track_sf, track_sf)
        love.graphics.setColor(1, 1, 1, fade)

        love.graphics.draw(track_image, track_position, ty)
        love.graphics.draw(track_image, track_position + track_width, ty)

        love.graphics.pop()

        love.graphics.push()
        love.graphics.setColor(1, 1, 1, fade)
        local kart_scale = 2
        love.graphics.scale(kart_scale, kart_scale)
        love.graphics.draw(kart, 37+x_offset[i], ty)

        love.graphics.pop()
    end






    super.drawBackground(self, fade)
end

-- function Tesco:createSoul(x, y, color)
--     -- return Soul(x, y, color)
--     return YellowSoul(x, y)
-- end

return Tesco
