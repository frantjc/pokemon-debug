PBStuff::POKEMONTOCREST[:WHIMSICOTT] = :WHIMSICREST

ModCacheInjection.hook(:items) {
  $cache.items[:WHIMSICREST] = ItemData.new(:WHIMSICREST, {
    name: "Whimsicott Crest",
    desc: "Grants an enhanced Nature Power move pool. Boosts accuracy, defense, and special attack.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
  alias :whimsicrest_old_crestStats :crestStats

  def crestStats
    if @crested == :WHIMSICOTT
      @spatk *= 1.2
      @defense *= 1.1
    end
    whimsicrest_old_crestStats
  end
end

class PokeBattle_Battle
  WHIMSICOTT_CREST_NATURE_POWER = {
    :CORROSIVE         => :APPLEACID,
    :CORROSIVEMIST     => :APPLEACID,
    :ICY               => :BITTERMALICE,
    :SKY               => :BLEAKWINDSTORM,
    :SNOWYMOUNTAIN     => :BLIZZARD,
    :CITY              => :BUGBUZZ,
    :SHORTCIRCUIT      => :DAZZLINGGLEAM,
    :NEWWORLD          => :DOOMDESIRE,
    :STARLIGHT         => :DOOMDESIRE,
    :DRAGONSDEN        => :DRACOMETEOR,
    :FAIRYTALE         => :DRAININGKISS,
    :DEEPEARTH         => :EARTHPOWER,
    :INFERNAL          => :SEARINGSHOT,
    :BACKALLEY         => :FLASHCANNON,
    :FROZENDIMENSION   => :FREEZINGGLARE,
    :DEUXFINALIS       => :JUDGMENT,
    :HOLY              => :JUDGMENT,
    :FACTORY           => :DISCHARGE,
    :MIRROR            => :MIRRORSHOT,
    :MISTY             => :MISTYEXPLOSION,
    :BEWITCHED         => :MOONBLAST,
    :HAUNTED           => :MOONGEISTBEAM,
    :SWAMP             => :MUDDYWATER,
    :WATERSURFACE      => :HYDROPUMP,
    :BIGTOP            => :PETALDANCE,
    :CAVE              => :POWERGEM,
    :CRYSTALCAVERN     => :POWERGEM,
    :ROCKY             => :POWERGEM,
    :DARKCRYSTALCAVERN => :PRISMATICLASER,
    :GLITCH            => :PRISMATICLASER,
    :PSYTERRAIN        => :PSYSTRIKE,
    :CHESS             => :PSYCHIC,
    :ASHENBEACH        => :SCORCHINGSANDS,
    :DESERT            => :SCORCHINGSANDS,
    :COLOSSEUM         => :SECRETSWORD,
    :FLOWERGARDEN      => :SEEDFLARE,
    :FLOWERGARDEN1     => :SEEDFLARE,
    :FLOWERGARDEN2     => :SEEDFLARE,
    :FLOWERGARDEN3     => :SEEDFLARE,
    :FLOWERGARDEN4     => :SEEDFLARE,
    :FLOWERGARDEN5     => :SEEDFLARE,
    :FOREST            => :SEEDFLARE,
    :GRASSY            => :SEEDFLARE,
    :CORRUPTED         => :SLUDGEWAVE,
    :MURKWATERSURFACE  => :SLUDGEWAVE,
    :WASTELAND         => :SLUDGEWAVE,
    :DIMENSIONAL       => :SPACIALREND,
    :VOLCANICTOP       => :SUPERHEATED,
    :VOLCANICTOP       => :STEAMERUPTION,
    :BURNING           => :SEARINGSHOT,
    :VOLCANIC          => :SEARINGSHOT,
    :MOUNTAIN          => :THUNDER,
    :CROWD             => :FOCUSBLAST,
    :CONCERT1          => :TORCHSONG,
    :CONCERT2          => :FEVERPITCH,
    :CONCERT3          => :FEVERPITCH,
    :CONCERT4          => :FEVERPITCH,
    :INVERSE           => :TRIATTACK,
    :UNDERWATER        => :WATERPULSE,
    :RAINBOW           => :WEATHERBALL,
    :ELECTERRAIN       => :WILDBOLTSTORM,
  }

  alias :whimsicrest_old_getNaturePowerMove :getNaturePowerMove

  def getNaturePowerMove(attacker = nil)
    if attacker&.hasCrest?(:WHIMSICOTT)
      return WHIMSICOTT_CREST_NATURE_POWER[@field.effect] || :HURRICANE
    end
    whimsicrest_old_getNaturePowerMove
  end

  alias :whimsicrest_old_pbCrestEntry :pbCrestEntry

  def pbCrestEntry(index, pokemon)
    battler = @battlers[index]
    if battler.crested == :WHIMSICOTT
      pbShowAbilityBox(battler, attrname: getItemName(:WHIMSICREST), crest: true)
      pbDisplay(_INTL("{1} became one with nature!", battler.pbThis))
      pbHideAbilityBox(battler)
    end
    whimsicrest_old_pbCrestEntry(index, pokemon)
  end

  alias :whimsicrest_old_pbCrestEffects :pbCrestEffects

  def pbCrestEffects(index, pokemon)
    whimsicrest_old_pbCrestEffects(index, pokemon)
    battler = @battlers[index]
    if battler.crested == :WHIMSICOTT
      battler.pbIncreaseStatBasic(PBStats::ACCURACY, 1)
    end
  end
end

class PokeBattle_Move_0B3
  def pbEffectTarget(attacker, opponent, hitnum = 0, alltargets = nil)
    move = @battle.getNaturePowerMove(attacker)
    attacker.pbUseMoveSimple(move, -1, opponent.index, callermove: self)
  end
end
