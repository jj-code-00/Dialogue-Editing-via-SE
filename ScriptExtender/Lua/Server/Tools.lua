EnableScraping = MCM.Get("dialogue_Editing_Scraper")

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
    
    -- iterate through current object
    for key, value in pairs(dialogueManager) do

        -- if key is handle and the value is a string check if we've saved it, and if not add it to saved handles table
        if key == "Handle" and type(value) == "string" and value ~= "ls::TranslatedStringRepository::s_HandleUnknown" then
            if savedHandles[value] == nil then
                savedHandles[value] = Ext.Loca.GetTranslatedString(value)
            end
        end

        -- if the type is userdata, IE generally a table, do a protected recursive call. Protected is needed so when the userdata is not a table type structure it doesn't error out
        if type(value) == "userdata" then 
            pcall( function() DeepDialogueScrape(value, visited) end)
        end
    end
    
end

---Scrape and print all dialogue when dialogue is started
local function ScrapeDialogue()
    
    -- scrape the dialogue manager for handles and save them to savedHandles
    DeepDialogueScrape(Ext.Utils.GetDialogManager(), {})

    -- dump handles and text for development
    _D(savedHandles)

    -- clear table to save space and ensure each call of this function has an empty table to work with
    savedHandles = {}
end

--- Print current dialogue and scrape all handles and text. 
---@param dialog any
---@param instanceID any
Ext.Osiris.RegisterListener("DialogStarted", 2, "after", function(dialog, instanceID)

    -- IF character spec debug is true print basic info
    if EnableCharacterSpecDebug == true then
        _P("Dialog is: " .. dialog)
    end

    -- if scraper is true print all handles and text
    if EnableScraping == true then
        ScrapeDialogue()
    end

    -- NotifyClientDialogueStart()
    
end)