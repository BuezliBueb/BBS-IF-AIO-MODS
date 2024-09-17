def pbCut
  move = :CUT
  movefinder = $Trainer.get_pokemon_with_move(move)
  if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_CUT, false)
    if $PokemonBag.pbQuantity(:MACHETE) <= 0
      pbMessage(_INTL("This tree looks like it can be cut down."))
      return false
    end
  end
  pbMessage(_INTL("This tree looks like it can be cut down!\1"))
  if pbConfirmMessage(_INTL("Would you like to cut it?"))
    speciesname = (movefinder) ? movefinder.name : $Trainer.name
    pbMessage(_INTL("{1} used {2}!", speciesname, GameData::Move.get(move).name))
    pbHiddenMoveAnimation(movefinder)
    return true
  end
  return false
end

def pbRockClimb
  return false if $game_player.pbFacingEvent
  move = :ROCKCLIMB
  movefinder = $Trainer.get_pokemon_with_move(move)
  if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_ROCKCLIMB, false)
    if $PokemonBag.pbQuantity(:CLIMBINGGEAR) <= 0
      return false
    end
  end

  if pbConfirmMessage(_INTL("It looks like it's possible to climb. Would you like to use Rock Climb?"))
    speciesname = (movefinder) ? movefinder.name : $Trainer.name
    pbMessage(_INTL("{1} used {2}!", speciesname, GameData::Move.get(move).name))
    pbHiddenMoveAnimation(movefinder)
    climbLedge
  end
end
def pbDive
  return false if $game_player.pbFacingEvent
  map_metadata = GameData::MapMetadata.try_get($game_map.map_id)
  return false if !map_metadata || !map_metadata.dive_map_id
  move = :DIVE
  movefinder = $Trainer.get_pokemon_with_move(move)
  if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_DIVE, false) || (!$DEBUG )
    if $PokemonBag.pbQuantity(:SCUBAGEAR) <= 0
      pbMessage(_INTL("The sea is deep here. A Pokémon may be able to go underwater."))
      return false
    end
  end
  if pbConfirmMessage(_INTL("The sea is deep here. Would you like to use Dive?"))
    speciesname = (movefinder) ? movefinder.name : $Trainer.name
    pbMessage(_INTL("{1} used {2}!", speciesname, GameData::Move.get(move).name))
    pbHiddenMoveAnimation(movefinder)
    pbFadeOutIn {
      $game_temp.player_new_map_id = map_metadata.dive_map_id
      $game_temp.player_new_x = $game_player.x
      $game_temp.player_new_y = $game_player.y
      $game_temp.player_new_direction = $game_player.direction
      $PokemonGlobal.surfing = false
      $PokemonGlobal.diving = true
      pbUpdateVehicle
      $scene.transfer_player(false)
      $game_map.autoplay
      $game_map.refresh
    }
    return true
  end
  return false
end
def pbRockSmash
  move = :ROCKSMASH
  movefinder = $Trainer.get_pokemon_with_move(move)
  if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_ROCKSMASH, false)
    if $PokemonBag.pbQuantity(:PICKAXE) <= 0
      pbMessage(_INTL("It's a rugged rock, but a Pokémon may be able to smash it."))
      return false
    end
  end
  if pbConfirmMessage(_INTL("This rock appears to be breakable. Would you like to use Rock Smash?"))
    speciesname = (movefinder) ? movefinder.name : $Trainer.name
    pbMessage(_INTL("{1} used {2}!", speciesname, GameData::Move.get(move).name))
    pbHiddenMoveAnimation(movefinder)
    facingEvent = $game_player.pbFacingEvent(true)
    pbSEPlay("Rock Smash", 80)
    $scene.spriteset.addUserAnimation(Settings::ROCK_SMASH_ANIMATION_ID, facingEvent.x, facingEvent.y, false)
    return true
  end
  return false
