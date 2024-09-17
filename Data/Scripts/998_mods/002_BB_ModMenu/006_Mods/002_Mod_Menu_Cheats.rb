module GameData
  class GrowthRate
    def add_exp(exp1, exp2)
      ret =  Settings::LEVEL_CAPS[$Trainer.badge_count]
      if $game_switches[SWITCH_GAME_DIFFICULTY_HARD]
        ret =  Settings::LEVEL_CAPS[$Trainer.badge_count] * Settings::HARD_MODE_LEVEL_MODIFIER
      end
      if  CHEATS["EXPBOOST"]
        return (minimum_exp_for_level(ret.to_f.ceil.to_i)).clamp(1, maximum_exp) + 1
      else
        return (exp1 + exp2).clamp(0, maximum_exp)
      end
    end
  end
end
class Game_Map
  def debugMapEvent
    for i in @map.events.keys
      event = @map.events[1]
    end
  end
end
ModMenuCommands.register("cheats",{
  "parent"      => "main",
  "name"        => _INTL("Quality of life"),
  "description" => _INTL("Bunch of QOL"),
})
ModMenuCommands.register("EXP",{
    "parent"      => "cheats",
    "name"        => _INTL("EXP Boost"),
    "description" => _INTL("Get a massive EXP boost"),
    "effect"      => proc{
      CHEATS["EXPBOOST"] = !CHEATS["EXPBOOST"]
      if CHEATS["EXPBOOST"]
        pbMessage("Enabled")
      else
        pbMessage("Disabled")
      end
    }
    })
    ModMenuCommands.register("Catch",{
    "parent"      => "cheats",
    "name"        => _INTL("Always Catch"),
    "description" => _INTL("Always Catch"),
    "effect"      => proc{

    CHEATS["CATCH"] = !CHEATS["CATCH"]
      if CHEATS["CATCH"]
        pbMessage("Enabled")
      else
        pbMessage("Disabled")
      end
    }})
ModMenuCommands.register("debugger",{
  "parent"      => "cheats",
  "name"        => _INTL("Debug mode"),
  "description" => _INTL("Enables Debug mode"),
  "effect"      => proc{
    $DEBUG = !$DEBUG
  }
  })
