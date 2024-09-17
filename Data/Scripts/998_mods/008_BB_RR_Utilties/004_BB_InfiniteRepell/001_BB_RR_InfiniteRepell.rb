RRMenuCommands.register(
  "infRep",{
    "parent"      => "main",
    "name"        => _INTL("Infinite Repell" + ($game_system == nil ? " " : $game_system.encounter_disabled ? " (On)" : " (Off)")),
    "description" => _INTL("Toggels infinite repell"),
    "effect"      => proc{
      $game_system.encounter_disabled = !$game_system.encounter_disabled
      pbMessage($game_system.encounter_disabled ? "Infinite Repell Enabled" : "Infinite Repell Disabled")
    }
  }
)
