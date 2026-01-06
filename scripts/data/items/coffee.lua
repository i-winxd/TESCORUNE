local item, super = Class(TensionItem)

function item:init()
    super.init(self)

    -- Display name
    self.name = "Instant Coffee"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "+32TP%\nSpeed up!"
    -- Shop description
    self.shop = "+32TP%\nIncreases\nplayback\nspeed by 0.4x\nduring battle"
    -- Menu description
    self.description = "Raises TP by 32% in battle.\nIncreases battle playback speed by 0.4x"

    -- Amount of TP this item gives (TensionItem variable)
    self.tp_amount = 32

    -- Default shop price (sell price is halved)
    self.price = 100
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "party"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = true

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {
        susie = "oo ee oo a a bing bang wallawallabingbang",
        ralsei = "oo ee oo a a bing bang wallawallabingbang"
    }
end

function item:onBattleSelect(user, item)
    super.onBattleSelect(self, user, item)
    Game.battle.timescale = Game.battle.timescale + 0.4
end

function item:onBattleDeselect(user, item)
    super.onBattleDeselect(self, user, item)
    Game.battle.timescale = Game.battle.timescale - 0.4
end

-- function item:onBattleUse(user, target)
--     print("Used the item.")
--     super.onBattleUse(self, user, target)
    
--     Game.battle.timescale = Game.battle.timescale * 1.4
-- end

return item