local Tesco, super = Class(Encounter)

function Tesco:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* An unexpected item appears in the bagging area!"

    -- Battle music ("battle" is rude buster)
    -- self.music = "UNEXPECTEDITEM_02"
    -- self.music = ""
    self.music = ""
    -- Enables the purple grid battle background
    self.background = true

    -- Add the dummy enemy to the encounter
    self:addEnemy("tesco")

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
end


function Tesco:createSoul(x, y, color)
    -- return Soul(x, y, color)
    return YellowSoul(x, y)
end

return Tesco