end
def pbStrength
  if $PokemonMap.strengthUsed
    #pbMessage(_INTL("Strength made it possible to move boulders around."))
    return false
  end
  move = :STRENGTH
  movefinder = $Trainer.get_pokemon_with_move(move)
  if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_STRENGTH, false)
    if $PokemonBag.pbQuantity(:LEVER) <= 0
      pbMessage(_INTL("It looks heavy, but a Pokémon may be able to push it aside."))
      return false
    end
  end
  pbMessage(_INTL("It looks heavy, but a Pokémon may be able to push it aside.\1"))
  if pbConfirmMessage(_INTL("Would you like to use Strength?"))
    speciesname = (movefinder) ? movefinder.name : $Trainer.name
    pbMessage(_INTL("{1} used {2}!", speciesname, GameData::Move.get(move).name))
    pbHiddenMoveAnimation(movefinder)
    pbMessage(_INTL("{1}'s Strength made it possible to move boulders around!", speciesname))
    $PokemonMap.strengthUsed = true
    return true
  end
  return false
end
def pbSurf
  return false if $game_player.pbFacingEvent
  return false if $game_player.pbHasDependentEvents?
  return false if $PokemonGlobal.diving || $PokemonGlobal.surfing
  move = :SURF
  movefinder = $Trainer.get_pokemon_with_move(move)
  if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_SURF, false)
    if $PokemonBag.pbQuantity(:SURFBOARD) <= 0
      return false
    end
  end
  if $PokemonSystem.quicksurf == 1
    surfbgm = GameData::Metadata.get.surf_BGM
    pbCueBGM(surfbgm, 0.5) if surfbgm
    pbStartSurfing
    return true
  end
  if pbConfirmMessage(_INTL("The water is a deep blue...\nWould you like to surf on it?"))
    speciesname = (movefinder) ? movefinder.name : $Trainer.name
    pbMessage(_INTL("{1} used {2}!", speciesname, GameData::Move.get(move).name))
    pbCancelVehicles
    pbHiddenMoveAnimation(movefinder)
    surfbgm = GameData::Metadata.get.surf_BGM
    pbCueBGM(surfbgm, 0.5) if surfbgm && !Settings::MAPS_WITHOUT_SURF_MUSIC.include?($game_map.map_id)
    pbStartSurfing
    return true
  end
  return false
end
#ModMenuCommands.register("hm",{  "parent"      => "main",  "name"        => _INTL("HM's"),  "description" => _INTL("Gives acces to Usless HM's without teaching them to Pokemon"),})
#ModMenuCommands.register("flash",{  "parent"      => "hm",  "name"        => _INTL("Flash"),  "description" => _INTL("Lights up a cave"),  "effect"      => proc{      ItemHandlers.triggerUseFromBag(GameData::Item.get(LANTERN))  }})
#ModMenuCommands.register("teleport",{  "parent"      => "hm",  "name"        => _INTL("Teleport"),  "description" => _INTL("Move around the map"),  "effect"      => proc{      ItemHandlers.triggerUseFromBag(GameData::Item.get(TELEPORTER))  }})

#ModMenuCommands.register("dreamMirror",{  "parent"      => "hm",  "name"        => _INTL("Dream Mirror"),  "description" => _INTL("Crazy what you find in the Code of these games"), "effect"      => proc    useDreamMirror  }})

def pbWaterfall
  move = :WATERFALL
  movefinder = $Trainer.get_pokemon_with_move(move)
  if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_WATERFALL, false)
    if $PokemonBag.pbQuantity(:JETPACK) <= 0
      pbMessage(_INTL("A wall of water is crashing down with a mighty roar."))
      return false
    end
  end
  if pbConfirmMessage(_INTL("It's a large waterfall. Would you like to use Waterfall?"))
    speciesname = (movefinder) ? movefinder.name : $Trainer.name
    pbMessage(_INTL("{1} used {2}!", speciesname, GameData::Move.get(move).name))
    pbHiddenMoveAnimation(movefinder)
    pbAscendWaterfall
    return true
  end
  return false
end
