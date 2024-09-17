LoadRegistry.register("AbilityRandom",{
  "effect"      => proc{
    GameData::AbilityRandom.load
    GameData::AbilityRandom.each {|a| a.setValues2()}
  }
})
GameDataRegistry.register("AbilityRandom",{
  "effect"      => proc{
      GameData::AbilityRandom.load
  }
})

def abilityRandomMain
  abilityArray = []
  bannedAblities = []
  if $game_switches[BAN_WONDER_GUARD]
    bannedAblities.push("Wonderguard")
  end
  if $game_switches[BAN_USLESS_ABILITIES]
    bannedAblities.push("Plus")
    bannedAblities.push("Minus")
    bannedAblities.push("Slow Start")
    bannedAblities.push("Pickup")
    bannedAblities.push("Truant")
    bannedAblities.push("Forecast")
    bannedAblities.push("Sticky Hold")
    bannedAblities.push("Swarm")
    bannedAblities.push("Stall")
    bannedAblities.push("Torrent")
    bannedAblities.push("Overgrow")
    bannedAblities.push("Blaze")
    bannedAblities.push("Unnerv")
    bannedAblities.push("Battle Bond")
    bannedAblities.push("Transform")
    bannedAblities.push("Zen Mode")
    bannedAblities.push("Triage")
    bannedAblities.push("Immunity")
    bannedAblities.push("Limber")
  end
  GameData::Ability.each do |a|
    if !(bannedAblities.include? a.name)
      abilityArray.push(a)
    end
  end
  GameData::Species.each {|s| s.randomizeAbility(abilityArray)}
  #$game_switches[RANDOM_ONE_TO_ONE]
  #$game_switches[RANDOM_ON_EVOLUTION]
end
