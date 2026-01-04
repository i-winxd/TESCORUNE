-- Instead of Item, create a HealItem, a convenient class for consumable healing items
local item, super = Class(HealItem)

function item:init()
    super.init(self)

    -- Display name
    self.name = "Butter"
    -- Name displayed when used in battle (optional)
    self.use_name = "Butter"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "+130HP"
    -- Shop description
    self.shop = "It's just\na brick."
    -- Menu description
    self.description = "100% British milk Expertly churned\nfor a smooth creamy taste. +130HP"

    -- Amount healed (HealItem variable)
    self.heal_amount = 130
    -- note: 
    -- Default shop price (sell price is halved)
    self.price = 100
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
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
        susie = "I'm lactose intolerant.",
        ralsei = "That's over my sodium tolerance...",
        noelle = "That was underwhelming...",
    }
end

return item