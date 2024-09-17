class PokemonTemp
  attr_accessor :dex_nav
  attr_accessor :dex_nav_ui
end

class PokemonEncounters
  def getEncounterTables
    return @encounter_tables
  end
  def get_encounter_tables(enc_type)
    enc_list = @encounter_tables[enc_type]
    return false if !enc_list || enc_list.length == 0
    return enc_list
  end
end
def pbCanUseDexNav?
  encounterlist = $game_map.encounter_list
  if !encounterlist > 1
    return false
  end
  return true
end

def displayDexNav(yPokemonList = [])
  return if $PokemonTemp.dex_nav_ui != nil
  $PokemonTemp.dex_nav_ui = Dex_Nav_UI.new(yPokemonList)
  if $PokemonTemp.dex_nav_ui.amountInRoute <= 70
	  $PokemonTemp.dex_nav_ui = nil
      return -1
  end
end
def pbUseDexNav
  $PokemonTemp.dex_nav = [0, 0, 0, []] if !$PokemonTemp.dex_nav
  xPokemonList = listPokemonInCurrentRouteForDexNav()
  displayDexNav(xPokemonList)
  pbWait(10)
  return true
end
def pbDexNavCancle
  if $PokemonTemp.dex_nav_ui != nil
    $PokemonTemp.dex_nav_ui.dispose
    $PokemonTemp.dex_nav_ui = nil
  end
  $PokemonTemp.dex_nav = nil
end
def listPokemonInCurrentRouteForDexNav()
  encounters = {}
  encounters["Land"] = listPokemoninType($PokemonEncounters.get_encounter_tables(:Land),"Land")
  encounters["Water"] = listPokemoninType($PokemonEncounters.get_encounter_tables(:Water),"Water")
  encounters["OldRod"] = listPokemoninType($PokemonEncounters.get_encounter_tables(:OldRod),"OldRod")
  encounters["GoodRod"] = listPokemoninType($PokemonEncounters.get_encounter_tables(:GoodRod),"GoodRod")
  encounters["SuperRod"] = listPokemoninType($PokemonEncounters.get_encounter_tables(:SuperRod),"SuperRod")
  encounters["LandDay"] = listPokemoninType($PokemonEncounters.get_encounter_tables(:LandDay),"LandDay")
  encounters["LandMorning"] = listPokemoninType($PokemonEncounters.get_encounter_tables(:LandMorning),"LandMorning")
  encounters["LandNight"] = listPokemoninType($PokemonEncounters.get_encounter_tables(:LandNight),"LandNight")
  encounters["Cave"] = listPokemoninType($PokemonEncounters.get_encounter_tables(:Cave),"Cave")
  encounters["RockSmash"] = listPokemoninType($PokemonEncounters.get_encounter_tables(:RockSmash),"RockSmash")
  return encounters
end
def listPokemoninType(enc_list,encounterType)
  new_enc_list = []
  if enc_list == nil or enc_list == false
        return []
  end
  enc_list.each do |enc|
    species_data = GameData::Species.get(enc[1])
    new_enc_list.push([enc[1],encounterType])
  end
  return new_enc_list
end
EncounterModifier.register(proc { |encounter|
if $PokemonTemp.dex_nav_ui != nil
  x = ($PokemonTemp.dex_nav_ui.getEncounter[1])
  y = ($PokemonTemp.encounterType)
  if x.to_s.capitalize[0,3] == y.to_s.capitalize[0,3]
    encounter = [$PokemonTemp.dex_nav_ui.getEncounter[0],encounter[1]]
  else
    $PokemonTemp.dex_nav_ui.dispose
    next encounter
  end
  $PokemonTemp.forceSingleBattle = true
  next encounter
else
  next encounter
end


})
Events.onWildBattleEnd += proc { |_sender, e|
  pbDexNavCancle
}
