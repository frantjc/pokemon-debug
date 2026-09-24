PBStuff::POKEMONTOCREST[:ELECTIVIRE] = :ELECTCREST

ModCacheInjection.hook(:items) {
  $cache.items[:ELECTCREST] = ItemData.new(:ELECTCREST, {
    name: "Electivire Crest",
    desc: "Grants Hadron Engine.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
  alias :electcrest_old_crestStats :crestStats unless method_defined?(:electcrest_old_crestStats)

  def crestStats
    if @crested == :ELECTIVIRE
      @ability = :HADRONENGINE
    end
    electcrest_old_crestStats
  end
end

class PokeBattle_Battle
  alias :electcrest_old_pbCrestEntry :pbCrestEntry unless method_defined?(:electcrest_old_pbCrestEntry)

  def pbCrestEntry(index, pokemon)
    battler = @battlers[index]
    if battler.crested == :ELECTIVIRE
      newability = :HADRONENGINE
      pbShowAbilityBox(battler, attrname: getItemName(:ELECTCREST), crest: true)
      pbDisplay(_INTL("{1} acquired {2}!", battler.pbThis, getAbilityName(newability)))
      pbHideAbilityBox(battler)
    end
    electcrest_old_pbCrestEntry(index, pokemon)
  end
end
