EnableCharacterSpecDebug = MCM.Get("dialogue_Editing_Debug")

--Copies of handle and text before changes
local originals = {}

--table that character changes are added to
CharacterSpecificChanges = {}

---TODO
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

    -- grab this particular dialog's entry in table
    local dialogue = CharacterSpecificChanges[dialog]

    if dialogue ~= nil then
        dialogue = CharacterSpecificChanges[dialog][1]
    end

    -- make sure it isnt nil
    if dialogue ~= nil then

        -- check if current actor is in table, and is either the one talking, or responding. (Probably only need to check for 1 not 0)
        -- Character is just an example. Something like checking for tags or passives would be more appropriate
        -- keep in mind the actor is both the roottemplate name + the UUID so you will need to separate them to use in most Osi functions
        if dialogue[actor] ~= nil and (speakerIndex == 1 or speakerIndex == 0) then

            -- iterate table of handles and text resplacements
            for key, value in pairs(dialogue[actor]) do

                -- Get the data of the text before we change it
                local originalData = {
                    {["Dialog"] = dialog, ["InstanceID"] = instanceID, ["Actor"] = actor, ["Handle"] = key, ["Text"] = Ext.Loca.GetTranslatedString(key)}
                }
                -- insert original text so we can revert the changes
                table.insert(originals,originalData)

                -- change text to our changed version
                Ext.Loca.UpdateTranslatedString(key, value)
            end
        end
    end

end)

---TODO
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

-- Osi.HasPassive(entity, passiveID) Osi.HasActiveStatus(target, status)

TagSpecificChanges = {}

---TODO
---Change dialogue based on tags
---This will only change the text IF a certain character is the one to initiate the conversation. Use it as an example.
---@param dialog any
---@param instanceID any
---@param actor any
---@param speakerIndex any
Ext.Osiris.RegisterListener("DialogActorJoined", 4, "after", function(dialog, instanceID, actor, speakerIndex)

    -- grab this particular dialog's entry in table
    local dialogue = TagSpecificChanges[dialog]

    if dialogue ~= nil then
        dialogue = TagSpecificChanges[dialog][1]
    end

    -- make sure it isnt nil
    if dialogue ~= nil then

        -- check if current actor is either the one talking, or responding. (Probably only need to check for 1 not 0)
        if speakerIndex == 1 or speakerIndex == 0 then

            -- iterate tags with changes in this dialogue
            for key, value in pairs(dialogue) do

                -- get the character and see if they have the tag
                local character = string.sub(actor,-36)

                -- if they do iterate through the tags changes
                if Osi.IsTagged(character, key) == 1 then
                    for k, v in pairs(dialogue[key]) do

                        -- Get the data of the text before we change it
                        local originalData = {
                            {["Dialog"] = dialog, ["InstanceID"] = instanceID, ["Actor"] = actor, ["Handle"] = key, ["Text"] = Ext.Loca.GetTranslatedString(key)}
                        }

                        -- insert original text so we can revert the changes
                        table.insert(originals,originalData)

                        -- change text to our changed version
                        Ext.Loca.UpdateTranslatedString(k, v)
                    end
                end             
            end
        end
    end
end)