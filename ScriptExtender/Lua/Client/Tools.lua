-- ---Find the dialogue Client-Side and dump the entire thing
-- local function NoesisDialogue()

--     local UIRoot = Ext.UI.GetRoot()

--     -- get main node with all UI elements
--     local UI = UIRoot:Child(1):Child(1)

--     -- number of nodes under UI elements
--     local numChild = UI.ChildrenCount

--     -- variable for the dialogue UI node
--     local foundDialogue = nil

--     -- iterate through all children in the UI looking for the dialogue node
--     for i = 1, numChild, 1 do
--         local currentChild = UI:Child(i)
--         for key, value in pairs(currentChild) do
--             if key == "XAMLPath" then
--                 if value == "Pages/Dialogue.xaml" then
--                     foundDialogue = currentChild
--                 end
--             end
--         end
--     end

--     local activeDialogue

--     -- If the dialogue node was found grab the the active dialogue and dump all options 
--     if foundDialogue ~= nil then
--         activeDialogue = foundDialogue.DataContext.ActiveDialogue
--         -- _D(activeDialogue)

--         local fullDialogue = activeDialogue.GetAllProperties(activeDialogue)

--         --fullDialogue.BodyText should have the text data for the speaker, and the fullDialogue.Answers[1] should have the player responses
--         -- _D(fullDialogue)
--         for key, value in pairs(fullDialogue.Answers) do
--             -- _D(value)
--             local playerChoices = value.GetAllProperties(value)
--             --_D(playerChoices)

--             local test = playerChoices.CtxAnswer.Params[1]
--             local testType = test.TypeInfo(test)
--             -- _D(testType)
--             if testType.Name == "ls.VMContextTransStringParam" then
--                 -- 
--                 for _key , _value in pairs(testType) do

--                     -- _D(_key)
--                     local testing = _value

--                     -- _P(type(testing))
--                     if type(testing) == "userdata" then
--                         if _key == "Properties" then
--                             for key1, value1 in pairs(testing) do
--                                 value1.IsReadOnly = false
--                                 -- _D(testType)
--                                 -- test.SetProperty(test,"Enabled", "false")
--                             end
--                         end
                        
--                         -- _P("Here")
--                         -- for key__, value__ in pairs(testing) do
--                         --     -- _P(key__)
--                         --     if key__ == "Properties" then

--                         --         _D(testing[key__])
--                         --         -- _P("Hello")
--                         --         -- _D(value__[1])
--                         --         -- for k, v in pairs(value__) do
--                         --         --     _P(v)
--                         --         -- end
--                         --     end
--                         -- end
--                     end
--                     --local read = testing.IsReadOnly
--                     --_D(read)
--                 end
--                 -- testing = false
--                 -- _P(testing)
--             end

--             -- test.SetProperty(test,"Text","Testing")
--             -- _D(test)
--             -- local testData = test.GetAllProperties(test)
--             -- _D(testData)
--             -- value.SetProperty(value, "BodyText", value.BodyText)
--             -- _D(playerChoices)
--             -- UIRoot:SetProperty("BodyText",fullDialogue)
--             -- _D(playerChoices)
--             value.CtxAnswer.Params[1].SetProperty(value.CtxAnswer.Params[1],"Text","testing")
--         end
        

--     end
-- end

---Recursively search through entire UI
---@param node any
---@param visited table
local function DeepSearchUI(node,visited,lastData)

    -- If this table has already been visited, stop recursing
    if visited[node] or node == nil then
        return
    end

    -- Mark this table as visited (use table identity as key)
    visited[node] = true

   --_D(node)

   if type(node) == "userdata" then
        lastData = node
        -- iterate through current object
        for key, value in pairs(node) do

            -- if the type is userdata, IE generally a table, do a protected recursive call. Protected is needed so when the userdata is not a table type structure it doesn't error out
            if type(value) == "userdata" then 
                _P(key)
                _D(value)
                pcall( function() DeepSearchUI(value, visited,lastData) end)
            elseif type(value) == "function" then
                if key == "GetAllProperties" then
                    pcall( function() DeepSearchUI(lastData.GetAllProperties(lastData), visited,lastData) end)
                elseif key == "Child" then
                    for i = 1, lastData.ChildrenCount, 1 do
                        pcall( function() DeepSearchUI(lastData:Child(i), visited,lastData) end)
                    end
                end
            end
        end
   end
    
end

---Call DeepSearchUI after a short pause feeding it the UI root
local function CallDeepSearchUI()

    -- wait a beat for the dialogue to populate so the UI function called can read it
    Ext.Timer.WaitFor(250, function()
        DeepSearchUI(Ext.UI.GetRoot(),{},Ext.UI.GetRoot())
    end)
end

---Listener for server telling us there is a dialogue
Ext.RegisterNetListener("Dialogue_Editing_DialogStarted", function(channel, payload, userID)
    CallDeepSearchUI()
end)