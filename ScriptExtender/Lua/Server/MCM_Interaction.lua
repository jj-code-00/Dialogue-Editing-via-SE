-- In your MCM-integrated mod's code
Ext.ModEvents.BG3MCM["MCM_Setting_Saved"]:Subscribe(function(payload)
    if not payload or payload.modUUID ~= ModuleUUID or not payload.settingId then
        return
    end

    if payload.settingId == "dialogue_Editing_Dialog_info" then
        EnableCharacterSpecDebug = payload.value
    end

    if payload.settingId == "dialogue_Editing_Scraper" then
        EnableScraping = payload.value
    end
end)