ModMenuCommands.register("starterpack",{
  "parent"      => "cheats",
  "name"        => _INTL("Starterpack"),
  "description" => _INTL("Add some Starting Items to your Bag"),
})
  ModMenuCommands.register("starterpackall",{
      "parent"      => "starterpack",
      "name"        => _INTL("Startepack Full"),
      "description" => _INTL("Adds Rarecandy, Balls, Repel, Evo Items and other Usefull Items to your bag"),
      "effect"      => proc{
        pbPlayDecisionSE
        itemHash = [[:RARECANDY, 999], [:QUICKBALL, 999], [:POKEBALL, 999], [:GREATBALL, 999],
        [:ULTRABALL, 999], [:MAXREPEL, 999], [:TELEPORTER, 1], [:LANTERN, 1], [:WATERSTONE, 10],
        [:LEAFSTONE, 10], [:SUNSTONE, 10], [:MOONSTONE, 10], [:THUNDERSTONE, 10], [:FIRESTONE, 10],
        [:DAWNSTONE, 10], [:SHINYSTONE, 10], [:MAGNETSTONE, 10], [:ITEMFINDER, 1], [:ESCAPEROPE, 100],
        [:SOOTHEBELL, 10], [:PPMAX, 10], [:INFINITEREVERSERS, 1], [:INFINITESPLICERS, 1]]
        for item, count in itemHash
          $PokemonBag.pbStoreItem(item, count - pbQuantity(item))
        end
      }
})
  ModMenuCommands.register("starterpackRC",{
      "parent"      => "starterpack",
      "name"        => _INTL("Rarecandy"),
      "description" => _INTL("Adds Rarecandy to your bag"),
      "effect"      => proc{
        pbPlayDecisionSE
        $PokemonBag.pbStoreItem(:RARECANDY, 999 - pbQuantity(item))
      }
})
	ModMenuCommands.register("starterpackballs",{
	  "parent"      => "starterpack",
	  "name"        => _INTL("Pokeballs"),
	  "description" => _INTL("Choose what Balls added to your Bag"),
	})
	ModMenuCommands.register("starterpackall",{
		  "parent"      => "starterpackballs",
		  "name"        => _INTL("All"),
		  "description" => _INTL("Adds Pokeballs, Greatballs, Ultraballs, Fastballs to your bag"),
		  "effect"      => proc{
			pbPlayDecisionSE
			itemHash = [[:QUICKBALL, 999], [:POKEBALL, 999], [:GREATBALL, 999],
			[:ULTRABALL, 999]]
			for item, count in itemHash
			  $PokemonBag.pbStoreItem(item, count - pbQuantity(item))
			end
		  }
	})
  ModMenuCommands.register("starterpackpkb",{
      "parent"      => "starterpackballs",
      "name"        => _INTL("Pokeball"),
      "description" => _INTL("Adds Pokeballs to your bag"),
      "effect"      => proc{
        pbPlayDecisionSE
        $PokemonBag.pbStoreItem(:POKEBALL, 999 - pbQuantity(item))
      }
})
  ModMenuCommands.register("starterpackgb",{
      "parent"      => "starterpackballs",
      "name"        => _INTL("Greatball"),
      "description" => _INTL("Adds Pokeballs to your bag"),
      "effect"      => proc{
        pbPlayDecisionSE
        $PokemonBag.pbStoreItem(:GREATBALL, 999 - pbQuantity(item))
      }
})
  ModMenuCommands.register("starterpackub",{
      "parent"      => "starterpackballs",
      "name"        => _INTL("Ultraball"),
      "description" => _INTL("Adds Pokeballs to your bag"),
      "effect"      => proc{
        pbPlayDecisionSE
        $PokemonBag.pbStoreItem(:ULTRABALL, 999 - pbQuantity(item))
      }
})
  ModMenuCommands.register("starterpackfb",{
      "parent"      => "starterpackballs",
      "name"        => _INTL("Quickball"),
      "description" => _INTL("Adds Pokeballs to your bag"),
      "effect"      => proc{
        pbPlayDecisionSE
        $PokemonBag.pbStoreItem(:QUICKBALL, 999 - pbQuantity(item))
      }
})
  ModMenuCommands.register("starterpackevo",{
      "parent"      => "starterpack",
      "name"        => _INTL("Evo Stones"),
      "description" => _INTL("Adds Evo Stones to your bag"),
      "effect"      => proc{
        pbPlayDecisionSE
        itemHash = [[:WATERSTONE, 10],
        [:LEAFSTONE, 10], [:SUNSTONE, 10], [:MOONSTONE, 10], [:THUNDERSTONE, 10], [:FIRESTONE, 10],
        [:DAWNSTONE, 10], [:SHINYSTONE, 10], [:MAGNETSTONE, 10], [:SOOTHEBELL, 10]]
        for item, count in itemHash
          $PokemonBag.pbStoreItem(item, count - pbQuantity(item))
        end
      }
})
  ModMenuCommands.register("starterpacksplicers",{
      "parent"      => "starterpack",
      "name"        => _INTL("Splicers"),
      "description" => _INTL("Adds Splicers to your bag"),
      "effect"      => proc{
        pbPlayDecisionSE
        $PokemonBag.pbStoreItem(:INFINITEREVERSERS, 1 - pbQuantity(item))
        $PokemonBag.pbStoreItem(:INFINITESPLICERS, 1 - pbQuantity(item))
      }
})
  ModMenuCommands.register("starterpackother",{
      "parent"      => "starterpack",
      "name"        => _INTL("Other"),
      "description" => _INTL("Adds Repel, PPMax, Escaperope to your bag"),
      "effect"      => proc{
        pbPlayDecisionSE
        pbPlayDecisionSE
        itemHash = [[:MAXREPEL, 999], [:ESCAPEROPE, 100], [:PPMAX, 10]]
        for item, count in itemHash
          $PokemonBag.pbStoreItem(item, count - pbQuantity(item))
        end
      }
})
  ModMenuCommands.register("starterpackhm",{
      "parent"      => "starterpack",
      "name"        => _INTL("Key Items"),
      "description" => _INTL("Adds Teleporter, Lantern, Itemfinder to your bag"),
      "effect"      => proc{
        pbPlayDecisionSE
        itemHash = [[:TELEPORTER, 1], [:LANTERN, 1], [:ITEMFINDER, 1]]
        for item, count in itemHash
          $PokemonBag.pbStoreItem(item, count - pbQuantity(item))
        end
      }
})
ModMenuCommands.register("difficulty",{
  "parent"      => "cheats",
  "name"        => _INTL("Difficulty Hard"),
  "description" => _INTL("Sets difficulty to hard"),
  "effect"      => proc{
  $game_switches[SWITCH_GAME_DIFFICULTY_HARD] = true
  }
})
  module BallHandlers

    def self.isUnconditional?(ball,battle,battler)
      ret = IsUnconditional.trigger(ball,battle,battler)
      return (ret!=nil) ? ret : CHEATS["CATCH"]
    end
  end


  def pbGainExpOne(idxParty, defeatedBattler, numPartic, expShare, expAll, showMessages = true)
    pkmn = pbParty(0)[idxParty] # The Pokémon gaining EVs from defeatedBattler
    growth_rate = pkmn.growth_rate
    # Don't bother calculating if gainer is already at max Exp
    if pkmn.exp >= growth_rate.maximum_exp
      pkmn.calc_stats # To ensure new EVs still have an effect
      return
    end
    isPartic = defeatedBattler.participants.include?(idxParty)
    hasExpShare = expShare.include?(idxParty)
    level = defeatedBattler.level
    # Main Exp calculation
    exp = 0
    a = level * defeatedBattler.pokemon.base_exp
    if expShare.length > 0 && (isPartic || hasExpShare)
      if numPartic == 0 # No participants, all Exp goes to Exp Share holders
        exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? expShare.length : 1)
      elsif Settings::SPLIT_EXP_BETWEEN_GAINERS # Gain from participating and/or Exp Share
        exp = a / (2 * numPartic) if isPartic
        exp += a / (2 * expShare.length) if hasExpShare
      else
        # Gain from participating and/or Exp Share (Exp not split)
        exp = (isPartic) ? a : a / 2
      end
    elsif isPartic # Participated in battle, no Exp Shares held by anyone
      exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? numPartic : 1)
    elsif expAll # Didn't participate in battle, gaining Exp due to Exp All
      # NOTE: Exp All works like the Exp Share from Gen 6+, not like the Exp All
      #       from Gen 1, i.e. Exp isn't split between all Pokémon gaining it.
      exp = a / 2
    end
    return if exp <= 0
    # Pokémon gain more Exp from trainer battles
    exp = (exp * 1.5).floor if trainerBattle?
    # Scale the gained Exp based on the gainer's level (or not)
    if Settings::SCALED_EXP_FORMULA
      exp /= 5
      levelAdjust = (2 * level + 10.0) / (pkmn.level + level + 10.0)
      levelAdjust = levelAdjust ** 5
      levelAdjust = Math.sqrt(levelAdjust)
      exp *= levelAdjust
      exp = exp.floor
      exp += 1 if isPartic || hasExpShare
    else
      exp /= 7
    end
    # Foreign Pokémon gain more Exp
    isOutsider = (pkmn.owner.id != pbPlayer.id ||
      (pkmn.owner.language != 0 && pkmn.owner.language != pbPlayer.language)) ||
      pkmn.isSelfFusion? #also self fusions
    if isOutsider
      if pkmn.owner.language != 0 && pkmn.owner.language != pbPlayer.language
        exp = (exp * 1.7).floor
      else
        exp = (exp * 1.5).floor
      end
    end
    # Modify Exp gain based on pkmn's held item
    i = BattleHandlers.triggerExpGainModifierItem(pkmn.item, pkmn, exp)
    if i < 0
      i = BattleHandlers.triggerExpGainModifierItem(@initialItems[0][idxParty], pkmn, exp)
    end
    exp = i if i >= 0
    # Make sure Exp doesn't exceed the maximum

    exp = 0 if $PokemonSystem.level_caps==1 && pokemonExceedsLevelCap(pkmn)

    expFinal = growth_rate.add_exp(pkmn.exp, exp)
    expGained = expFinal - pkmn.exp




    return if expGained <= 0
    # "Exp gained" message
    if showMessages
      if isOutsider
        pbDisplayPaused(_INTL("{1} got a boosted {2} Exp. Points!", pkmn.name, expGained))
      else
        pbDisplayPaused(_INTL("{1} got {2} Exp. Points!", pkmn.name, expGained))
      end
    end
    curLevel = pkmn.level
    newLevel = growth_rate.level_from_exp(expFinal)
    dontAnimate=false
    if newLevel < curLevel
      dontAnimate = true
      # debugInfo = "Levels: #{curLevel}->#{newLevel} | Exp: #{pkmn.exp}->#{expFinal} | gain: #{expGained}"
      # raise RuntimeError.new(
      #   echoln  _INTL("{1}'s new level is less than its\r\ncurrent level, which shouldn't happen.\r\n[Debug: {2}]",
      #         pkmn.name, debugInfo)
      pbDisplayPaused(_INTL("{1}'s growth rate has changed to '{2}''. Its level will be adjusted to reflect its current exp.", pkmn.name, pkmn.growth_rate.real_name))
    end
    # Give Exp
    if pkmn.shadowPokemon?
      pkmn.exp += expGained
      return
    end
    tempExp1 = pkmn.exp
    battler = pbFindBattler(idxParty)
    loop do
      # For each level gained in turn...
      # EXP Bar animation
      levelMinExp = growth_rate.minimum_exp_for_level(curLevel)
      levelMaxExp = growth_rate.minimum_exp_for_level(curLevel + 1)
      tempExp2 = (levelMaxExp < expFinal) ? levelMaxExp : expFinal
      pkmn.exp = tempExp2



      if pkmn.isFusion?
        if pkmn.exp_gained_since_fused == nil
          pkmn.exp_gained_since_fused = expGained
        else
          pkmn.exp_gained_since_fused += expGained
        end

      end
      @scene.pbEXPBar(battler, levelMinExp, levelMaxExp, tempExp1, tempExp2) if !dontAnimate


      tempExp1 = tempExp2
      curLevel += 1
      if curLevel > newLevel
        # Gained all the Exp now, end the animation
        pkmn.calc_stats
        battler.pbUpdate(false) if battler
        @scene.pbRefreshOne(battler.index) if battler
        break
      end
      # Levelled up
      pbCommonAnimation("LevelUp", battler) if battler
      oldTotalHP = pkmn.totalhp
      oldAttack = pkmn.attack
      oldDefense = pkmn.defense
      oldSpAtk = pkmn.spatk
      oldSpDef = pkmn.spdef
      oldSpeed = pkmn.speed
      if battler && battler.pokemon
        battler.pokemon.changeHappiness("levelup")
      end
      pkmn.calc_stats
      battler.pbUpdate(false) if battler
      @scene.pbRefreshOne(battler.index) if battler
      if !CHEATS["EXPBOOST"]
        pbDisplayPaused(_INTL("{1} grew to Lv. {2}!", pkmn.name, curLevel))
        if !$game_switches[SWITCH_NO_LEVELS_MODE]
        @scene.pbLevelUp(pkmn, battler, oldTotalHP, oldAttack, oldDefense,
                          oldSpAtk, oldSpDef, oldSpeed)
        end
      end
      echoln "256"

      # Learn all moves learned at this level
      moveList = pkmn.getMoveList
      moveList.each { |m| pbLearnMove(idxParty, m[1]) if m[0] == curLevel }
    end
  end
