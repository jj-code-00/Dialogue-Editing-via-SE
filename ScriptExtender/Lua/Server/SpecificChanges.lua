EnableCharacterSpecDebug = MCM.Get("dialogue_Editing_Dialog_info")

--Copies of handle and text before changes
local originals = {}

SpecificChanges = {}

---Reset specific dialogue after the character leaves. Making it so if another person initiates said dialogue it is back to normal. 
---@param dialog any
---@param instanceID any
---@param actor any
---@param instanceEnded any
Ext.Osiris.RegisterListener("DialogActorLeft", 4, "after", function(dialog, instanceID, actor, instanceEnded)

    -- iterate through list of changed text
    for key, value in pairs(originals) do

        -- grab entry
        local data = value[1]

        -- Get Dialog 
        local dialogID = data["Dialog"]

        -- See if the currently left dialog is the same
        if dialogID == dialog then

            -- get instanceID
            local InstanceID = data["InstanceID"]

            -- see if the instanceID is the same
            if InstanceID == instanceID then

                -- get actor
                local Actor = data["Actor"]

                -- see if the Actor leaving is the same as the one that started it
                if Actor == actor then

                    -- update handle back to saved original value
                    Ext.Loca.UpdateTranslatedString(data["Handle"], data["Text"])

                    -- clear said value from our table to save space
                    originals[key] = nil

                    if EnableCharacterSpecDebug == true then
                        _P("Reverted Text back to: " .. Ext.Loca.GetTranslatedString(data["Handle"]))
                    end
                end
            end
        end
    end
end)

---Save original handle and text before changing it to new updated version
---@param dialog any
---@param instanceID any
---@param actor any
---@param key any
---@param value any
local function SaveAndUpdate(dialog,instanceID,actor,key,value)

    -- Get the data of the text before we change it
    local originalData = {
        {["Dialog"] = dialog, ["InstanceID"] = instanceID, ["Actor"] = actor, ["Handle"] = key, ["Text"] = Ext.Loca.GetTranslatedString(key)}
    }
    -- insert original text so we can revert the changes
    table.insert(originals,originalData)

    -- change text to our changed version
    Ext.Loca.UpdateTranslatedString(key, value)
    
end

---Listen for dialogue beginning to grab any changes for the speaker or responder
---This will only change the text IF a certain character is the one to initiate the conversation. Use it as an example.
---@param dialog any
---@param instanceID any
---@param actor any
---@param speakerIndex any
Ext.Osiris.RegisterListener("DialogActorJoined", 4, "after", function(dialog, instanceID, actor, speakerIndex)

    if EnableCharacterSpecDebug == true then
         -- Print actor for testing
        _P("Actor: " .. actor)
    end

    -- grab this particular dialog's entry in table and see if it is nil
    local dialogue = {}

    if SpecificChanges[dialog] ~= nil then
        dialogue = SpecificChanges[dialog]
    end

    -- make sure it isnt nil
    if dialogue ~= nil and next(dialogue) ~= nil then

        --_D(dialogue)

        -- check if current actor is either the one talking, or responding.
        if speakerIndex == 1 or speakerIndex == 0 then

            -- iterate table of handles and text resplacements
            for handle, table in pairs(dialogue) do

                local identifier = table[1]

                -- get the character and see if they have the tag
                local character = string.sub(actor,-36)
            
                if identifier["Actor"] ~= nil then
                    
                    for key, value in pairs(identifier["Actor"]) do
                        if key == actor then
                            SaveAndUpdate(dialog,instanceID,actor,handle,value)
                        end
                    end
                    
                elseif identifier["Status"] ~= nil then
                    for key, value in pairs(identifier["Status"]) do
                        if Osi.HasActiveStatus(character,key) == 1 then
                            SaveAndUpdate(dialog,instanceID,actor,handle,value)
                        end
                    end
                elseif identifier["StatusGroup"] ~= nil then

                    for key, value in pairs(identifier["StatusGroup"]) do
                        if Osi.HasActiveStatusWithGroup(character,key) == 1 then
                            SaveAndUpdate(dialog,instanceID,actor,handle,value)
                        end
                    end
                elseif identifier["Passive"] ~= nil then
                    for key, value in pairs(identifier["Passive"]) do
                        if Osi.HasPassive(character,key) == 1 then
                            SaveAndUpdate(dialog,instanceID,actor,handle,value)
                        end
                    end
                elseif identifier["Tag"] ~= nil then
                    for key, value in pairs(identifier["Tag"]) do
                        if Osi.IsTagged(character,key) == 1 then
                            SaveAndUpdate(dialog,instanceID,actor,handle,value)
                        end
                    end
                else
                    _P("Error in SpecificChanges table.")
                end
            end
        end
    end

end)