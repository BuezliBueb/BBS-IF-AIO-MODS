class RRMenuScene
  def pbStartRRScene
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    @sprites["cmdwindow"] = Window_CommandPokemon.new([])
    @sprites["cmdwindow"].visible = true
    @sprites["cmdwindow"].viewport = @viewport

    @infostate = false
    @helpstate = false
    pbSEPlay("GUI menu open")
  end

  def pbShowRRCommands(commands)
    ret = -1
    @sprites["cmdwindow"].commands = commands.list
    cmdwindow = @sprites["cmdwindow"]
   # cmdwindow.resizeToFit(commands)
   cmdwindow.resizeToFit(cmdwindow.commands)
    cmdwindow.x = Graphics.width - cmdwindow.width
    cmdwindow.y = 0
    cmdwindow.index = 0
    cmdwindow.visible = true
    cmd = false
    loop do
      cmdwindow.update
      Graphics.update
      Input.update
      pbUpdateSceneMap
      if Input.trigger?(Input::BACK)
        parent = commands.getParent
        if parent
          pbPlayCancelSE
          commands.currentList = parent[0]
          cmdwindow.commands = commands.list
          cmdwindow.index = parent[1]
          refresh = true
        else
          break
        end
      elsif Input.trigger?(Input::USE)
        if commands.hasSubMenu?(commands.getCommand(cmdwindow.index))
          pbPlayDecisionSE
          commands.currentList = commands.getCommand(cmdwindow.index)
          cmdwindow.commands = commands.list
          cmdwindow.index = 0
          parent = true
          refresh = true
        else
          cmd = commands.getCommand(cmdwindow.index)
          break
        end
      elsif Input.trigger?(Input::BACK)
        parent = commands.getParent
        if parent
          pbPlayCancelSE
          commands.currentList = parent[0]
          cmdwindow.commands = commands.list
          cmdwindow.index = parent[1]
          refresh = true
        else
          pbEndScene
          break
        end
      end
    end
    if !cmd
      pbEndScene
      return 0
    end
    pbEndScene
    RRMenuCommands.call("effect", cmd)
    return 0
  end


  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class RRMenuScreen
  attr_reader :scene
  def pbStartRRScreen
    @scene.pbStartRRScene
    pbStartRRmenu
  end
  def initialize(scene)
    @scene = scene
  end
  def pbEndScene
    @scene.pbEndScene
  end
  def pbStartRRmenu
    doTheRegister
    commands = CommandMenuList.new
    RRMenuCommands.each do |option, hash|
      commands.add(option, hash)
    end
    command = @scene.pbShowRRCommands(commands)
    return command
  end
  def doTheRegister
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
    file = File.open("Data/Scripts/998_mods/008_BB_RR_Utilties/002_BB_Pokevial/" + $Trainer.save_slot + ".txt", "r")
    used = file.read
    file.close
    RRMenuCommands.register("healPokemon",{
      "parent"      => "main",
      "name"        => _INTL("Pokevial " + (used == nil ? "1" : (1 + $Trainer.badge_count - used.to_i).to_s) + "/" + ($Trainer == nil ? "1" : (1 + $Trainer.badge_count).to_s)),
      "description" => _INTL("Heal Pokemon"),
      "effect"      => proc{
        if used.to_i < (1 + $Trainer.badge_count)
          pbPlayDecisionSE
          $Trainer.party.each { |pkmn| pkmn.heal }
          pbMessage(_INTL("Healed all Pokemon "))
          nused = 1 + used.to_i
          file = File.open("Data/Scripts/998_mods/008_BB_RR_Utilties/002_BB_Pokevial/" + $Trainer.save_slot + ".txt", "w")
          file.write(nused)
          file.close
        else
          pbMessage(_INTL("No more Pokevial uses left, heal at a Pokecenter to replenish"))
        end
      }
    })
  end
end
