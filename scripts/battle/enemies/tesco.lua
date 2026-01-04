local Tesco, super = Class(EnemyBattler)
local function rander(a, b, c)
    local function roundToMultiple(value, to)
        if to == 0 then
            return 0
        end

        return math.floor((value + (to / 2)) / to) * to
    end

    if not a then
        return love.math.random()
    elseif not b then
        return love.math.random() * a
    else
        local n = love.math.random() * (b - a) + a
        if c then
            n = roundToMultiple(n, c)
        end
        return n
    end
end
function Tesco:init()
    super.init(self)

    -- Enemy name
    self.name = "Tesco"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("tesco")

    -- Enemy health
    self.max_health = 7100
    self.health = 7100
    -- Enemy attack (determines bullet damage)
    self.attack = 15
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 100
    self.tired_percentage = -99
    self.check = "15 AT 9 DF\nUNEXPECTED ITEM IN BAGGING AREA"

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
    self.low_health_percentage = 0.09
    -- Check text (automatically has "ENEMY NAME - " at the start)
    -- self.check = "AT 4 DF 0\n* Unexpected item\n* in bagging area"

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* The unexpected item appears\nin the bagging area.",
        "* Smells like Tesco.",
        "* The enemy bows to the audience.",
        "* If the soul is [color:yellow]YELLOW[color:reset], press Z to fire, and hold Z to fire a [BIG SHOT]!"
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
    self:registerAct("Remove all", "+6.5%\nmercy", {"susie", "ralsei"})
    self:registerAct("Meal Deal", "Rdm party\nmember +HP", nil, 45)
    self:registerAct("Work overtime", "Undos\ncoffee", nil, 95)

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
    "bag_attack_ex",
    "tesco",
    "karts",
    "top_kart",
    "bag_attack_ex"
}

local p2 = {
    "t01_moving_solid",
    "t02_inward_item",
    "tesco2",
    "t04_bag_td",
    "top_kart",
    "bag_attack_ex"
}

local p3 = {
    "t03_truck",
    "t04_bomb_td",
    "t05_card_attack",
    "t06_scanner",
    "tesco4",
    "top_kart",
    "bag_attack_ex"
}

local p4 = {
    "t07_grenades",
    "t08_bloons",
    "tesco4",
    "top_kart",
    "bag_attack_ex",
    "t05_card_attack",
    "t03_truck",
}

local wave_dialogue = {
    tesco = "UNEXPECTED ITEM IN",
    bag_attack = {"BAGGING AREA"},
    karts = "REMOVE THIS ITEM",
    top_kart = "BEFORE CONTINUING",
    t01_moving_solid = "BABEL",
    t02_inward_item = "BAGGING AREA",
    tesco2 = "AN ATTENDANT WILL BE\nWITH YOU SHORTLY",
    t04_bag_td = {"INSERT CASH", "OR SELECT PAYMENT TYPE"},
    t03_truck = {"ENJOY FREE SHIPPING\nON ALL ORDERS ABOVE", "ALL ORDERS ABOVE"},
    t04_bomb_td = {"THE BAGS APPROACH", "AGAIN"},
    t05_card_attack = "PLACE THE ITEM\nIN THE BAG",
    t06_scanner = "NOTHING BEATS A JET2HOLIDAY",
    t07_grenades = "SAY HELLO TO",
    t08_bloons = "HAPPY BIRTHDAY 1997",
    t20_final = {"DO YOU HAVE A CLUBCARD?", "YOU HAVE A CLUBCARD", "MAY YOU PLEASE", "ENTER IT"},
}
local generic_dialogue = {
    "UNEXPECTED ITEM",
    "REMOVE THIS ITEM",
    "BAGGING AREA"
}

local function get_dialogue(wave_name)
    -- print("Obtaining dialogue for " .. wave_name)
    local wd = wave_dialogue[wave_name]
    if wd == nil then 
        local gd = generic_dialogue[rander(1, 3, 1)]
        return gd
    end
    return wd
end

local p1a = 0
local p2a = 0
local p3a = 0
local p4a = 0

function Tesco:getXAction(battler)
    if battler.chara.id == "susie" or battler.chara.id == "ralsei" then
        return "Remove item"
    end
    return super.getXAction(self, battler)
end

function Tesco:getEnemyDialogue()
    local attack_tbd = self:updateWave()
    self.wave_override = attack_tbd[1]
    return super.getEnemyDialogue(self)
end

function Tesco:updateWave()
    local progress = self:getProgress()
    if progress >= 0.90 and self.mega_attack_done ~= true then 
        self.mega_attack_done = true
        self.dialogue_override = get_dialogue("t20_final")
        return {"t20_final"}
    end
    if progress <= 0.26 then 
        local cat = {p1[p1a+1]}
        p1a = (p1a+1)%(#p1)
        self.dialogue_override = get_dialogue(cat[1])
        return cat
    elseif progress <= 0.54 then
        local cat = {p2[p2a+1]}
        p2a = (p2a+1)%(#p2)
        self.dialogue_override = get_dialogue(cat[1])
        return cat
    elseif progress <= 0.75 then
        local cat = {p3[p3a+1]}
        p3a = (p3a+1)%(#p3)
        self.dialogue_override = get_dialogue(cat[1])
        return cat
    else
        local cat = {p4[p4a+1]}
        p4a = (p4a+1)%(#p4)
        self.dialogue_override = get_dialogue(cat[1])
        return cat
    end
end


function Tesco:onRemove(parent)
    print("ATTEMPTING TO GIVE A SHADOWCRYSTAL")
    Game.inventory:tryGiveItem("shadowcrystal")
    super.onRemove(self, parent)
end


function Tesco:onDefeat(damage, battler)
    self.hurt_timer = -1
    self.defeated = true
    -- Assets.playSound("defeatrun")
    if Game.battle.music then 
        Game.battle.music:stop()
    end
    local bubble = self:spawnSpeechBubble({"YOU'LL BE FINED FOR THIS"}, {line_callback = function() 
        print("AFTER CALLED")
        self:explode(0, 0, true)
        self.alpha = 0
        Game.battle.timer:after(1.2, function() 
            self:remove()
        end)
    end})
        -- Game.battle.timer:after(0.15, function ()
        
        -- self:explode(0, 0, true)
        -- Game.battle.timer:after(14 / 30, function()
        --         self:remove()
        --     end)
        -- end)
    

    self:defeat("VIOLENCED", true)
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
    elseif name == "Meal Deal" then
        local battlers = {}
        for _, battler in ipairs(Game.battle.party) do
            table.insert(battlers, battler)
        end
        local bt = rander(1, #battlers, 1)
        print("chosen battler is ".. bt .. " with " .. #battlers)
        local choice = battlers[bt]
        choice:heal(rander(70, 110, 1))
        return {
            "* You acquired a meal deal."
        }
    elseif name == "Work overtime" then
        if Game.battle.timescale > 1 then 
            Game.battle.timescale = 1
            return {
                "* You worked overtime.",
                "* Effects of coffee have been nullified."
            }
        else
            return {
                "* You worked overtime.",
                "* Nothing happened. Did you not take coffee?"
            }
        end
        
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