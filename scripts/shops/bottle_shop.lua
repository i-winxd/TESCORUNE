local BottleShop, super = Class(Shop)
local pm = 1
function BottleShop:init()
    super.init(self)
    self:registerItem("bottle_water", {price=0*pm})
    self:registerItem("coffee", {price=80*pm})
    self:registerItem("medium_sliced_bread", {price=120*pm})
    self:registerItem("salted_block_butter", {price=120*pm})
    self:registerItem("igaku", {price=270*pm})
    self:registerItem("ham_cheddar_sandwich", {price=330*pm})
    self:registerItem("finest_steak", {price=700*pm})
    self.sell_text = "Return complete."
    self.buy_confirmation_text = "Please\nconfirm"
    self.buy_too_expensive_text = "Insufficient\nfunds"
    self.shop_text = "Search for items"
    self.hide_world = false
    self.buy_refuse_text = "Consider our other items."
    self.buy_text = "Thank you for shopping at Tesco."
    self.encounter_text = "Welcome to the self checkout"
    self.sell_menu_text = "Want to return something?"
    self.sell_refuse_text = "Maybe something else?"
    self.leaving_text = "Thanks for shopping with us."
    self.buy_menu_text = "Place this item in your bag."
    self.sell_confirmation_text = "You sure?"
    self.sell_nothing_text = "Nothing to return."
    self.sell_no_price_text = "We do not accept this."
    self.sell_no_storage_text = "Nothing to return."
    self.sell_menu_text = "What do you want to return?"
    self.sell_options_text = {}
    self.sell_options_text["items"]   = "Items to return?"
    self.sell_options_text["weapons"] = "Weapons to return?"
    self.sell_options_text["armors"]  = "Armor to return?"
    self.sell_options_text["storage"] = "Storage to return?"
    self.talk_text = ""
    self.currency_text = "£ %d"
    self.background = "battle_bg/tesco_bg"
end

return BottleShop