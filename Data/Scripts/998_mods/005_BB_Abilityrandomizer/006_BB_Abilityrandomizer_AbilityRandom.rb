module GameData
  class AbilityRandom
    attr_reader :id
    attr_reader :abilities
    attr_reader :hiddenAbilities
    attr_reader :real_name
    attr_reader :specie
    attr_reader :originalAbilities
    attr_reader :originalhiddenAbilities


    DATA = {}
    @data_filenumber = "non"
    DATA_FILENAME = "Scripts/998_mods/005_BB_Abilityrandomizer/abilities_random"
    extend ClassMethodsSymbols
    include InstanceMethods
    def self.newGameClear
      self::DATA.clear()
      const_set(:DATA, load_data("Data/Scripts/998_mods/005_BB_Abilityrandomizer/abilities_randomnon.dat"))
    end
    def self.fileName
      trainer = $Trainer
      if trainer
        meta = $Trainer.save_slot
        if meta
          setFileNumber(meta)
        end
      else
        setFileNumber("non")
      end
      fileName = "Data/" + self::DATA_FILENAME + self.getFileNumber + ".dat"
      if !File.exists?(fileName)
        fyle = File.open(fileName, "w")
        fyle.close
        if self::DATA.size <= 0
          GameData::Species.each {|s| s.createAbilityHash("non")}
          self.save
        end
      end
      $Save_Ability_File_Name = fileName
      return fileName
    end
    def self.load
      self::DATA.clear()
      const_set(:DATA, load_data( self.fileName))
    end
    def self.save
      save_data(self::DATA,  self.fileName)
    end
    def self.getFileNumber
      return @data_filenumber
    end
    def self.setFileNumber(fileN)
      fileM = fileN[fileN.length-3, fileN.length]
      @data_filenumber = fileM
    end
    def initialize(hash)
      @id                      = hash[:id]
      @abilities               = hash[:abilities]  || []
      @hiddenAbilities         = hash[:hiddenAbilities] || []
      @real_name               = hash[:real_name]
      @specie                  = hash[:specie]

    end

    def setValues(abilites,hiddenAbilities, real_name, specie)
      @id           = (specie.to_s + "ABIL").to_sym
      @abilities    = abilites
      @hiddenAbilities = hiddenAbilities
      @real_name = real_name
      @specie = specie
    end
    def setValues2()
      pkmn = GameData::Species.get(@specie)
      pkmn.setAbilities(@abilities, @hiddenAbilities)
    end
  end
end


SaveData.register(:player) do
  ensure_class :Player
  save_value {  $Trainer }
  load_value {
    |value| $Trainer = value
    GameData::AbilityRandom.load
    GameData::AbilityRandom.each {|a| a.setValues2()}
  }
  new_game_value {
    $Save_Ability_File_Name = "non"
    GameData::AbilityRandom.newGameClear
    trainer_type = nil   # Get the first defined trainer type as a placeholder
    GameData::TrainerType.each { |t| trainer_type = t.id; break }
    Player.new("Unnamed", trainer_type)
  }
  from_old_format { |old_format| old_format[0] }
end
