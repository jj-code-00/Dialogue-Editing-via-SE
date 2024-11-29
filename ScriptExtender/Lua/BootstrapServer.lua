local function ChangeText (cachedText,text)

    for key, value in pairs(cachedText) do
        local updatedName = (text)
        Ext.Loca.UpdateTranslatedString(value["Handle"], updatedName)
        _P(Ext.Loca.GetTranslatedString(value["Handle"]))
    end
    
end

local function ScrapeDialogue()
    local dialogueManager = Ext.Utils.GetDialogManager()
    local nodes = dialogueManager.CachedDialogs[1].Nodes

    local cachedText = {}

    for key, value in pairs(nodes) do

        local parentNodes = value.ParentDialog.Nodes

        for UUID, data in pairs(parentNodes) do
            for internal, node_data in pairs(data) do
                if internal == "TaggedTexts" then
                    local handleUUID = node_data[1].Lines[1].TagText.Handle
                    local handle = handleUUID.Handle
                    local textData = Ext.Loca.GetTranslatedString(handle)

                    local found = false

                    for textInt, cachedValue in pairs(cachedText) do
                        if handleUUID == cachedValue["HandleUUID"] and textData == cachedValue["Text"] and handle == cachedValue["Handle"] then
                            found = true
                        end
                    end

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
    ChangeText (cachedText,"Testing")
end

Ext.Osiris.RegisterListener("DialogStarted", 2, "after", function(dialog, instanceID)
    ScrapeDialogue()
end)
