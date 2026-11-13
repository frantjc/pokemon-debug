PBStuff::POKEMONTOCREST[:MAGMORTAR] = :MAGMOCREST

ModCacheInjection.hook(:items) {
  $cache.items[:MAGMOCREST] = ItemData.new(:MAGMOCREST, {
    name: "Magmortar Crest",
    desc: "Grants Orichalcum Pulse.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
  alias :magmocrest_old_crestStats :crestStats unless method_defined?(:magmocrest_old_crestStats)

  def crestStats
    magmocrest_old_crestStats
    if @crested == :MAGMORTAR
      @ability = :ORICHALCUMPULSE
    end
  end
end

class PokeBattle_Battle
  alias :magmocrest_old_pbCrestEntry :pbCrestEntry unless method_defined?(:magmocrest_old_pbCrestEntry)

  def pbCrestEntry(index, pokemon)
    battler = @battlers[index]
    if battler.crested == :MAGMORTAR
      pbShowAbilityBox(battler, attrname: getItemName(:MAGMOCREST), crest: true)
      pbHideAbilityBox(battler)
    end
    magmocrest_old_pbCrestEntry(index, pokemon)
  end
end
