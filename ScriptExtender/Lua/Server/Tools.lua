EnableScraping = MCM.Get("dialogue_Editing_Scraper")

---TODO: scrape for skill checks as well
---Scrape and print all dialogue when dialogue is started
---@return table
local function ScrapeDialogue()

    -- grab copy of the dialogue manager
    local dialogueManager = Ext.Utils.GetDialogManager()

    -- get the path to all the dialogue nodes
    local nodes = dialogueManager.CachedDialogs[1].Nodes

    -- Table of all handle's and loca text
    local cachedText = {}

    -- iterate through all dialogue nodes
    for key, value in pairs(nodes) do

        -- get path to parent nodes (ie node containing the handle information)
        local parentNodes = value.ParentDialog.Nodes

        -- iterate through parent node data
        for UUID, data in pairs(parentNodes) do

            -- uncomment to dump all dialogue nodes
            -- _D(data)

            -- iterate through the iterated data searching for "TaggedTexts"
            for internal, node_data in pairs(data) do

                -- variable to avoid adding duplicates to our list
                local found = false
                local handleUUID
                local textData

                -- if the node contains TaggedTexts then get the handle UUID, version, and text
                if internal == "TaggedTexts" then
                    handleUUID = node_data[1].Lines[1].TagText.Handle
                    textData = Ext.Loca.GetTranslatedString(handleUUID.Handle)

                    -- iterate through list to check if we already have it
                    for textInt, cachedValue in pairs(cachedText) do
                        if handleUUID == cachedValue["HandleUUID"] and textData == cachedValue["Text"] then
                            found = true
                        end
                    end

                end

                -- if we dont then add it to our list
                if found == false and handleUUID ~= nil and textData ~= nil then
                    table.insert(cachedText,{
                        HandleUUID = handleUUID,
                        Text = textData
                    })
                end
            end
        end
    end

    -- Uncomment this to have the scraped dialogue info printed to console
    -- This is useful for finding handles so you dont change all the dialogue
    _D(cachedText)

    return cachedText
end

local depth = 0
local maxDepth = 5000
local savedHandles = {}

---Recursively attempt to get to all handles, with cycle detection
---@param dialogueManager any
---@param visited table A table to keep track of visited tables to prevent cycles
local function DeepDialogueScrape(dialogueManager, visited)

    -- If this table has already been visited, stop recursing
    if visited[dialogueManager] then
        return
    end

    -- Mark this table as visited (use table identity as key)
    visited[dialogueManager] = true
    
    for key, value in pairs(dialogueManager) do

        if key == "Handle" and type(value) == "string" and value ~= "ls::TranslatedStringRepository::s_HandleUnknown" then
            if savedHandles[value] == nil then
                savedHandles[value] = Ext.Loca.GetTranslatedString(value)
            end
        end
        if type(value) == "userdata" then 
            pcall( function() DeepDialogueScrape(value, visited) end)
        end
    end

    
    
end

--- Print current dialogue and scrape all handles and text. 
---@param dialog any
---@param instanceID any
Ext.Osiris.RegisterListener("DialogStarted", 2, "after", function(dialog, instanceID)

    if EnableCharacterSpecDebug == true then
        _P("Dialog is: " .. dialog)
    end
    if EnableScraping == true then

        local dialogueManager = Ext.Utils.GetDialogManager()

        local visted = {}

        DeepDialogueScrape(dialogueManager, visted)
        _D(savedHandles)
        savedHandles = {}
    end
    
end)