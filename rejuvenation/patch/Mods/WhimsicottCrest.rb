PBStuff::POKEMONTOCREST[:WHIMSICOTT] = :WHIMSICREST

ModCacheInjection.hook(:items) {
  $cache.items[:WHIMSICREST] = ItemData.new(:WHIMSICREST, {
    name: "Whimsicott Crest",
    desc: "Grants an enhanced Nature Power move pool. Increases Special Attack by 20%.",
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
    else
      whimsicrest_old_crestStats
    end
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
    :INDOOR            => :HURRICANE,
    :DEUXFINALIS       => :JUDGMENT,
    :HOLY              => :JUDGMENT,
    :FACTORY           => :LIGHTTHATBURNSTHESKY,
    :MIRROR            => :MIRRORSHOT,
    :MISTY             => :MISTYEXPLOSION,
    :BEWITCHED         => :MOONBLAST,
    :HAUNTED           => :MOONGEISTBEAM,
    :SWAMP             => :MUDDYWATER,
    :WATERSURFACE      => :ORIGINPULSE,
    :BIGTOP            => :PETALDANCE,
    :CAVE              => :POWERGEM,
    :CRYSTALCAVERN     => :POWERGEM,
    :ROCKY             => :POWERGEM,
    :DARKCRYSTALCAVERN => :PRISMATICLASER,
    :GLITCH            => :PRISMATICLASER,
    :PSYTERRAIN        => :PSYSTRIKE,
    :CHESS             => :PSYCHIC,
    :ASHENBEACH        => :SANDSEARSTORM,
    :DESERT            => :SCORCHINGSANDS,
    :COLOSSEUM         => :SECRETSWORD,
    :FLOWERGARDEN      => :SEEDFLARE,
    :FOREST            => :SEEDFLARE,
    :GRASSY            => :SEEDFLARE,
    :CORRUPTED         => :SLUDGEWAVE,
    :MURKWATERSURFACE  => :SLUDGEWAVE,
    :WASTELAND         => :SLUDGEWAVE,
    :DIMENSIONAL       => :SPACIALREND,
    :VOLCANICTOP       => :STEAMERUPTION,
    :VOLCANIC          => :TERASTARSTORM,
    :MOUNTAIN          => :THUNDER,
    :CONCERT1          => :TORCHSONG,
    :INVERSE           => :TRIATTACK,
    :UNDERWATER        => :WATERPULSE,
    :RAINBOW           => :WEATHERBALL,
    :ELECTERRAIN       => :WILDBOLTSTORM,
  }

  alias :whimsicrest_old_getNaturePowerMove :getNaturePowerMove

  def getNaturePowerMove(attacker = nil)
    if attacker&.hasCrest?(:WHIMSICOTT)
      return WHIMSICOTT_CREST_NATURE_POWER[@field.effect] || :TRIATTACK
    end
    whimsicrest_old_getNaturePowerMove
  end
end

class PokeBattle_Move_0B3
  alias :whimsicrest_old_pbEffectTarget :pbEffectTarget

  def pbEffectTarget(attacker, opponent, hitnum = 0, alltargets = nil)
    move = @battle.getNaturePowerMove(attacker)
    attacker.pbUseMoveSimple(move, -1, opponent.index, callermove: self)
  end
end
