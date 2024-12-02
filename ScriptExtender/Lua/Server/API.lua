-- initialize functions
Mods.Dialogue_Editing = Mods.Dialogue_Editing or {}

---read payload in a specific way
---@param payload table
local function AddSpecificChanges(payload)

    for key, value in pairs(payload) do

        -- Create dialogue entry if it does not exist
        if SpecificChanges[key] == nil then
            SpecificChanges[key] = {}
        end

        -- iterate through handles in that dialogue
        for key1, value1 in pairs(value) do

            -- if the handle doesn't exist create it
            if SpecificChanges[key][key1] == nil then
                SpecificChanges[key][key1] = {}
            end

            -- insert data for that dialogue and handle
            table.insert(SpecificChanges[key][key1],value1)
        end
        
    end
    
end

---Add to global dialogue changes
---@param payload table
local function AddGlobalChange(payload)
    ChangeGlobalLoca(payload)
end

-- Add functions to mod functions
Mods.Dialogue_Editing.AddGlobalChange = AddGlobalChange
Mods.Dialogue_Editing.AddSpecificChanges = AddSpecificChanges