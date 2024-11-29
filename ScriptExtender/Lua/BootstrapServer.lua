
---Scrape and print all dialogue when dialogue is started
local function ScrapeDialogue()

    -- grab copy of the dialogue manager
    local dialogueManager = Ext.Utils.GetDialogManager()

    -- get the path to all the dialogue nodes
    local nodes = dialogueManager.CachedDialogs[1].Nodes

    -- _D(nodes)

    -- Table of all handle's and loca text
    local cachedText = {}

    -- iterate through all dialogue nodes
    for key, value in pairs(nodes) do

        -- get path to parent nodes (ie node containing the handle information)
        local parentNodes = value.ParentDialog.Nodes

        -- iterate through parent node data
        for UUID, data in pairs(parentNodes) do

            -- iterate through the iterated data searching for "TaggedTexts"
            for internal, node_data in pairs(data) do

                -- if the node contains TaggedTexts then get the handle UUID, version, and text
                if internal == "TaggedTexts" then
                    local handleUUID = node_data[1].Lines[1].TagText.Handle
                    local handle = handleUUID.Handle
                    local textData = Ext.Loca.GetTranslatedString(handle)

                    -- variable to avoid adding duplicates to our list
                    local found = false

                    -- iterate through list to check if we already have it
                    for textInt, cachedValue in pairs(cachedText) do
                        if handleUUID == cachedValue["HandleUUID"] and textData == cachedValue["Text"] and handle == cachedValue["Handle"] then
                            found = true
                        end
                    end

                    -- if we dont then add it to our list
                    if found == false then
                        table.insert(cachedText,{
                            HandleUUID = handleUUID,
                            Handle = handle,
                            Text = textData
                        })
                    end
                end
            end
        end
    end

    -- Uncomment this to have the scraped dialogue info printed to console
    -- This is useful for finding handles so you dont change all the dialogue
    -- _D(cachedText)

    -- This is where you actually change the text. Use the information in the cachedText list to do this.
    --WARNING!!! If you take too long to change the text it will NOT appear in game. If you do another nested for loop, even if it is only one element, it will not work. 
    for key, value in pairs(cachedText) do

        -- variable for the actual text
        local updatedName = ("Test")

        -- Update the text (Ideally you would have some kind of check to determine if the character in dialogue needs the text changes)
        -- Uncomment it to have the handles be updated
        -- Ext.Loca.UpdateTranslatedString(value["Handle"], updatedName)
        -- Debug function to print to ensure the handle was changed correctly
        -- _P(Ext.Loca.GetTranslatedString(value["Handle"]))
    end
end

---Notify client a dialogue has occured
---@param character string character UUID to send the notfication
---@param text string empty string since it isn't needed in this case
local function ChangeClientDialogue(character, text)
    Ext.ServerNet.PostMessageToClient(character, "Dialogue_Client_Update", text)
end

-- Every dialogue will call above function, or notify the client about it. 
Ext.Osiris.RegisterListener("DialogStarted", 2, "after", function(dialog, instanceID)
    -- ScrapeDialogue()
    ChangeClientDialogue(Osi.GetHostCharacter(), "")
end)
