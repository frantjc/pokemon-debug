PBStuff::POKEMONTOCREST[:MAGMORTAR] = :MAGMCREST

ModCacheInjection.hook(:items) {
  $cache.items[:MAGMCREST] = ItemData.new(:MAGMCREST, {
    name: "Magmortar Crest",
    desc: "Grants Orichalcum Pulse.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
  alias :magmcrest_old_crestStats :crestStats unless method_defined?(:magmcrest_old_crestStats)

  def crestStats
    magmcrest_old_crestStats
    if @crested == :MAGMORTAR
      @ability = :ORICHALCUMPULSE
    end
  end
end

class PokeBattle_Battle
  alias :magmcrest_old_pbCrestEntry :pbCrestEntry unless method_defined?(:magmcrest_old_pbCrestEntry)

  def pbCrestEntry(index, pokemon)
    magmcrest_old_pbCrestEntry(index, pokemon)
    battler = @battlers[index]
    if battler.crested == :MAGMORTAR
      newability = :ORICHALCUMPULSE
      pbShowAbilityBox(battler, attrname: getItemName(:MAGMCREST), crest: true)
      pbDisplay(_INTL("{1} acquired {2}!", battler.pbThis, getAbilityName(newability)))
      pbHideAbilityBox(battler)
    end
  end
end
