PBStuff::POKEMONTOCREST[:ACCELGOR] = :ACCELCREST

ModCacheInjection.hook(:items) {
  $cache.items[:ACCELCREST] = ItemData.new(:ACCELCREST, {
    name: "Accelgor Crest",
    desc: "Grants Skill Link. Boosts special attack and defense.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
  alias :accelcrest_old_crestStats :crestStats

  def crestStats
    if @crested == :ACCELGOR
      @ability = :SKILLLINK
      @spatk *= 1.2
      @defense *= 1.1
    end
    accelcrest_old_crestStats
  end
end

class PokeBattle_Battle
  alias :accelcrest_old_pbCrestEntry :pbCrestEntry

  def pbCrestEntry(index, pokemon)
    battler = @battlers[index]
    if battler.crested == :ACCELGOR
      newability = :SKILLLINK
      pbShowAbilityBox(battler, attrname: getItemName(:ACCELCREST), crest: true)
      pbDisplay(_INTL("{1} acquired {2}!", battler.pbThis, getAbilityName(newability)))
      pbHideAbilityBox(battler)
    end
    accelcrest_old_pbCrestEntry(index, pokemon)
  end
end
