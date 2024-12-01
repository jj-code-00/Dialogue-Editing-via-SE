---Function will change text globally based on being fed a table.
---@param data table
function ChangeGlobalLoca(data)
    for key, value in pairs(data) do
        Ext.Loca.UpdateTranslatedString(value["Handle"], value["Text"])
    end
end