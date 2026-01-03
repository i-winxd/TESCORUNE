local Tesco, super = Class(EnemyBattler)

function Tesco:init()
    super.init(self)

    -- Enemy name
    self.name = "Tesco"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("tesco")

    -- Enemy health
    self.max_health = 7300
    self.health = 7300
    -- Enemy attack (determines bullet damage)
    self.attack = 7
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 100
    self.tired_percentage = 0

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "tesco",
        "bag_attack",
        "karts",
        "top_kart",
        "t01_moving_solid",
        "t02_inward_item",
        "t03_truck",
        "tesco2"
        -- "basic"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "UNEXPECTED ITEM IN",
        "REMOVE THIS ITEM BEFORE",
        "BAGGING AREA"
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 4 DF 0\n* Unexpected item\n* in bagging area"

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* The unexpected item appears\nin the bagging area.",
        "* Smells like Tesco.",
        "* The enemy bows to the audience.",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* The enemy looks like it's\nabout to go bankrupt."

    -- Register act called "Smile"
    -- self:registerAct("Remove item")
    -- self:registerAct("Remove all", nil, "ALL")
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)
    -- self:registerAct("Tell Story", "", {"ralsei"})
    
    self:registerAct("Remove item", "+2% mercy")
    self:registerAct("Remove all", "+6.5% mercy", {"susie", "ralsei"})
    self:registerAct("Buy", "+Random\nitem", nil, 24)
    -- self:registerActFor



    self.phase_sequence = 1
    self.mega_attack_done = false
end

-- 
-- for id, item_data in pairs(Registry.items) do
--     local item = item_data()
--     self:registerOption(
--         "give_item",
--         item.name + (item.light and " (Light Item)" or ""),
--         item.description,
--         function()
--             Game.inventory:tryGiveItem(item_data())
--         end
--     )
-- end


--- Progress of the current battle, used to determine phases.
function Tesco:getProgress()
    local dmgp = 1 - (self.health / self.max_health)
    local merc = self.mercy / 100
    return math.min(1, math.max(0, dmgp, merc))
end


local p1 = {
    "tesco",
    "bag_attack",
    "karts",
    "top_kart",
}

local p2 = {
    "t01_moving_solid",
    "t02_inward_item",
    "tesco2",
    "t04_bag_td",
    "top_kart",

}

local p3 = {
    "t03_truck",
    "t04_bomb_td",
    "t05_card_attack",
    "t06_scanner",
    "tesco4",
    "top_kart",

}

local p4 = {
    "t07_grenades",
    "t08_bloons",
    "tesco4",
    "top_kart",
    "t05_card_attack",
    "t03_truck",
}

local p1a = 0
local p2a = 0
local p3a = 0
local p4a = 0

function Tesco:getNextWaves()
    local progress = self:getProgress()
    if progress >= 0.90 and self.mega_attack_done ~= true then 
        self.mega_attack_done = true
        return {"t20_final"}
    end
    if progress <= 0.27 then 
        local cat = {p1[p1a+1]}
        p1a = (p1a+1)%(#p1)
        return cat
    elseif progress <= 0.56 then
        local cat = {p2[p2a+1]}
        p2a = (p2a+1)%(#p2)
        return cat
    elseif progress <= 0.75 then
        local cat = {p3[p3a+1]}
        p3a = (p3a+1)%(#p3)
        return cat
    else
        local cat = {p4[p4a+1]}
        p4a = (p4a+1)%(#p4)
        return cat
    end



end

function Tesco:onAct(battler, name)
    if name == "Remove item" then
        -- Give the enemy 100% mercy
        self:addMercy(2)
        -- Change this enemy's dialogue for 1 turn
        -- self.dialogue_override = "... ^^"
        -- Act text (since it's a list, multiple textboxes)
        return {
            "* " .. battler.chara.name .. " removed an item\nbefore continuing.",
        }
    elseif name == "Remove all" then 
        self:addMercy(6.5)
        return {
            "* Everyone removed an item!"
        }
    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(2)
        return "* "..battler.chara:getName().." removed an item from\nbagging area."
        -- if battler.chara.id == "ralsei" then
        --     -- R-Action text
        --     return "* Ralsei removed an item from\nbagging area."
        -- elseif battler.chara.id == "susie" then
        --     -- S-Action: start a cutscene (see scripts/battle/cutscenes/dummy.lua)
        --     Game.battle:startActCutscene("dummy", "susie_punch")
        --     return
        -- else
        --     -- Text for any other character (like Noelle)
        --     return "* "..battler.chara:getName().." removed an item from\nbagging area."
        -- end
    end
    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return Tesco