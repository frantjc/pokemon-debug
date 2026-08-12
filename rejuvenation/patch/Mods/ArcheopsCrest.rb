PBStuff::POKEMONTOCREST[:ARCHEOPS] = :ARCHCREST

ModCacheInjection.hook(:items) {
  $cache.items[:ARCHCREST] = ItemData.new(:ARCHCREST, {
    name: "Archeops Crest",
    desc: "Grants Defiant. Upon switching in, opponent Intimidates.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
  alias :archcrest_old_crestStats :crestStats

  def crestStats
    if @crested == :ARCHEOPS
      @ability = :DEFIANT
    else
      archcrest_old_crestStats
    end
  end
end

class PokeBattle_Battle
  alias :archcrest_old_pbCrestEntry :pbCrestEntry

  def pbCrestEntry(index, pokemon)
    battler = @battlers[index]
    if battler.crested == :ARCHEOPS
      newability = :DEFIANT
      pbShowAbilityBox(battler, attrname: getItemName(:ARCHCREST), crest: true)
      pbDisplay(_INTL("{1} acquired {2}!", battler.pbThis, getAbilityName(newability)))
      pbHideAbilityBox(battler)
    else
      archcrest_old_pbCrestEntry(index, pokemon)
    end
  end

  alias :archcrest_old_pbCrestEffects :pbCrestEffects

  def pbCrestEffects(index, pokemon)
    archcrest_old_pbCrestEffects(index, pokemon)
    battler = @battlers[index]
    if battler.crested == :ARCHEOPS
      battler.pbChangeStats(PBStats::ATTACK, -1, battler.pbOpposing1, :Intimidate)
    end
  end
end
