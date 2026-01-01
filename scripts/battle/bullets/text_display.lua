local BLT, super = Class(Bullet)

--- Text display.
--- Displays text, though this
--- is intangible.
--- The font size is fixed.
function BLT:init(x, y, font_size, non_mono, text)
    self.font_size = font_size
    self.text = text
    self.intangible = true
    self.x, self.y = x, y
    self.font = "main"
    local font_obj
    if non_mono then 
        font_obj = love.graphics.newFont("assets/fonts/main.ttf", self.font_size, "normal")
    else
        font_obj = love.graphics.newFont("assets/fonts/main_mono.ttf", self.font_size)
    end
    font_obj:setFilter("nearest", "nearest")

    self.font_obj = font_obj
    -- super.init(self, x, y, "bullets/pound_symbol")
    super.init(self, x, y)
    self:setLayer(BATTLE_LAYERS["below_soul"])
    self.frame_count = 0
    self.can_graze = false
    self.destroy_on_hit = false
    self.remove_offscreen = false

    self.shaking = false
    self.alive_for = 0
    self.shake_amp = 0.4
    self.shake_speed = 6 -- 360 degree cycles per second
end

function BLT:set_text(text)
    self.text = text
end


local function ps_rander(n)
    local x = math.sin(n * 12.9898) * 43758.5453
    return x - math.floor(x)
end

function BLT:update()
    self.frame_count = self.frame_count + 1
    self.alive_for = self.alive_for + 1*DT
    super.update(self)
end


function BLT:draw_shaking()
    local font = self.font_obj
    local text = self.text
    local cx, cy = 0, 0
    local x = cx
    local y = cy

    local totalWidth = font:getWidth(text)
    local totalHeight = font:getHeight()

    -- start drawing from the left edge of the text
    local startX = cx - totalWidth / 2
    local startY = cy - totalHeight / 2

    local ox_global = startX

    local cur_time = self.alive_for
    local amp = self.shake_amp
    local spd = self.shake_speed
    local rotation = cur_time * math.pi * 2 * spd
    local function get_rot_offset(rot_, amp_) 
        return math.cos(rot_) * amp, math.sin(rot_) * amp
    end

    love.graphics.push("all")
    Draw.setColor(1, 1, 1)
    love.graphics.setFont(self.font_obj)
    for i = 1, #text do
        local ox, oy = get_rot_offset(rotation + ps_rander(i)*4.31, amp)
        local char = text:sub(i,i)
        love.graphics.print(char, ox_global + ox, startY + oy)
        ox_global = ox_global + font:getWidth(char)
    end
    love.graphics.pop()
end

function BLT:draw_standard()
    local text_width = self.font_obj:getWidth(self.text)
    local text_height = self.font_obj:getHeight()
    local cx, cy = 0-text_width/2, 0-text_height/2

    love.graphics.push("all")
    Draw.setColor(1, 1, 1)
    love.graphics.setFont(self.font_obj)
    love.graphics.print(self.text, cx, cy)
    Draw.setColor()
    love.graphics.pop()
end

function BLT:draw()
    if self.shaking then 
        self:draw_shaking()
    else
        self:draw_standard()
    end
    
    -- super call or something
    super.draw(self)
end

function BLT:onCollide(soul)
    if not self.intangible then
        super.onCollide(self, soul)
    end
end

return BLT