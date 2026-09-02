class Pokedex
  alias :diastryx_refreshDex :refreshDex

  def refreshDex(forceRefresh = false)
    diastryx_refreshDex(forceRefresh)
    [:GRIZZLET, :GEOGRIFF, :DIASTRYX].each do |species|
      next unless @dexList&.has_key?(species)
      @dexList[species].forms.each do |formName, formData|
        next unless formData[:gender].is_a?(Array)
        formData[:gender] = { M: false, F: false }
      end
    end
  end
end

ModCacheInjection.hook(:moves) {
  $cache.moves[:ADAMANTWING] = MoveData.new(:ADAMANTWING, {
    :name => "Adamant Wing",
    :desc => "The user strikes twice by launching sharp gemstones. This move deals extra hits if the user's Defense is boosted.",
    :function => 0xF01,
    :type => :ROCK,
    :category => :physical,
    :basedamage => 40,
    :accuracy => 90,
    :maxpp => 5,
    :target => :SingleNonUser,
    :sharpmove => true,
  })
}

class PokeBattle_Move_F01 < PokeBattle_Move
  def pbIsMultiHit
    return true
  end

  def pbNumHits(attacker)
    # Base 2 hits, +1 per pair of Defense boosts (+2, +4, +6), max 5
    def_stage = attacker.stages[PBStats::DEFENSE]
    return [2 + (def_stage / 2).floor, 5].min
  end
end

PBStuff::ReplacementAnimations[:ADAMANTWING] = :WINGATTACK

ModCacheInjection.hook(:abil) {
  $cache.abil[:CRYSTALLIZE] = AbilityData.new(:CRYSTALLIZE, {
    name: "Crystallize",
    :desc => "Normal-type moves become Rock-type moves...",
    :fullDesc => "Normal-type moves become Rock-type moves and deal 20% more damage. This overrides Ion Deluge.",
    :coreEffectModifier => -6,
  })
}

alias :crystallize_pbAbilityMoveTypeChange :pbAbilityMoveTypeChange

def pbAbilityMoveTypeChange(move, ability, type, field = nil)
  return :ROCK if ability == :CRYSTALLIZE && type == :NORMAL && !PBStuff::ZMOVES.include?(move)
  return crystallize_pbAbilityMoveTypeChange(move, ability, type, field)
end

class PokeBattle_Move
  alias :crystallize_pbCalcDamage :pbCalcDamage

  def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = {opponent.index => []}, movetype: nil)
    damage = crystallize_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype)
    if attacker.ability == :CRYSTALLIZE
      type = movetype.nil? ? pbType(attacker) : movetype
      damage = (damage * 1.2).round if type == :ROCK && @type == :NORMAL
    end
    damage
  end
end

