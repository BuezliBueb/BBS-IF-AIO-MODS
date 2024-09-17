ModMenuCommands.register("abilityrandomizer",{
  "parent"      => "main",
  "name"        => _INTL("abilityrandomizer"),
  "description" => _INTL("abilityrandomizer"),
})
ModMenuCommands.register("initialize",{
  "parent"      => "abilityrandomizer",
  "name"        => _INTL("Initialize Stuff"),
  "description" => _INTL("First time per save"),
  "effect"      => proc{
    BAN_WONDER_GUARD = 1500
    $game_switches[BAN_WONDER_GUARD] = false
    BAN_USLESS_ABILITIES = 1501
    $game_switches[BAN_USLESS_ABILITIES] = false
  }
})
ModMenuCommands.register("banWonderguard",{
    "parent"      => "abilityrandomizer",
    "name"        => _INTL("Ban Wonderguard"),
    "description" => _INTL("Ban Wonderguards"),
    "effect"      => proc{
      $game_switches[BAN_WONDER_GUARD] = true
    }
})
ModMenuCommands.register("banUsles",{
    "parent"      => "abilityrandomizer",
    "name"        => _INTL("Ban Usless Abilities"),
    "description" => _INTL("Bans Abilities Like Plus, Truant, Pickpocket"),
    "effect"      => proc{
      $game_switches[BAN_USLESS_ABILITIES] = true
    }
})
#ModMenuCommands.register("randomizeAbilities",{  "parent"      => "main",  "name"        => _INTL("Rerandomize Abilities"),  "description" => _INTL("Rerandomizing your abilities or restoring original abilities (Already caught Pokemon will still have random abilities)"),})

ModMenuCommands.register("rerandomizeAbilities",{
  "parent"      => "abilityrandomizer",
  "name"        => _INTL("Rerandomize Abilities"),
  "description" => _INTL("when the mod bugs out and mons get their original ability"),
  "effect"      => proc{
      trainer = $Trainer
      file = "0"
      if trainer
        meta = $Trainer.save_slot
        if meta
          file = (pbGetPlayerCharset(meta,1,trainer,true))
          file = file[1,file.length]
        end
      end
      GameData::AbilityRandom::DATA.clear()
      abilityRandomMain
      GameData::AbilityRandom.save
      Graphics.update
      GameData::AbilityRandom.load
  }
})
ModMenuSettingsCommands.register("unAbilities",{
  "parent"      => "abilityrandomizer",
  "name"        => _INTL("Restore Original Abilities"),
  "description" => _INTL("This mod does only temporarily overwrites the original Abilities, however, other mods can accidentaly save the Abilities permanently for all saves to follow"),
  "effect"      => proc{
  abilityRandomMain
  #AbilityRandom.each {|a| a.setValues2()}  }
}})
