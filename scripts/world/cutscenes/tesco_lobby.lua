return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `WorldCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
    items = function(cutscene, event)
        -- Open textbox and wait for completion
        cutscene:text("* It's just a bunch of items.")
        cutscene:text("* There seems to be 10 quid here.")
        cutscene:text("* 10 quid has been added to your wallet.")
        Game.money = Game.money + 10
    end,

    ---@param cutscene WorldCutscene
    water = function(cutscene, event) 
        local susie = cutscene:getCharacter("susie")
        if susie then 
            cutscene:setSpeaker(susie)
            cutscene:text("* Does anyone want a bo'tle of wa'er?", "smile")
            -- Game:enterShop("bottle_shop")
        end
    end,
    
    ---@param cutscene WorldCutscene
    checkout = function(cutscene,event) 
        Game:enterShop("bottle_shop")
    end,

    ---@param cutscene WorldCutscene
    music = function(cutscene, event)
        -- shortens "big shot"
        cutscene:text("* Change the music?")
        cutscene:text({"* Default plays the full song in the boss section.","* Abridged is recommended if you're streaming or recording this gameplay.","* Muted completely disables music in the boss fight."})
        local choice = cutscene:choicer({"Default", "Abridged", "Muted", "Cancel selection"})
        if choice == 1 then 
            Game:setFlag("song", "normal")
            cutscene:text("* The music will play as normal.")
        elseif choice == 2 then
            Game:setFlag("song", "short")
            cutscene:text("* The music will be abridged.")
        elseif choice == 3 then
            Game:setFlag("song", "muted")
            cutscene:text("* No music will be played in the fight.")
        else
        end
    end,

    difficulty = function(cutscene, event) 
        local cur_difficulty = Game:getFlag("boss_difficulty", "normal")
        cutscene:text("* Adjust the difficulty of the boss? This impacts their damage.")
        cutscene:text("* The current difficulty is " .. cur_difficulty .. ".")
        local choice = cutscene:choicer({"Easy", "Normal", "Hard", "Cancel"})
        if choice == 1 then 
            Game:setFlag("boss_difficulty", "easy")
            cutscene:text("* The boss will deal less damage.")
        elseif choice == 2 then
            Game:setFlag("boss_difficulty", "normal")
            cutscene:text("* The boss will deal regular damage.")
        elseif choice == 3 then
            Game:setFlag("boss_difficulty", "hard")
            cutscene:text("* The boss will deal more damage.")
        else
        end



    end
    
}
