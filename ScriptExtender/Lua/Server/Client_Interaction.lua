function NotifyClientDialogueStart()
    Ext.ServerNet.PostMessageToClient(Osi.GetHostCharacter(), "Dialogue_Editing_DialogStarted", "")
end