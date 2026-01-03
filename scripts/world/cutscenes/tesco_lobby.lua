return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `WorldCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
    items = function(cutscene, event)
        -- Open textbox and wait for completion
        cutscene:text("* It's just a bunch of items.")
    end,

    ---@param cutscene WorldCutscene
    water = function(cutscene, event) 
        local susie = cutscene:getCharacter("susie")
        if susie then 
            cutscene:setSpeaker(susie)
            cutscene:text("* Does anyone want a bo'tle of wa'er?", "smile")

        end
    end
    
}
