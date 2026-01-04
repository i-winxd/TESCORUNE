local item, super = Class(HealItem)

function item:init()
    super.init(self)

    -- Display name
    self.name = "Bo'le of Wa'er"
    -- Name displayed when used in battle (optional)
    self.use_name = "Water"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "+90 HP\nDilutes\ncoffee"
    -- Shop description
    self.shop = "A compound\nconsisting of\ntwo hydrodgen\none oxygen.\n+90 HP"
    -- Menu description
    self.description = "Nothing but Dihydrodgen Monoxide. Heals 90 HP. Reduces gameplay speed by 0.1x if above 1x."

    -- Amount of TP this item gives (TensionItem variable)
    self.heal_amount = 90

    -- Default shop price (sell price is halved)
    self.price = 0
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
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
        susie = "",
        ralsei = ""
    }
end

-- function item:onBattleSelect(user, item)
--     super.onBattleSelect(self, user, item)
--     Game.battle.timescale = Game.battle.timescale + 0.4
-- end

-- function item:onBattleDeselect(user, item)
--     super.onBattleSelect(self, user, item)
--     Game.battle.timescale = Game.battle.timescale - 0.4
-- end

function item:onBattleUse(user, target)
    super.onBattleUse(self, user, target)    
    Game.battle.timescale = math.max(1, Game.battle.timescale - 0.2)
end

return item