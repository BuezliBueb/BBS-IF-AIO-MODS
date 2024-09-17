module GameDataRegistry
  @@Loadables = HandlerHashBasic.new

  def self.register(option, hash)
    @@Loadables.add(option, hash)
  end

  def self.registerIf(condition, hash)
    @@Loadables.addIf(condition, hash)
  end

  def self.copy(option, *new_options)
    @@Loadables.copy(option, *new_options)
  end

  def self.each
    @@Loadables.each { |key, hash| yield key, hash }
  end

  def self.hasFunction?(option, function)
    option_hash = @@Loadables[option]
    return option_hash && option_hash.keys.include?(function)
  end
  def self.getName(function, option)
    option_hash = @@Loadables[option]
    return option_hash[function]
  end

  def self.getFunction(option, function)
    option_hash = @@Loadables[option]
    return (option_hash && option_hash[function]) ? option_hash[function] : nil
  end

  def self.call(function, option, *args)
    option_hash = @@Loadables[option]
    return nil if !option_hash || !option_hash[function]
    return (option_hash[function].call(*args) == true)
  end

end

module GameData
  def self.load_all
  Type.load
  Ability.load
  Move.load
  Item.load
  BerryPlant.load
  Species.load
  Ribbon.load
  Encounter.load
  EncounterModern.load
  EncounterRandom.load
  TrainerType.load
  Trainer.load
  TrainerModern.load
  Metadata.load
  MapMetadata.load
  GameDataRegistry.each do |option, hash|
    GameDataRegistry.call("effect", option)
  end
  end
end
