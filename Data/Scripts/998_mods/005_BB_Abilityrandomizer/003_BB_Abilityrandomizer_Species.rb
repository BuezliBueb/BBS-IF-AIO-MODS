module GameData
  class Species
    def randomizeAbility(abilities1, meta = $Trainer.save_slot)
      ability1 = :SIMPLE
      ability2 = :SIMPLE
      ability3 = :SIMPLE
      loop do
        ability1 = abilities1.sample
        ability2 = abilities1.sample
        ability3 = abilities1.sample
        if ability1 != ability2 && ability1  != ability3  && ability2 != ability3
          break
        end
      end
      @abilities = [ability1, ability2]
      @hidden_abilities = [ability3]
      createAbilityHash(meta)
    end
    def setAbilities(abilities1, hiddenAbilities1)
      @abilities = abilities1
      @hidden_abilities = hiddenAbilities1
    end
    def createAbilityHash(meta)
      saveClass = GameData::AbilityRandom.try_get(@id)
      if saveClass.nil?
        abilityHash = {}
        abilityHash[:id] = (@id.to_s + meta).to_sym
        abilityHash[:abilities] = @abilities
        abilityHash[:hiddenAbilities] = @hidden_abilities
        abilityHash[:real_name] = @real_name
        abilityHash[:specie] = @id
        saveClass = GameData::AbilityRandom.register(abilityHash)
      else
        saveClass.setValues(@abilities,@hidden_abilities, @real_name, @id)
      end
    end
  end
end
