Mods = Mods or {}
Mods.Dialogue_Editing = Mods.Dialogue_Editing or {}

local function AddGlobalChange(payload)
    ChangeGlobalLoca(payload)
end

function ChangeGlobalLoca(data)
    for _, value in pairs(data) do
        if value["Handle"] and value["Text"] then
            Ext.Loca.UpdateTranslatedString(value["Handle"], value["Text"])
        else
            Ext.Utils.PrintError("Payload faulty")
        end
    end
end

Mods.Dialogue_Editing.AddGlobalChange = AddGlobalChange