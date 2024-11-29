-- Example for a simple table
local exampleGlobalTable = {
    {["Handle"] = "h7ffea567g440cg4b02g91beg56e3f41fe2bd", ["Version"] = 0, ["Text"] = "<i>Sherlock Holmes this thing.</i>"},
    {["Handle"] = "", ["Version"] = 0, ["Text"] = ""},
}

---Function will change text globally based on being fed a table.
---@param data table
local function ChangeGlobalLoca(data)
    for key, value in pairs(data) do
        Ext.Loca.UpdateTranslatedString(value["Handle"], value["Text"])
    end
end

---Function called when game is loaded
local function OnSessionLoaded()

    -- uncomment to globally change text 
    -- ChangeGlobalLoca(exampleGlobalTable)
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)