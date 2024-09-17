RRMenuCommands.register("DexNav",{
  "parent"      => "main",
  "name"        => _INTL("DexNav"),
  "description" => _INTL("Use Dex Nav"),
  "effect"      => proc{
    pbPlayDecisionSE
    x = pbUseDexNav
    if $PokemonTemp.dex_nav_ui == nil
      x = -1
    else
      $PokemonTemp.dex_nav_ui.startDexNavInput
    end
    }
  })
