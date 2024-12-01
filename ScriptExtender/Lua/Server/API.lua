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
    
    _D(CharacterSpecificChanges)
end

---Add to global dialogue changes
---@param payload table
local function AddGlobalChange(payload)
    ChangeGlobalLoca(payload)
end

-- Add functions to mod functions
Mods.Dialogue_Editing.AddGlobalChange = AddGlobalChange
Mods.Dialogue_Editing.AddCharacterSpecificChange = AddCharacterSpecificChange