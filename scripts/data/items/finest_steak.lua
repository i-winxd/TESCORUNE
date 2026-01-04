-- Instead of Item, create a HealItem, a convenient class for consumable healing items
local item, super = Class(HealItem)

function item:init()
    super.init(self)

    -- Display name
    self.name = "Finest Steak"
    -- Name displayed when used in battle (optional)
    self.use_name = "Finest Stake"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Usr +200HP\nOth +80HP"
    -- Shop description
    self.shop = "Heals +200HP\nto the user\nand 80HP\nto everyone\nelse"
    -- Menu description
    self.description = "Wallet driller (Target +200HP, battle only others +80HP)"

    -- Amount healed (HealItem variable)
    self.heal_amount = 200
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
        susie = "Yeah, about your bank account...",
        ralsei = "Are you overspending...?",
        noelle = "That was underwhelming...",
    }
end

function item:onBattleUse(user, target)
    -- local rand_val = rander(0, 1)
    target:heal(200)
    for _, battler in ipairs(Game.battle.party) do
        if battler.chara.id ~= target.chara.id then
            battler:heal(80)
        end
    end
    if false then 
        super.onBattleUse(self, user, target)
    end
end


return item