class ModMenuScene
  def pbStartModScene
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

  def pbShowModCommands(commands)
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
		  cmdwindow.resizeToFit(cmdwindow.commands)
          cmdwindow.index = 0
          parent = true
          refresh = true
        else
          cmd = commands.getCommand(cmdwindow.index)
          break
        end
      elsif Input.trigger?(Input::RIGHT)
        pbEndScene
        return 1
        break
      elsif Input.trigger?(Input::LEFT)
        #Game.save
        #cmdwindow.visible = false
        #sscene = ModSettingsScene.new
        #sscreen = ModMenuSettingsScreen.new(sscene)
        #ret1 = sscreen.pbStartModScreen
        #if ret1 == 1
        #cmdwindow.visible = true
        #else
        ret = -1
        break
        #end
      end
    end
    if !cmd
      pbEndScene
      return 0
    end
    pbEndScene
    ModMenuCommands.call("effect", cmd)
    return 0
  end


  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class ModMenuScreen
  attr_reader :scene
  def pbStartModScreen
    @scene.pbStartModScene
    pbStartModmenu
  end
  def initialize(scene)
    @scene = scene
  end
  def pbEndScene
    @scene.pbEndScene
  end
  def pbStartModmenu
    commands = CommandMenuList.new
    ModMenuCommands.each do |option, hash|
      commands.add(option, hash)
    end
    command = @scene.pbShowModCommands(commands)
    return command
  end
end

class PokemonPauseMenu_Scene
  def pbShowCommands(commands)
    ret = -1
    cmdwindow = @sprites["cmdwindow"]
    cmdwindow.commands = commands
    cmdwindow.index = $PokemonTemp.menuLastChoice
    cmdwindow.resizeToFit(commands)
    cmdwindow.x = Graphics.width - cmdwindow.width
    cmdwindow.y = 0
    cmdwindow.visible = true
    loop do
      cmdwindow.update
      Graphics.update
      Input.update
      pbUpdateSceneMap
      if Input.trigger?(Input::BACK)
        ret = -1
        break
      elsif Input.trigger?(Input::USE)
        ret = cmdwindow.index
        $PokemonTemp.menuLastChoice = ret
        break
      elsif Input.trigger?(Input::LEFT)
        Game.save
        cmdwindow.visible = false
        sscene = ModMenuScene.new
        sscreen = ModMenuScreen.new(sscene)
        ret1 = sscreen.pbStartModScreen
        if ret1 == 1
          cmdwindow.visible = true
        else
          ret = -1
          break
        end
      end
    end
    return ret
  end
end
