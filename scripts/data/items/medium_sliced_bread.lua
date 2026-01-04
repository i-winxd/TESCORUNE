-- Instead of Item, create a HealItem, a convenient class for consumable healing items
local item, super = Class(HealItem)

function item:init()
    super.init(self)

    -- Display name
    self.name = "Sliced Bread"
    -- Name displayed when used in battle (optional)
    self.use_name = "Sliced Bread"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "+90HP\nto all"
    -- Shop description
    self.shop = "Heals party\n+90HP"
    -- Menu description
    self.description = "Lovely Bread really soft and makes delicious\nsandwiches will definitely buy again. Heals party +90HP"

    -- Amount healed (HealItem variable)
    self.heal_amount = 90
    -- note: 
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
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions (key = party member id)
    self.reactions = {
        susie = "Bread.",
        ralsei = "Bread.",
        noelle = "That was underwhelming...",
    }
end

return item