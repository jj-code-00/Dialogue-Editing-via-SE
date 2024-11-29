local exampleTable = {
    {["Handle"] = "h7ffea567g440cg4b02g91beg56e3f41fe2bd", ["Version"] = 0, ["Text"] = "<i>Sherlock Holmes this thing.</i>"}
}


---Scrape and print all dialogue when dialogue is started
---@return table
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
                    local textData = Ext.Loca.GetTranslatedString(handleUUID.Handle)

                    -- variable to avoid adding duplicates to our list
                    local found = false

                    -- iterate through list to check if we already have it
                    for textInt, cachedValue in pairs(cachedText) do
                        if handleUUID == cachedValue["HandleUUID"] and textData == cachedValue["Text"] then
                            found = true
                        end
                    end

                    -- if we dont then add it to our list
                    if found == false then
                        table.insert(cachedText,{
                            HandleUUID = handleUUID,
                            Text = textData
                        })
                    end
                end
            end
        end
    end

    -- Uncomment this to have the scraped dialogue info printed to console
    -- This is useful for finding handles so you dont change all the dialogue
    _D(cachedText)

    return cachedText
end

---Notify client a dialogue has occured
---@param character string character UUID to send the notfication
---@param text string empty string since it isn't needed in this case
local function ChangeClientDialogue(character, text)
    Ext.ServerNet.PostMessageToClient(character, "Dialogue_Client_Update", text)
end

-- Every dialogue will call above function, or notify the client about it. (CLIENT CURRENTLY IS NOT WORKING!)
Ext.Osiris.RegisterListener("DialogStarted", 2, "after", function(dialog, instanceID)
    --ScrapeDialogue()
end)

---Function will change text based on being fed a table.
---@param data table
local function ChangeLoca(data)
    for key, value in pairs(data) do
        Ext.Loca.UpdateTranslatedString(value["Handle"], value["Text"])
    end
    
end

---Function called when game is loaded
local function OnSessionLoaded()
    ChangeLoca(exampleTable)
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
