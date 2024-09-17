class RandomizerOptionsScene < PokemonOption_Scene
  SWITCH_RANDOM_ABILITY = 1100
  def pbGetOptions(inloadscreen = false)
    options = [

    EnumOption.new(_INTL("Ability"), [_INTL("On"), _INTL("Off")],
    proc {
      $game_switches[SWITCH_RANDOM_ABILITY] ? 0 : 1
    },
    proc { |value|
      if !$game_switches[SWITCH_RANDOM_ABILITY] && value == 0
        @openAbilityOptions = true
        openAbilityOptionsMenu()
      end
      $game_switches[SWITCH_RANDOM_ABILITY] = value == 0
    }, "Select the randomizer options for Pokémon"
    ),
      EnumOption.new(_INTL("Pokémon"), [_INTL("On"), _INTL("Off")],
                    proc {
                      $game_switches[SWITCH_RANDOM_WILD] ? 0 : 1
                    },
                    proc { |value|
                      if !$game_switches[SWITCH_RANDOM_WILD] && value == 0
                        @openWildOptions = true
                        openWildPokemonOptionsMenu()
                      end
                      $game_switches[SWITCH_RANDOM_WILD] = value == 0
                    }, "Select the randomizer options for Pokémon"
      ),
      EnumOption.new(_INTL("NPC Trainers"), [_INTL("On"), _INTL("Off")],
                    proc { $game_switches[SWITCH_RANDOM_TRAINERS] ? 0 : 1},
                    proc { |value|
                      if !$game_switches[SWITCH_RANDOM_TRAINERS] && value == 0
                        @openTrainerOptions = true
                        openTrainerOptionsMenu()
                      end
                      $game_switches[SWITCH_RANDOM_TRAINERS] = value == 0
                    }, "Select the randomizer options for trainers"
      ),

      EnumOption.new(_INTL("Gym trainers"), [_INTL("On"), _INTL("Off")],
                    proc { $game_switches[SWITCH_RANDOMIZE_GYMS_SEPARATELY] ? 0 : 1},
                    proc { |value|
                      if !$game_switches[SWITCH_RANDOMIZE_GYMS_SEPARATELY] && value == 0
                        @openGymOptions = true
                        openGymOptionsMenu()
                      end
                      $game_switches[SWITCH_RANDOMIZE_GYMS_SEPARATELY] = value == 0
                    }, "Limit gym trainers to a single type"
      ),

      EnumOption.new(_INTL("Items"), [_INTL("On"), _INTL("Off")],
                    proc { $game_switches[SWITCH_RANDOM_ITEMS_GENERAL] ? 0 : 1},
                    proc { |value|
                      if !$game_switches[SWITCH_RANDOM_ITEMS_GENERAL] && value == 0
                        @openItemOptions = true
                        openItemOptionsMenu()
                      end
                      $game_switches[SWITCH_RANDOM_ITEMS_GENERAL] = value == 0
                    }, "Select the randomizer options for items"
      ),

    ]
    return options
  end
end

def openAbilityOptionsMenu()
  return if !@openAbilityOptions
  pbFadeOutIn {
    scene = RandomizerAbilityOptionsScene.new
    screen = PokemonOptionScreen.new(scene)
    screen.pbStartScreen
  }
  @openAbilityOptions = false
end

def pbRandomizeAbilities
  a= []
  a = GameData::Ability.each{|ability| a.push(ability)}
  GameData::Species.each {|s| s.randomizeAbility(a, "new")}
end
class RandomizerAbilityOptionsScene < PokemonOption_Scene
  RANDOM_NO_BAD_ABILITES = 1101
  RANDOM_ONLY_USABLE_BY_SPECIES = 1102
  RANDOM_ONE_TO_ONE = 1103
  RANDOM_ON_EVOLUTION = 1104
  RANDOM_FUSION_ABILITIES = 1105
  BAN_WONDER_GUARD = 1500
  BAN_USLESS_ABILITIES = 1501
  def initialize
    @changedColor = false
  end

  def pbStartScene(inloadscreen = false)
    super
    @sprites["option"].nameBaseColor = Color.new(70, 170, 40)
    @sprites["option"].nameShadowColor = Color.new(40, 100, 20)
    @changedColor = true
    for i in 0...@PokemonOptions.length
      @sprites["option"][i] = (@PokemonOptions[i].get || 0)
    end
    @sprites["title"] = Window_UnformattedTextPokemon.newWithSize(
      _INTL("Randomizer settings: Abilities"), 0, 0, Graphics.width, 64, @viewport)
    @sprites["textbox"].text = _INTL("Set the randomizer settings for Abilities")
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbFadeInAndShow(sprites, visiblesprites = nil)
    return if !@changedColor
    super
  end

  def pbGetOptions(inloadscreen = false)
    options = []
    options << EnumOption.new(_INTL("No Bad Abilities?"), [_INTL("On"), _INTL("Off")],
                              proc {
                                if $game_switches[BAN_USLESS_ABILITIES]
                                  0
                                else
                                  1
                                end
                              },
                              proc { |value|
                                if value == 0
                                  $game_switches[BAN_USLESS_ABILITIES] = true
                                else
                                  value == 1
                                  $game_switches[BAN_USLESS_ABILITIES] = false
                                end
                              },
                              [
                                "All Abilities will be used",
                                "Abilities like Truant or Slowstart will not appear"
                              ]
    )
    options << EnumOption.new(_INTL("Ban Wonderguard"), [_INTL("On"), _INTL("Off")],
                              proc { $game_switches[BAN_WONDER_GUARD] ? 0 : 1 },
                              proc { |value|
                                $game_switches[BAN_WONDER_GUARD] = value == 0
                              }, "No Wonderguard"
    )

    options << EnumOption.new(_INTL("One to One"), [_INTL("On"), _INTL("Off")],
                              proc { $game_switches[RANDOM_ONE_TO_ONE] ? 0 : 1 },
                              proc { |value|
                                $game_switches[RANDOM_ONE_TO_ONE] = value == 0
                              }, "WIP"
    )
    options << EnumOption.new(_INTL("Keep on evolution"), [_INTL("On"), _INTL("Off")],
                              proc { $game_switches[RANDOM_ON_EVOLUTION] ? 0 : 1 },
                              proc { |value|
                                $game_switches[RANDOM_ON_EVOLUTION] = value == 0
                              },
                              "WIP"
    )

    options << EnumOption.new(_INTL("Fusion Abilities"), [_INTL("On"), _INTL("Off")],
                              proc { $game_switches[RANDOM_FUSION_ABILITIES] ? 0 : 1 },
                              proc { |value|
                                $game_switches[RANDOM_FUSION_ABILITIES] = value == 0
                              }, "WIP"
    )
    SaveData.register(:abilityRandomizerOptions) do
      save_value { 3 }
      load_value { |value| 3 + value }
      new_game_value {
        if $game_switches[SWITCH_RANDOM_ABILITY]
          abilityRandomMain
        end
      }
    end
    return options
  end
end
