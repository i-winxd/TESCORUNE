local Tesco, super = Class(EnemyBattler)

function Tesco:init()
    super.init(self)

    -- Enemy name
    self.name = "Tesco"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("tesco")

    -- Enemy health
    self.max_health = 600
    self.health = 600
    -- Enemy attack (determines bullet damage)
    self.attack = 3
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 100
    self.tired_percentage = 0

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 10

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "tesco"
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
    self:registerAct("Remove item")
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)
    -- self:registerAct("Tell Story", "", {"ralsei"})
end

function Tesco:onAct(battler, name)
    if name == "Remove item" then
        -- Give the enemy 100% mercy
        self:addMercy(20)
        -- Change this enemy's dialogue for 1 turn
        -- self.dialogue_override = "... ^^"
        -- Act text (since it's a list, multiple textboxes)
        return {
            "* You removed an item\nbefore continuing.",
        }
    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(10)
        if battler.chara.id == "ralsei" then
            -- R-Action text
            return "* Ralsei removed an item from\nbagging area."
        elseif battler.chara.id == "susie" then
            -- S-Action: start a cutscene (see scripts/battle/cutscenes/dummy.lua)
            Game.battle:startActCutscene("dummy", "susie_punch")
            return
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." removed an item from\nbagging area."
        end
    end
    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return Tesco