class Pokedex
  alias :astronite_refreshDex :refreshDex

  def refreshDex(forceRefresh = false)
    astronite_refreshDex(forceRefresh)
    [:COMITE, :COMETEOR, :ASTRONITE].each do |species|
      next unless @dexList&.has_key?(species)
      @dexList[species].forms.each do |formName, formData|
        next unless formData[:gender].is_a?(Array)
        formData[:gender] = { M: false, F: false }
      end
    end
  end
end

ModCacheInjection.hook(:moves) {
  $cache.moves[:VOIDBURST] = MoveData.new(:VOIDBURST, {
    :name => "Void Burst",
    :desc => "With the power of the void, the user attacks two to five times in a row. This may also leave the target confused.",
    :function => 0xF00,
    :type => :PSYCHIC,
    :category => :special,
    :basedamage => 25,
    :accuracy => 85,
    :maxpp => 10,
    :target => :SingleNonUser,
  })
}

PBStuff::ReplacementAnimations[:VOIDBURST] = :PSYBEAM

class PokeBattle_Move_F00 < PokeBattle_Move_0C0
  def pbCanAffectTarget(attacker, opponent, showMessage = false)
    return true if @basedamage > 0
    return opponent.pbCanConfuse?(attacker, self, showMessage: showMessage)
  end

  def pbEffectTarget(attacker, opponent, hitnum = 0, alltargets = nil)
    return if @basedamage > 0

    if @battle.FE == :FAIRYTALE && @move == :SWEETKISS
      if !opponent.damagestate.substitute && opponent.status == :SLEEP
        opponent.pbCureStatus
      end
    end
    opponent.pbConfuse
    if [:BIGTOP, :DANCEFLOOR].include?(@battle.FE) && @move == :TEETERDANCE
      opponent.pbChangeStats(PBStats::DEFENSE, -1, attacker, self, abilitycheck: :hide)
    end
  end

  def pbAdditionalEffect(attacker, opponent)
    return if !opponent.pbCanConfuse?(attacker, self)
    opponent.pbConfuse
  end
end

