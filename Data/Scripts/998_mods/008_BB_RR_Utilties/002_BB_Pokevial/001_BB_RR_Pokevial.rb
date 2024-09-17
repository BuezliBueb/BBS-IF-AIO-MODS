RRMenuCommands.register("healPokemon",{
      "parent"      => "main",
      "name"        => _INTL("Pokevial"),
      "description" => _INTL("Heal Pokemon"),
      "effect"      => proc{
        pbPlayDecisionSE
        $Trainer.party.each { |pkmn| pkmn.heal }
        pbMessage(_INTL("Healed all Pokemon "))
      }
})
class Interpreter
  def command_314
    $Trainer.heal_party if @parameters[0] == 0
    file = File.open("Data/Scripts/998_mods/008_BB_RR_Utilties/002_BB_Pokevial/" + ($Trainer.save_slot == nil ? "Unsaved" : $Trainer.save_slot)  + ".txt", "w")
    file.write(0)
    file.close
    return true
  end
end
