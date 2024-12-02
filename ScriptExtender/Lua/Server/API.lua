-- initialize functions
Mods.Dialogue_Editing = Mods.Dialogue_Editing or {}

---Add to character specific dialogue changes
---@param payload table
local function AddCharacterSpecificChange(payload)

    for key, value in pairs(payload) do

        -- Create dialogue entry if it does not exist
        if CharacterSpecificChanges[key] == nil then
            CharacterSpecificChanges[key] = {}
        end

        table.insert(CharacterSpecificChanges[key],value)

    end
end

local function AddTagSpecificChanges (payload)
    for key, value in pairs(payload) do

        -- Create dialogue entry if it does not exist
        if TagSpecificChanges[key] == nil then
            TagSpecificChanges[key] = {}
        end

        table.insert(TagSpecificChanges[key],value)
    end
end

---read payload in a specific way
---@param payload table
local function AddSpecificChanges(payload)
    --_D(payload)

    --[PASSIVE], and other do it so they can have multiple changes in each one for multiple mods...
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
    --_D(SpecificChanges)
    
end

---Add to global dialogue changes
---@param payload table
local function AddGlobalChange(payload)
    ChangeGlobalLoca(payload)
end

-- Add functions to mod functions
Mods.Dialogue_Editing.AddGlobalChange = AddGlobalChange
Mods.Dialogue_Editing.AddCharacterSpecificChange = AddCharacterSpecificChange
Mods.Dialogue_Editing.AddTagSpecificChanges = AddTagSpecificChanges
Mods.Dialogue_Editing.AddSpecificChanges = AddSpecificChanges