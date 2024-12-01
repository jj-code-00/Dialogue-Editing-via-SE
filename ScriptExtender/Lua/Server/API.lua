-- initialize functions
Mods.Dialogue_Editing = Mods.Dialogue_Editing or {}

---Add to character specific dialogue changes
---@param payload table
local function AddCharacterSpecificChange(dialogueID,payload)

    if CharacterSpecificChanges[dialogueID] == nil then
        CharacterSpecificChanges[dialogueID] = {}
    end

    table.insert(CharacterSpecificChanges[dialogueID],payload)
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