ModCacheInjection.hook(:pkmn) {
  $cache.pkmn[:GRIZZLET] = MonWrapper.new(:GRIZZLET, {
    "Normal Form" => {
      :name => "Grizzlet",
      :dexnum => 1026,
      :Type1 => :ROCK,
      :BaseStats => [41, 70, 64, 45, 30, 50],
      :EVs => [0, 1, 0, 0, 0, 0],
      :Abilities => [:CRYSTALLIZE],
      :HiddenAbility => :NOGUARD,
      :GrowthRate => :Slow,
      :GenderRatio => :FemHalf,
      :BaseEXP => 60,
      :CatchRate => 45,
      :Happiness => 35,
      :EggSteps => 10240,
      :evo => {
        :species => :GEOGRIFF,
        :form => 0,
      },
      :EggMoves => [
        :AIRCUTTER, :LASERFOCUS, :DRILLPECK, :HEADSMASH, :FURYATTACK, :DRILLRUN, :SANDTOMB, :WIDEGUARD,
      ],
      :RelearnerMoves => [],
      :Moveset => [
        [1, :PECK],
        [1, :HONECLAWS],
        [6, :QUICKATTACK],
        [10, :METALCLAW],
        [16, :IRONDEFENSE],
        [22, :SLASH],
        [26, :AIRSLASH],
        [30, :ROCKPOLISH],
        [36, :POWERGEM],
        [42, :NIGHTSLASH],
        [46, :FOCUSENERGY],
        [50, :STONEEDGE],
      ],
      :compatiblemoves => [
        :SNARL, :HELPINGHAND, :ROAR, :BODYSLAM, :GIGAIMPACT, :WORKUP, :SUNNYDAY, :METALCLAW,
        :ANCIENTPOWER, :LIGHTSCREEN, :PROTECT, :RAINDANCE, :SAFEGUARD, :ENDURE, :DIG, :REFLECT,
        :SANDSTORM, :ROCKTOMB, :AERIALACE, :FACADE, :REST, :ROOST, :CALMMIND,
        :SUBSTITUTE, :AIRSLASH, :ZENHEADBUTT, :SHADOWCLAW, :DAZZLINGGLEAM, :ROCKSLIDE,
        :SLEEPTALK, :STOMPINGTANTRUM, :SWIFT, :IRONDEFENSE, :ROUND,
      ],
      :moveexceptions => [],
      :shadowmoves => [
        :SHADOWBLITZ, :SHADOWRUSH, :SHADOWHOLD,
      ],
      :Color => "Brown",
      :EggGroups => [:Flying, :Mineral],
      :Height => 8,
      :Weight => 114,
      :kind => "Gryph",
      :dexentry => "A hardy species that lives in mountainous areas. It uses its beak to crack rocks in search of quartz crystals, which it eats to prepare for evolution.",
      :BattlerPlayerX => 0,
      :BattlerPlayerY => 15,
      :BattlerEnemyX => 0,
      :BattlerEnemyY => 21,
      :BattlerShadowSize => 9,
      :BattlerShadowX => 0,
      :evolutions => [
        { species: :GEOGRIFF, method: :Level, parameter: 42 },
      ],
    },
  })

  $cache.pkmn[:GEOGRIFF] = MonWrapper.new(:GEOGRIFF, {
    "Normal Form" => {
      :name => "Geogriff",
      :dexnum => 1027,
      :Type1 => :ROCK,
      :BaseStats => [56, 95, 84, 65, 50, 70],
      :EVs => [0, 2, 0, 0, 0, 0],
      :Abilities => [:CRYSTALLIZE],
      :HiddenAbility => :NOGUARD,
      :GrowthRate => :Slow,
      :GenderRatio => :FemHalf,
      :BaseEXP => 147,
      :CatchRate => 45,
      :Happiness => 35,
      :EggSteps => 10240,
      :evo => {
        :species => :DIASTRYX,
        :form => 0,
      },
      :EggMoves => [
        :AIRCUTTER, :LASERFOCUS, :DRILLPECK, :HEADSMASH, :FURYATTACK, :DRILLRUN, :SANDTOMB, :WIDEGUARD,
      ],
      :RelearnerMoves => [],
      :Moveset => [
        [0, :CRUSHCLAW],
        [1, :ACCELEROCK],
        [1, :FOCUSENERGY],
        [1, :PECK],
        [1, :HONECLAWS],
        [1, :QUICKATTACK],
        [1, :METALCLAW],
        [16, :IRONDEFENSE],
        [22, :SLASH],
        [26, :AIRSLASH],
        [30, :ROCKPOLISH],
        [36, :POWERGEM],
        [44, :NIGHTSLASH],
        [50, :ROOST],
        [56, :STONEEDGE],
      ],
      :compatiblemoves => [
        :SNARL, :HELPINGHAND, :ROAR, :BODYSLAM, :GIGAIMPACT, :WORKUP, :SUNNYDAY, :METALCLAW,
        :ANCIENTPOWER, :LIGHTSCREEN, :PROTECT, :RAINDANCE, :SAFEGUARD, :ENDURE, :DIG, :REFLECT,
        :SANDSTORM, :ROCKTOMB, :AERIALACE, :KNOCKOFF, :FACADE, :REST, :ROOST, :CALMMIND,
        :SUBSTITUTE, :AIRSLASH, :FALSESWIPE, :ZENHEADBUTT, :SHADOWCLAW, :BULLDOZE,
        :DAZZLINGGLEAM, :ROCKSLIDE, :SLEEPTALK, :STOMPINGTANTRUM, :SWIFT, :HEAVYSLAM,
        :IRONDEFENSE, :ROUND,
      ],
      :moveexceptions => [],
      :shadowmoves => [
        :SHADOWBLITZ, :SHADOWRUSH, :SHADOWHOLD,
      ],
      :Color => "Brown",
      :EggGroups => [:Flying, :Mineral],
      :Height => 13,
      :Weight => 540,
      :kind => "Crystal Claw",
      :dexentry => "When the tiny crystals that continuously grow from beneath its fur shatter, it enters a state of hibernation, and emerges months later with a sharper set.",
      :BattlerPlayerX => 0,
      :BattlerPlayerY => 15,
      :BattlerEnemyX => 0,
      :BattlerEnemyY => 21,
      :BattlerShadowSize => 19,
      :BattlerShadowX => 0,
      :evolutions => [
        { species: :DIASTRYX, method: :Level, parameter: 62 },
      ],
    },
  })

  $cache.pkmn[:DIASTRYX] = MonWrapper.new(:DIASTRYX, {
    "Normal Form" => {
      :name => "Diastryx",
      :dexnum => 1028,
      :Type1 => :ROCK,
      :Type2 => :FLYING,
      :BaseStats => [76, 130, 119, 95, 80, 100],
      :EVs => [0, 0, 3, 0, 0, 0],
      :Abilities => [:CRYSTALLIZE],
      :HiddenAbility => :NOGUARD,
      :GrowthRate => :Slow,
      :GenderRatio => :FemHalf,
      :BaseEXP => 300,
      :CatchRate => 45,
      :Happiness => 35,
      :EggSteps => 10240,
      :preevo => {
        :species => :GEOGRIFF,
        :form => 0,
      },
      :EggMoves => [
        :AIRCUTTER, :LASERFOCUS, :DRILLPECK, :HEADSMASH, :FURYATTACK, :DRILLRUN, :SANDTOMB, :WIDEGUARD,
      ],
      :RelearnerMoves => [],
      :Moveset => [
        [0, :ADAMANTWING],
        [1, :CRUSHCLAW],
        [1, :ACCELEROCK],
        [1, :FOCUSENERGY],
        [1, :PECK],
        [1, :HONECLAWS],
        [1, :QUICKATTACK],
        [16, :IRONDEFENSE],
        [22, :SLASH],
        [26, :AIRSLASH],
        [30, :ROCKPOLISH],
        [36, :POWERGEM],
        [44, :NIGHTSLASH],
        [50, :ROOST],
        [56, :STONEEDGE],
        [66, :SKYATTACK],
      ],
      :compatiblemoves => [
        :SNARL, :HELPINGHAND, :ROAR, :BODYSLAM, :GIGAIMPACT, :WORKUP, :SUNNYDAY, :TAUNT, :METALCLAW,
        :ANCIENTPOWER, :LIGHTSCREEN, :PROTECT, :RAINDANCE, :SAFEGUARD, :ENDURE, :DIG, :BRICKBREAK, :REFLECT,
        :SANDSTORM, :ROCKTOMB, :AERIALACE, :KNOCKOFF, :FACADE, :REST, :ROOST, :WEATHERBALL, :CALMMIND,
        :SUBSTITUTE, :AIRSLASH, :FALSESWIPE, :ZENHEADBUTT, :SHADOWCLAW, :SUCKERPUNCH, :BULLDOZE,
        :DAZZLINGGLEAM, :ROCKSLIDE, :SLEEPTALK, :STOMPINGTANTRUM, :BREAKINGSWIPE, :DUALWINGBEAT, :SWIFT,
        :HYPERBEAM, :IRONDEFENSE, :ROUND, :SLASHANDBURN, :DRAGONASCENT, :SKYDROP, :WINGATTACK, :PECK,
      ],
      :moveexceptions => [],
      :shadowmoves => [
        :SHADOWBLITZ, :SHADOWRUSH, :SHADOWHOLD,
      ],
      :Color => "Brown",
      :EggGroups => [:Flying, :Mineral],
      :Height => 20,
      :Weight => 1980,
      :kind => "Crystal Wing",
      :dexentry => "A powerful apex predator. It claims entire mountains as its territory, gliding high above and using its keen eyesight to detect any intruders or threats.",
      :BattlerPlayerX => 0,
      :BattlerPlayerY => 15,
      :BattlerEnemyX => 0,
      :BattlerEnemyY => 21,
      :BattlerShadowSize => 29,
      :BattlerShadowX => 0,
    },
  })

  [:GRIZZLET, :GEOGRIFF, :DIASTRYX].each do |species|
    $cache.pkmn[species].pokemonData.each_value do |formData|
      moves = formData.EggMoves + formData.Moveset.map { |_, move| move }
      formData.instance_variable_set(:@compatiblemoves, (formData.compatiblemoves + moves).uniq)
    end
  end
}
