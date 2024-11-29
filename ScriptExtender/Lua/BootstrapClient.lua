---Find the dialogue Client-Side and dump the entire thing
local function NoesisDialogue()

    -- get main node with all UI elements
    local dialogue = Ext.UI.GetRoot():Child(1):Child(1)

    -- number of nodes under UI elements
    local numChild = dialogue.ChildrenCount

    -- variable for the dialogue UI node
    local foundDialogue = nil

    -- iterate through all children in the UI looking for the dialogue node
    for i = 1, numChild, 1 do
        local currentChild = dialogue:Child(i)
        for key, value in pairs(currentChild) do
            if key == "XAMLPath" then
                if value == "Pages/Dialogue.xaml" then
                    foundDialogue = currentChild
                end
            end
        end
    end

    local activeDialogue

    -- If the dialogue node was found grab the the active dialogue and dump all options 
    if foundDialogue ~= nil then
        activeDialogue = foundDialogue.DataContext.ActiveDialogue

        local fullDialogue = activeDialogue.GetAllProperties(activeDialogue)

        --fullDialogue.BodyText should have the text data for the speaker, and the fullDialogue.Answers[1] should have the player responses

        _D(fullDialogue)
    end
end

---Listener for server telling us there is a dialogue
Ext.RegisterNetListener("Dialogue_Client_Update", function(channel, payload, userID)

    -- wait a bit for the dialogue to populate so the UI function above can read it
    Ext.Timer.WaitFor(250, function()
        NoesisDialogue()
    end)
end)