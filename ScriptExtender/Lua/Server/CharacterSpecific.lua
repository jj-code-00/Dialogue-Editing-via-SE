-- example table for dialog specific changes. 
local characterSpecificChanges = {
    ["TUT_Start_Brinepool_279b424b-b9dd-f053-33ca-7d42969280fc"] = {
        ["Elves_Female_High_Player_6e7d72d8-f54a-3351-d0b0-38cd041f2be4"] = {
            ["h7ffea567g440cg4b02g91beg56e3f41fe2bd"] = "<i>Sherlock Holmes moment.</i>",
            ["h0e1441fdg9d1eg47cag8f55g5e313e5b0f11"] = "<i>Dunk your hand in the pool.</i>",}}
}

local originals = {
}

local enabled = false

---TODO
---Listen for dialogue beginning to grab any changes for the speaker or responder
---This will only change the text IF a certain character is the one to initiate the conversation. Use it as an example.
---@param dialog any
---@param instanceID any
---@param actor any
---@param speakerIndex any
Ext.Osiris.RegisterListener("DialogActorJoined", 4, "after", function(dialog, instanceID, actor, speakerIndex)

    if enabled == true then
        -- Print actor for testing
        _P("Actor: " .. actor)

        -- grab this particular dialog's entry in table
        local dialogue = characterSpecificChanges[dialog]

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
    end

end)

---TODO
---Reset dialogue after the character leaves. Making it so if another person initiates said dialogue it is back to normal. 
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

                    -- Uncomment for debugging
                    -- _P("Reverted Text back to: " .. Ext.Loca.GetTranslatedString(data["Handle"]))
                end
            end
        end
    end
end)