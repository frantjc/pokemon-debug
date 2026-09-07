PBStuff::POKEMONTOCREST[:YANMEGA] = :YANMECREST

ModCacheInjection.hook(:items) {
  $cache.items[:YANMECREST] = ItemData.new(:YANMECREST, {
    name: "Yanmega Crest",
    desc: "Grants one Speed Boost, Tinted Lens, and Dragon STAB and resistances. Ancient Power becomes Dragon Pulse.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Move
  alias :yanmecrest_old_pbModifySTAB :pbModifySTAB unless method_defined?(:yanmecrest_old_pbModifySTAB)

  def pbModifySTAB(stabmult, type, attacker, opponent)
    stabmult = yanmecrest_old_pbModifySTAB(stabmult, type, attacker, opponent)
    if attacker.crested == :YANMEGA && type == :DRAGON && !attacker.hasType?(:DRAGON)
      stabmult = PBMults::STAB[1]
    end
    return stabmult
  end

  alias :yanmecrest_old_irregularTypeMods :irregularTypeMods unless method_defined?(:yanmecrest_old_irregularTypeMods)

  def irregularTypeMods(attacker, opponent, typemod, type)
    typemod = yanmecrest_old_irregularTypeMods(attacker, opponent, typemod, type)
    if opponent.crested == :YANMEGA
      typemod *= Typemod.half if PBTypes.oneTypeEff(type, :DRAGON, inverse: @battle.inverse?).resisted?
      typemod = Typemod.zero if PBTypes.oneTypeEff(type, :DRAGON, inverse: @battle.inverse?).immune?
    end
    return typemod
  end
end

class PokeBattle_Battler
  alias :yanmecrest_old_crestStats :crestStats unless method_defined?(:yanmecrest_old_crestStats)

  def crestStats
    if @crested == :YANMEGA
      @ability = :TINTEDLENS

      @moves.each_with_index do |move, i|
        next unless move.id == :ANCIENTPOWER

        old_pp = move.pp
        old_totalpp = move.totalpp

        @moves[i] = PokeBattle_Move.pbFromPBMove(@battle, PBMove.new(:DRAGONPULSE), @pokemon)
        @moves[i].pp = (old_pp * (@moves[i].totalpp.to_f / old_totalpp)).floor
        break
      end
    end
    yanmecrest_old_crestStats
  end
end

class PokeBattle_Battle
  alias :yanmecrest_old_pbCrestEntry :pbCrestEntry unless method_defined?(:yanmecrest_old_pbCrestEntry)

  def pbCrestEntry(index, pokemon)
    battler = @battlers[index]
    if battler.crested == :YANMEGA
      pbShowAbilityBox(battler, attrname: getItemName(:YANMECREST), crest: true)
      pbDisplay(_INTL("{1} embraced its Ancient Power!", battler.pbThis))
      pbHideAbilityBox(battler)
    end
    yanmecrest_old_pbCrestEntry(index, pokemon)
  end

  alias :yanmecrest_old_pbCrestEffects :pbCrestEffects unless method_defined?(:yanmecrest_old_pbCrestEffects)

  def pbCrestEffects(index, pokemon)
    yanmecrest_old_pbCrestEffects(index, pokemon)
    battler = @battlers[index]
    if battler.crested == :YANMEGA
      battler.pbChangeStats(PBStats::SPEED, 1, battler, nil, abilitycheck: :skip)
    end
  end
end
