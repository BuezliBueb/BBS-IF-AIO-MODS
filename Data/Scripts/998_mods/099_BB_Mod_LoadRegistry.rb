module Game
  def self.load(save_data)
    validate save_data => Hash
    SaveData.load_all_values(save_data)
    self.load_map
    pbAutoplayOnSave
    $game_map.update
    $PokemonMap.updateMap
    $scene = Scene_Map.new
    LoadRegistry.each do |option, hash|
      LoadRegistry.call("effect", option)
    end
  end
end
module LoadRegistry
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
