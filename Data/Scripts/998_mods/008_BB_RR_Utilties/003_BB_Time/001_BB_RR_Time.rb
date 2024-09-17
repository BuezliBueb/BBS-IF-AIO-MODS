RRMenuCommands.register("time",{
  "parent"      => "main",
  "name"        => _INTL("Time"),
  "description" => _INTL("The power of Time"),
})
RRMenuCommands.register("dayMorning",{
  "parent"      => "time",
  "name"        => _INTL("07:00"),
  "description" => _INTL("Wait until morning"),
  "effect"      => proc{
    pbSkipTime(7)
    newTime = pbGetTimeNow.strftime("%I:%M %p")
  }
})
RRMenuCommands.register("dayNoon",{
  "parent"      => "time",
  "name"        => _INTL("12:00"),
  "description" => _INTL("Wait until noon"),
  "effect"      => proc{
    pbSkipTime(12)
    newTime = pbGetTimeNow.strftime("%I:%M %p")
  }
})
RRMenuCommands.register("night",{
  "parent"      => "time",
  "name"        => _INTL("21:00"),
  "description" => _INTL("Wait until evening"),
  "effect"      => proc{
    pbSkipTime(21)
    newTime = pbGetTimeNow.strftime("%I:%M %p")
  }
})
