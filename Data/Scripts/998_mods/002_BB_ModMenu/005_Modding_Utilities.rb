# ModMenuCommands.register("modding",{
#   "parent"      => "main",
#   "name"        => _INTL("Modding Utilities"),
#   "description" => _INTL("Add your modding utilites here"),
# })
# ModMenuCommands.register("dumpData",{
#   "parent"      => "modding",
#   "name"        => _INTL("Dump all"),
#   "description" => _INTL("D"),
#   "effect"      => proc{
#     #Compiler.write_all
#   }
# })

# ModMenuCommands.register("readData",{
#   "parent"      => "modding",
#   "name"        => _INTL("Read all"),
#   "description" => _INTL("D"),
#   "effect"      => proc{
#     #Compiler.compile_encounters
#     #Compiler.compile_moves
#     #Compiler.compile_trainers
#     #Compiler.compile_pokemon
#     #Compiler.compile_items
#     #MessageTypes.saveMessages
#   }
# })
