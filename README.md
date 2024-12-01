# Dialogue Editing
Easy to use API for editing dialogue in Baldur's Gate 3 using SE. 

# Setup
Add mod as a dependency either through the toolkit, or manually using [this guide](https://wiki.bg3.community/Tutorials/General/Basic/adding-mod-dependencies) 
```...
    <children>
      <node id="Dependencies">
        <children>
          <node id="ModuleShortDesc">
              <attribute id="Folder" type="LSWString" value="Dialogue_Editing_c2d7581a-866e-b931-d772-edca7d212ec2" />
              <attribute id="MD5" type="LSString" value="" />
              <attribute id="Name" type="FixedString" value="Dialogue_Editing" />
              <attribute id="UUID" type="FixedString" value="c2d7581a-866e-b931-d772-edca7d212ec2" />
              <attribute id="Version64" type="int64" value="36028797018963974" />
          </node>
        </children>
      </node>
      <node id="ModuleInfo">
        ...
```
This is important so this mod loads before yours!

# API Information
Currently there are very few options but I will be expanding them. 

Follow this data structure for your changes.
```
local exampleGlobalTable = {

    {["Handle"] = "h7ffea567g440cg4b02g91beg56e3f41fe2bd", ["Version"] = 0, ["Text"] = "<i>Sherlock Holmes this thing.</i>"},

    {["Handle"] = "", ["Version"] = 0, ["Text"] = ""},

}
```

#### `Mods.Dialogue_Editing.AddGlobalChange(exampleGlobalTable)`

This function allows you to change dialogue handles globally. Call this function when the session is loaded for best results. 

```
local function OnSessionLoaded()
	Mods.Dialogue_Editing.AddGlobalChange(exampleGlobalTable)
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
```

This data structure is dialogueID = {Character = {Handle = text}}
```
local exampleCharacterSpecificChanges = {
        ["Elves_Female_High_Player_6e7d72d8-f54a-3351-d0b0-38cd041f2be4"] = {

            ["h7ffea567g440cg4b02g91beg56e3f41fe2bd"] = "<i>Sherlock Holmes moment.</i>",

            ["h0e1441fdg9d1eg47cag8f55g5e313e5b0f11"] = "<i>Dunk your hand in the pool.</i>",}

}
```
In the above example the dialogueID is `TUT_Start_Brinepool_279b424b-b9dd-f053-33ca-7d42969280fc`
#### `Mods.Dialogue_Editing.AddCharacterSpecificChange(dialogueID,exampleCharacterSpecificChanges)`

This should also be called at session load. 
