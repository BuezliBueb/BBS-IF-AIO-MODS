class Dex_Nav_UI
  attr_reader :sprites
  attr_reader :disposed

  ICON_START_X = 50
  ICON_START_Y = 5

  ICON_MARGIN_X = 50
  ICON_MARGIN_Y = 50

  ICON_LINE_END = 450

  def initialize(xPokemonList)
    @amountInRoute = 0
    for x in xPokemonList
		for y in x
			@amountInRoute += y.size
		end
	end
    if @amountInRoute <= 70
      pbMessage(_INTL("No Pokemon Found"))
	  $PokemonTemp.dex_nav_ui = nil
      return -1
    else
		@PokemonList = xPokemonList
		@viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
		@viewport.z = 99
		@sprites = {}
		@sprites["backgroundLand"] = IconSprite.new(0, 0, @viewport)
		@sprites["backgroundLand"].setBitmap("Graphics/Mods/DexNav/background")
		@sprites["backgroundLand"].zoom_x = 2
		@sprites["backgroundLand"].zoom_y = 2
		@sprites["backgroundLand"].visible = true
		@index = 0
		@maxIndex = 0
		@pokemonList = {}
		@current_x = 50
		@current_y = -50
		@linebreakindex = {}
		@linebreakindex["size"] = -1
		@lines = -1
		@current_x_water = 50
		@current_y_water =  Graphics.height/2
		@startWater = 0
		@currLine = 0
		@encounter = 0
		@selected = false
		setLineSize(0,0)
		displayPokemonList()
		@index = 0
		@sprites[@index.to_s + "_outline"].visible = true
	end
  end
  def amountInRoute
	return @amountInRoute
  end
  def getEncounter
    return @encounter
  end
  def index
    return @index
  end
  def setLineSize(lines, index)
    @linebreakindex["size"] += 1
    @linebreakindex[lines.to_s] = index
  end
  def getLineIndex(line)
    return @linebreakindex[line.to_s]
  end

  def startDexNavInput
    if @maxIndex == 0
      return
    end
    $game_temp.in_menu = true
    $game_player.straighten
    $game_map.update
    loop do
      Graphics.update
      Input.update
      if Input.trigger?(Input::RIGHT)
        @sprites[@index.to_s + "_outline"].visible = false
        if(@index < @maxIndex - 1)
          @index = @index + 1
          if(@index == getLineIndex(@currLine))
            @currLine += 1
          end
        else
          @index = 0
          @currLine = 0
        end
        @sprites[@index.to_s + "_outline"].visible = true
      end
      if Input.trigger?(Input::LEFT)
        @sprites[@index.to_s + "_outline"].visible = false
        if(@index == 0)
          @index = @maxIndex - 1
          @currLine = @linebreakindex["size"]
        else
          if(@index == getLineIndex(@currLine))
            @currLine -= 1
          end
          @index = @index - 1
        end
        @sprites[@index.to_s + "_outline"].visible = true
      end
      if Input.trigger?(Input::DOWN)
        @sprites[@index.to_s + "_outline"].visible = false
        if @currLine == @linebreakindex["size"] - 1
          @currLine = 0
        else
          @currLine += 1
        end
        @index = getLineIndex(@currLine)
        @sprites[@index.to_s + "_outline"].visible = true
      end
      if Input.trigger?(Input::UP)
        @sprites[@index.to_s + "_outline"].visible = false
        if @currLine == 0
          @currLine = @linebreakindex["size"] - 1
        else
          @currLine -= 1
        end
        @index = getLineIndex(@currLine)
        @sprites[@index.to_s + "_outline"].visible = true
      end
      if Input.trigger?(Input::USE)
        @encounter = @pokemonList[@index]
        pbDisposeSpriteHash(@sprites)
        pokemonId=dexNum(@encounter[0])
        pokemonBitmap = sprintf("Graphics/Icons/icon%03d", pokemonId)
        if pokemonId > NB_POKEMON
          iconSprite = createFusionIcon(pokemonId,50,50)
        else
          iconSprite = IconSprite.new(50, 50)
          iconSprite.setBitmap(pokemonBitmap)
        end
        @sprites["Pkm"] = iconSprite
        @sprites["Pkm"].x = 50
        @sprites["Pkm"].y = 50
        @sprites["Pkm"].z = 100
        @sprites["Pkm"].src_rect.width /= 2
        @sprites["Pkm"].visible = true
        @selected = true
        $game_temp.in_menu = false
        break
      end
      if Input.trigger?(Input::BACK) && @selected == false
        pbDexNavCancle
        break
      end
    end
    $game_temp.in_menu = false
  end
  def dispose
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose if @viewport != nil
  end
  def displayPokemonList
    try_type = "Land"
    if @PokemonList["Land"].size == 0
        time = pbGetTimeNow
        if PBDayNight.isDay?(time)
        try_type = "LandDay"
        if PBDayNight.isMorning?(time)
          try_type = "LandMorning"
        end
      else
        try_type = "LandNight"
      end
    end
    if @PokemonList[try_type].size > 0
      displayPokemonListNotRod(try_type)
    end
    if @PokemonList["Cave"].size > 0
      displayPokemonListNotRod("Cave")
    end
    if @PokemonList["RockSmash"].size > 0
      displayPokemonListNotRod("RockSmash")
    end
    if @PokemonList["Water"].size > 0
      displayPokemonListNotRod("Water")
    end
    if @PokemonList["OldRod"].size > 0
      displayPokemonListNotRod("OldRod")
    end
    if @PokemonList["GoodRod"].size > 0
      displayPokemonListNotRod("GoodRod")
    end
    if @PokemonList["SuperRod"].size > 0
      displayPokemonListNotRod("SuperRod")
    end
  end
  def displayPokemonListNotRod(type)
    if @PokemonList[type].size > 0
      @lines += 1
      @current_x = ICON_START_X
      @current_y +=ICON_MARGIN_Y
      @sprites["backgroundLand"].zoom_y += 1
      setLineSize(@lines,@index)
      #Here then Icon
      iconBitmap = ("Graphics/Mods/DexNav/icon" + type + ".png")
      yOffset = @current_y + 18
      iconSprite = IconSprite.new(0, yOffset)
      iconSprite.setBitmap(iconBitmap)
      @sprites[type] = iconSprite
      @sprites[type].visible = true
      @sprites[type].x = 0
      @sprites[type].y = yOffset
      @sprites[type].z = 100
      @PokemonList[type].each { |pokemonId, enc_type|
        species = GameData::Species.get(pokemonId)
        addPokemonIcon(species)
        @pokemonList[@index] = [pokemonId,enc_type]
        @index = @index + 1
        @maxIndex = @maxIndex + 1
      }
    end
  end
  def addPokemonIcon(species)
    pokemonId=dexNum(species)
    iconId = @index
    pokemonBitmap = sprintf("Graphics/Icons/icon%03d", pokemonId)
    if @current_x + ICON_MARGIN_X >= ICON_LINE_END
      @current_x = ICON_START_X
      @current_y += ICON_MARGIN_Y
      @sprites["backgroundLand"].zoom_y += 1
      @lines += 1
      setLineSize(@lines,@index)
    end
    outlineSprite = IconSprite.new(@current_x, @current_y)
    outlineSprite.setBitmap("Graphics/Pictures/Pokeradar/highlight")
    outlineSprite.visible=false
    @sprites[iconId.to_s + "_outline"] = outlineSprite
    if pokemonId > NB_POKEMON
      iconSprite = createFusionIcon(pokemonId,@current_x,@current_y)
    else
      iconSprite = IconSprite.new(@current_x, @current_y)
      iconSprite.setBitmap(pokemonBitmap)
    end
    @sprites[iconId] = iconSprite
    @sprites[iconId].src_rect.width /= 2
    @sprites[iconId].visible = true
    @sprites[iconId].x = @current_x
    @sprites[iconId].y = @current_y
    @sprites[iconId].z = 100
    @current_x += ICON_MARGIN_X
  end
  def createFusionIcon(pokemonId,x,y)
      bodyPoke_number = getBodyID(pokemonId)
      headPoke_number = getHeadID(pokemonId, bodyPoke_number)

      bodyPoke = GameData::Species.get(bodyPoke_number).species
      headPoke = GameData::Species.get(headPoke_number).species

      bitmap1 = AnimatedBitmap.new(GameData::Species.icon_filename(headPoke))
      bitmap2 = AnimatedBitmap.new(GameData::Species.icon_filename(bodyPoke))
      dexNum = getDexNumberForSpecies(pokemonId)
      ensureFusionIconExists()
      bitmapFileName = sprintf("Graphics/Pokemon/FusionIcons/icon%03d", dexNum)
      headPokeFileName = GameData::Species.icon_filename(headPoke)
      bitmapPath = sprintf("%s.png", bitmapFileName)
      generated_new_icon = generateFusionIcon(headPokeFileName,bitmapPath)
      result_bitmap = generated_new_icon ? AnimatedBitmap.new(bitmapPath) : bitmap1

      for i in 0..bitmap1.width-1
        for j in ((bitmap1.height / 2) + Settings::FUSION_ICON_SPRITE_OFFSET)..bitmap1.height-1
          temp = bitmap2.bitmap.get_pixel(i, j)
          result_bitmap.bitmap.set_pixel(i, j, temp)
        end
      end
      icon = IconSprite.new(x, y)
      icon.setBitmapDirectly(result_bitmap)
      return icon
  end
  end
