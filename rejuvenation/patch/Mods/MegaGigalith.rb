if !defined?(PBStuff::POKEMONTOMEGASTONE[:GIGALITH])
  PBStuff::POKEMONTOMEGASTONE[:GIGALITH] = []
end
  
PBStuff::POKEMONTOMEGASTONE[:GIGALITH].append(:GIGALITE)

ModCacheInjection.hook(:items) {
  $cache.items[:GIGALITE] = ItemData.new(:GIGALITE, {
    name: "Gigalite",
    :desc => "One variety of Mega Stone. Have Gigalith hold it, and this stone will enable it to Mega Evolve in battle.",
    price: 999,
    :crystal => true,
    noUseInBattle: true,
    noUse: true,
  })
}

ModCacheInjection.hook(:pkmn) {
  ModCacheInjection.createNewForm(:GIGALITH, "Mega Form", 2, {
    :baseForm => "Normal Form",
    :Type1 => :ROCK,
    :BaseStats => [85, 30, 130, 150, 90, 130],
    :Abilities => [:SANDFORCE],
    :HiddenAbility => nil,
    :BattlerPlayerX => -1,
    :BattlerPlayerY => 15,
    :BattlerEnemyX => -2,
    :BattlerEnemyY => 21,
    :BattlerShadowSize => 39,
    :BattlerShadowX => -2,
    :Mega => true,
  })

  addFormDataAtRuntime(:GIGALITH, "Normal Form", {
    :MegaEvolutions => {
      :GIGALITE => "Mega Form",
    },
  })
}
