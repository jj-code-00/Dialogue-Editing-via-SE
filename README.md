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
There are two functions to familiarize yourself with. Global changes and specific changes. Global changes are when you want a handle to be changes for everyone. Specific changes will adjust the dialogue if the initiator or speaker meets certain criteria, and removes said changes after dialogue incase another person initiates dialogue again.  

Follow this data structure for your global changes.
```
local exampleGlobalTable = {

    {["Handle"] = "h7ffea567g440cg4b02g91beg56e3f41fe2bd", ["Version"] = 0, ["Text"] = "<i>Testing Investigation.</i>"},

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

Follow this data structure for your specific changes

Currently Supported options are:

1. Specific Actors
2. Statuses
3. StatusGroups
4. Passives
5. Tags

They also are prioritized in the same order. So if you have specific changes for the same handle tags will lose to specific actor changes. 
```
local blueprint = {
    ["TUT_Start_Brinepool_279b424b-b9dd-f053-33ca-7d42969280fc"] = {
        ["h0e1441fdg9d1eg47cag8f55g5e313e5b0f11"] = {
            ["Tag"] = {
                ["HUMANOID_7fbed0d4-cabc-4a9d-804e-12ca6088a0a8"] = "<i>Dunk your HUMANOID hand in the pool.</i>"
            }
        },
        ["h7ffea567g440cg4b02g91beg56e3f41fe2bd"] = {
            ["Passive"] = {
                ["Darkvision"] = "<i>Use your DARKVISION to see.</i>"
            }
        }
    },
    [dialog] = {
        [handle] = {
            ["Actor"/"Status"/"StatusGroup"/"Passive"/"Tag"] = {
                [identifier] = "Text"
            }
        },
        ...
    },
}
```

#### `Mods.Dialogue_Editing.AddSpecificChanges(blueprint)`

This should also be called at session load. 

# Tools
The mod includes a dialogue scraper and other information that will be dumped to the console if enabled in the MCM. 

These are useful for getting Handles, actor information, Text data, and eventually things like skills rolls, etc.

# Resources
[Datamined dialogue](https://www.tumblr.com/roksik-dnd/727481314781102080/bg3-datamined-dialogue-google-drive): Some more dialogue info. 

Moxifier's [Github](https://github.com/Moxifer/bg3-dialog-timeline-edits/tree/main): They have done more extensive dialogue editing and their repo can be a good example for more advanced usages beyond this mod. 

# Credits
[Moxifier](https://next.nexusmods.com/profile/moxifer3/mods?gameId=3474) for allowing me to link their resources.

wtfbengt on discord for giving me an example on how the API for SE works. 

[DIQ Discord](https://discord.gg/baldursgoonsacks) for all the help the modders there have given me. 

# Full Example BootstrapServer.lua
```
-- Dialog -> handle -> type of change -> identifier -> text
local blueprint = {
    ["TUT_Start_Brinepool_279b424b-b9dd-f053-33ca-7d42969280fc"] = {
        ["h0e1441fdg9d1eg47cag8f55g5e313e5b0f11"] = {
            ["Tag"] = {
                ["HUMANOID_7fbed0d4-cabc-4a9d-804e-12ca6088a0a8"] = "<i>Dunk your HUMANOID hand in the pool.</i>"
            }
        },
        ["h7ffea567g440cg4b02g91beg56e3f41fe2bd"] = {
            ["Passive"] = {
                ["Darkvision"] = "<i>Use your DARKVISION to see.</i>"
            }
        }
    }
}

local exampleGlobalTable = {
    {["Handle"] = "h3f81570cgbcabg44bcga4dag920858a3db5e", ["Version"] = 0, ["Text"] = "<i>Bro I'm stuck.</i>"}, 
}



---Run both functions on session load
local function OnSessionLoaded()

    Mods.Dialogue_Editing.AddGlobalChange(exampleGlobalTable)

    Mods.Dialogue_Editing.AddSpecificChanges(blueprint)
	
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
```