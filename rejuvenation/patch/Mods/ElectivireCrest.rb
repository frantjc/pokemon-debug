PBStuff::POKEMONTOCREST[:ELECTIVIRE] = :ELECTICREST

ModCacheInjection.hook(:items) {
  $cache.items[:ELECTICREST] = ItemData.new(:ELECTICREST, {
    name: "Electivire Crest",
    desc: "Grants Hadron Engine.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
  alias :electicrest_old_crestStats :crestStats unless method_defined?(:electicrest_old_crestStats)

  def crestStats
    electicrest_old_crestStats
    if @crested == :ELECTIVIRE
      @ability = :HADRONENGINE
    end
  end
end

class PokeBattle_Battle
  alias :electicrest_old_pbCrestEntry :pbCrestEntry unless method_defined?(:electicrest_old_pbCrestEntry)

  def pbCrestEntry(index, pokemon)
    battler = @battlers[index]
    if battler.crested == :ELECTIVIRE
      pbShowAbilityBox(battler, attrname: getItemName(:ELECTICREST), crest: true)
      pbHideAbilityBox(battler)
    end
    electicrest_old_pbCrestEntry(index, pokemon)
  end
end