ModCacheInjection.hook(:pkmn) {
  $cache.pkmn[:COMITE] = MonWrapper.new(:COMITE, {
    "Normal Form" => {
      :name => "Comite",
      :dexnum => 1029,
      :Type1 => :ROCK,
      :Type2 => :PSYCHIC,
      :BaseStats => [50, 30, 55, 75, 40, 60],
      :EVs => [0, 0, 0, 1, 0, 0],
      :Abilities => [:HUSTLE, :STURDY],
      :HiddenAbility => :TRACE,
      :GrowthRate => :Erratic,
      :GenderRatio => :Genderless,
      :BaseEXP => 62,
      :CatchRate => 180,
      :Happiness => 70,
      :EggSteps => 5120,
      :evolutions => [
        { species: :COMETEOR, method: :Level, parameter: 25 },
      ],
      :EggMoves => [
        :METEORMASH, :TRIATTACK, :PAINSPLIT, :POWERSWAP, :GUARDSWAP,
      ],
      :RelearnerMoves => [],
      :Moveset => [
        [1, :ROCKTHROW],
        [1, :HARDEN],
        [8, :CONFUSION],
        [11, :SWIFT],
        [14, :CONFUSERAY],
        [17, :ANCIENTPOWER],
        [20, :TELEPORT],
        [23, :ROCKBLAST],
        [26, :GRAVITY],
        [29, :PSYSHOCK],
        [32, :COSMICPOWER],
        [35, :STEALTHROCK],
        [38, :POWERGEM],
        [41, :RECOVER],
        [44, :PSYCHOSHIFT],
        [47, :MOONBLAST],
        [50, :METEORBEAM],
      ],
      :compatiblemoves => [
        :SUNNYDAY, :TAUNT, :ANCIENTPOWER, :LIGHTSCREEN, :PROTECT, :RAINDANCE, :SAFEGUARD,
        :FLASHCANNON, :ENDURE, :REFLECT, :SANDSTORM, :ROCKTOMB, :KNOCKOFF, :FACADE, :REST,
        :CALMMIND, :SUBSTITUTE, :ZENHEADBUTT, :PSYBEAM, :NASTYPLOT, :BULLDOZE, :ROCKSLIDE,
        :SLEEPTALK, :ALLYSWITCH, :DARKPULSE, :SIGNALBEAM, :MAGICCOAT, :TERRAINPULSE,
        :EXPANDINGFORCE, :SWIFT, :IMPRISON, :TRICKROOM, :IRONDEFENSE, :TRICK, :ACROBATICS,
        :ROUND,
      ],
      :moveexceptions => [],
      :shadowmoves => [
        :SHADOWBLITZ, :SHADOWRUSH, :SHADOWHOLD,
      ],
      :Color => "Brown",
      :EggGroups => [:Mineral],
      :Height => 6,
      :Weight => 607,
      :kind => "Meteorite",
      :dexentry => "It can retract its legs into its body and appear to be an ordinary rock. Stories say they arrived on an asteroid hundreds of years ago.",
      :BattlerPlayerX => 0,
      :BattlerPlayerY => 10,
      :BattlerEnemyX => 0,
      :BattlerEnemyY => 16,
      :BattlerShadowSize => 9,
      :BattlerShadowX => 0,
    },
  })

  $cache.pkmn[:COMETEOR] = MonWrapper.new(:COMETEOR, {
    "Normal Form" => {
      :name => "Cometeor",
      :dexnum => 1030,
      :Type1 => :ROCK,
      :Type2 => :PSYCHIC,
      :BaseStats => [75, 45, 65, 95, 60, 75],
      :EVs => [0, 0, 0, 2, 0, 0],
      :Abilities => [:TECHNICIAN, :STURDY],
      :HiddenAbility => :TRACE,
      :GrowthRate => :Erratic,
      :GenderRatio => :Genderless,
      :BaseEXP => 146,
      :CatchRate => 90,
      :Happiness => 70,
      :EggSteps => 5120,
      :evolutions => [
        { species: :ASTRONITE, method: :Trade },
      ],
      :preevo => { species: :COMITE, form: 0 },
      :EggMoves => [
        :METEORMASH, :TRIATTACK, :PAINSPLIT, :POWERSWAP, :GUARDSWAP,
      ],
      :RelearnerMoves => [],
      :Moveset => [
        [0, :VACUUMWAVE],
        [1, :VACUUMWAVE],
        [1, :ROCKTHROW],
        [1, :HARDEN],
        [1, :CONFUSION],
        [1, :SWIFT],
        [14, :CONFUSERAY],
        [17, :ANCIENTPOWER],
        [20, :TELEPORT],
        [23, :ROCKBLAST],
        [28, :GRAVITY],
        [28, :MAGNETRISE],
        [33, :PSYSHOCK],
        [38, :COSMICPOWER],
        [43, :STEALTHROCK],
        [48, :POWERGEM],
        [53, :RECOVER],
        [58, :PSYCHOSHIFT],
        [63, :MOONBLAST],
        [68, :METEORBEAM],
      ],
      :compatiblemoves => [
        :GIGAIMPACT, :SUNNYDAY, :TAUNT, :ANCIENTPOWER, :LIGHTSCREEN, :PROTECT, :RAINDANCE,
        :SAFEGUARD, :FLASHCANNON, :ENDURE, :REFLECT, :SANDSTORM, :ROCKTOMB, :KNOCKOFF,
        :FACADE, :FLAMECHARGE, :REST, :CALMMIND, :SUBSTITUTE, :ZENHEADBUTT, :PSYBEAM,
        :NASTYPLOT, :BULLDOZE, :ROCKSLIDE, :SLEEPTALK, :ALLYSWITCH, :DARKPULSE, :SIGNALBEAM,
        :MAGICCOAT, :TERRAINPULSE, :EXPANDINGFORCE, :SWIFT, :HYPERBEAM, :IMPRISON, :TRICKROOM,
        :IRONDEFENSE, :TRICK, :ACROBATICS, :ROUND,
      ],
      :moveexceptions => [],
      :shadowmoves => [
        :SHADOWBLITZ, :SHADOWRUSH, :SHADOWHOLD,
      ],
      :Color => "Brown",
      :EggGroups => [:Mineral],
      :Height => 12,
      :Weight => 2075,
      :kind => "Bolide",
      :dexentry => "It levitates in the air with powerful psychic energy. The crystals on its body flash many colors when it meets another of its kind.",
      :BattlerPlayerX => 0,
      :BattlerPlayerY => 10,
      :BattlerEnemyX => 0,
      :BattlerEnemyY => 16,
      :BattlerShadowSize => 13,
      :BattlerShadowX => 0,
    },
  })

  $cache.pkmn[:ASTRONITE] = MonWrapper.new(:ASTRONITE, {
    "Normal Form" => {
      :name => "Astronite",
      :dexnum => 1031,
      :Type1 => :ROCK,
      :Type2 => :PSYCHIC,
      :BaseStats => [80, 85, 85, 115, 75, 105],
      :EVs => [0, 0, 0, 2, 0, 1],
      :Abilities => [:TECHNICIAN, :STURDY],
      :HiddenAbility => :TRACE,
      :GrowthRate => :Erratic,
      :GenderRatio => :Genderless,
      :BaseEXP => 273,
      :CatchRate => 45,
      :Happiness => 70,
      :EggSteps => 5120,
      :preevo => { species: :COMETEOR, form: 0 },
      :EggMoves => [
        :METEORMASH, :TRIATTACK, :PAINSPLIT, :POWERSWAP, :GUARDSWAP,
      ],
      :RelearnerMoves => [],
      :Moveset => [
        [0, :VOIDBURST],
        [0, :METEORMASH],
        [1, :VOIDBURST],
        [1, :METEORMASH],
        [1, :VACUUMWAVE],
        [1, :ROCKTHROW],
        [1, :HARDEN],
        [1, :CONFUSION],
        [1, :SWIFT],
        [14, :CONFUSERAY],
        [17, :ANCIENTPOWER],
        [20, :TELEPORT],
        [23, :ROCKBLAST],
        [28, :GRAVITY],
        [28, :MAGNETRISE],
        [33, :PSYSHOCK],
        [38, :COSMICPOWER],
        [43, :STEALTHROCK],
        [48, :POWERGEM],
        [53, :RECOVER],
        [58, :PSYCHOSHIFT],
        [63, :MOONBLAST],
        [68, :METEORBEAM],
      ],
      :compatiblemoves => [
        :HELPINGHAND, :BODYSLAM, :GIGAIMPACT, :SUNNYDAY, :TAUNT, :ANCIENTPOWER, :LIGHTSCREEN,
        :PROTECT, :RAINDANCE, :SAFEGUARD, :FLASHCANNON, :ENDURE, :REFLECT, :SHOCKWAVE,
        :SANDSTORM, :ROCKTOMB, :KNOCKOFF, :FACADE, :FLAMECHARGE, :REST, :CALMMIND, :SUBSTITUTE,
        :ZENHEADBUTT, :PSYBEAM, :NASTYPLOT, :FIREPUNCH, :THUNDERPUNCH, :ICEPUNCH, :BULLDOZE,
        :ROCKSLIDE, :SLEEPTALK, :ALLYSWITCH, :DARKPULSE, :SIGNALBEAM, :MAGICCOAT, :TERRAINPULSE,
        :EXPANDINGFORCE, :SWIFT, :HYPERBEAM, :IMPRISON, :TRICKROOM, :IRONDEFENSE, :TRICK,
        :ACROBATICS, :ROUND,
      ],
      :moveexceptions => [],
      :shadowmoves => [
        :SHADOWBLITZ, :SHADOWRUSH, :SHADOWHOLD,
      ],
      :Color => "Black",
      :EggGroups => [:Mineral],
      :Height => 17,
      :Weight => 2427,
      :kind => "Traveler",
      :dexentry => "Astronite can exist anywhere, even in the vacuum of space. They are said to roam across the universe colonizing asteroid fields.",
      :BattlerPlayerX => 0,
      :BattlerPlayerY => 10,
      :BattlerEnemyX => 0,
      :BattlerEnemyY => 16,
      :BattlerShadowSize => 19,
      :BattlerShadowX => 0,
    },
  })

  [:COMITE, :COMETEOR, :ASTRONITE].each do |species|
    $cache.pkmn[species].pokemonData.each_value do |formData|
      moves = formData.EggMoves + formData.Moveset.map { |_, move| move }
      formData.instance_variable_set(:@compatiblemoves, (formData.compatiblemoves + moves).uniq)
    end
  end
}
