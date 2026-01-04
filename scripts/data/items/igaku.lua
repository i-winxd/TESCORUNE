-- Instead of Item, create a HealItem, a convenient class for consumable healing items
local item, super = Class(HealItem)

function item:init()
    super.init(self)

    -- Display name
    self.name = "Igaku"
    -- Name displayed when used in battle (optional)
    self.use_name = "Igaku"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "50% chance for\n+220HP or\n-100HP"
    -- Shop description
    self.shop = "KASANE TETO"
    -- Menu description
    self.description = "50% chance to heal 220HP, 50% chance to damage user by 100HP"

    -- Amount healed (HealItem variable)
    self.heal_amount = 220
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
    self.reactions = {}
end
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
function item:onBattleUse(user, target)
    -- local rand_val = rander(0, 1)
    local igaku_rng = rander(0, 1)
    if target.chara:getHealth() >= target.chara:getMaxStats().health then 
        igaku_rng = 0.0
    end
    if igaku_rng > 0.5 then 
        local amount = 220
        target:heal(amount)
    else
        target:hurt(100, true)
    end
end

return item