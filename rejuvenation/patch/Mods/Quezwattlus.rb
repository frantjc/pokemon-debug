class Pokedex
  alias :quezwattlus_refreshDex :refreshDex

  def refreshDex(forceRefresh = false)
    astronite_refreshDex(forceRefresh)
    [:AMPERINCUS, :QUEZWATTLUS].each do |species|
      next unless @dexList&.has_key?(species)
      @dexList[species].forms.each do |formName, formData|
        next unless formData[:gender].is_a?(Array)
        formData[:gender] = { M: false, F: false }
      end
    end
  end
end

ModCacheInjection.hook(:pkmn) {
  $cache.pkmn[:AMPERINCUS] = MonWrapper.new(:AMPERINCUS, {
    "Normal Form" => {
      :name => "Amperincus",
      :dexnum => 1032,
      :Type1 => :GHOST,
      :Type2 => :ELECTRIC,
      :BaseStats => [55, 90, 53, 55, 60, 67],
      :EVs => [0, 1, 0, 0, 0, 0],
      :Abilities => [:SOUNDPROOF],
      :HiddenAbility => :GALVANIZE,
      :GrowthRate => :Slow,
      :GenderRatio => :FemEighth,
      :BaseEXP => 76,
      :CatchRate => 45,
      :Happiness => 70,
      :EggSteps => 7680,
      :evolutions => [
        { species: :QUEZWATTLUS, method: :HasMove, parameter: :ANCIENTPOWER },
      ],
      :EggMoves => [
        :CONFUSERAY, :SKYATTACK, :PLUCK, :STEELWING, :SPITE, :BONERUSH, :SCREECH, :CHARGE, :SCARYFACE,
      ],
      :RelearnerMoves => [],
      :Moveset => [
        [1, :ASTONISH],
        [1, :EERIEIMPULSE],
        [13, :SHADOWSNEAK],
        [17, :FURYATTACK],
        [21, :NIGHTSHADE],
        [25, :METALSOUND],
        [29, :DISCHARGE],
        [37, :UPROAR],
        [40, :ANCIENTPOWER],
        [42, :SHADOWBONE],
        [46, :MAGNETRISE],
        [50, :PHANTOMFORCE],
      ],
      :compatiblemoves => [
        :SNARL, :ROAR, :GIGAIMPACT, :TAUNT, :ANCIENTPOWER, :LIGHTSCREEN, :PROTECT, :RAINDANCE, :ENDURE, :SHOCKWAVE, :AERIALACE,
        :FACADE, :REST, :ROOST, :WEATHERBALL, :VOLTSWITCH, :SUBSTITUTE, :AIRSLASH, :ZENHEADBUTT, :SHADOWCLAW, :THUNDERWAVE, :DAZZLINGGLEAM,
        :SLEEPTALK, :SIGNALBEAM, :DUALWINGBEAT, :SWIFT, :HYPERBEAM, :METALSOUND, :CURSE, :TRASHTALK, :ACROBATICS, :ROUND,
      ],
      :moveexceptions => [],
      :shadowmoves => [
        :SHADOWBLITZ, :SHADOWRUSH, :SHADOWHOLD,
      ],
      :Color => "White",
      :EggGroups => [:Flying],
      :Height => 7,
      :Weight => 182,
      :kind => "Shrieking",
      :dexentry => "This ancient pterosaur Pokemon has somehow revived as a ghost. When they flock, their shrill calls can drown out the sound of jet engines.",
      :BattlerPlayerX => 0,
      :BattlerPlayerY => 0,
      :BattlerEnemyX => 0,
      :BattlerEnemyY => 0,
      :BattlerShadowSize => 1,
    },
  })

  $cache.pkmn[:QUEZWATTLUS] = MonWrapper.new(:QUEZWATTLUS, {
    "Normal Form" => {
      :name => "Quezwattlus",
      :dexnum => 1033,
      :Type1 => :GHOST,
      :Type2 => :ELECTRIC,
      :BaseStats => [70, 120, 73, 75, 85, 97],
      :EVs => [0, 1, 0, 0, 0, 0],
      :Abilities => [:SOUNDPROOF],
      :HiddenAbility => :GALVANIZE,
      :GrowthRate => :Slow,
      :GenderRatio => :FemEighth,
      :BaseEXP => 182,
      :CatchRate => 45,
      :Happiness => 70,
      :EggSteps => 7680,
      :preevo => { species: :AMPERINCUS, form: 0 },
      :EggMoves => [
        :CONFUSERAY, :SKYATTACK, :PLUCK, :STEELWING, :SPITE, :BONERUSH, :SCREECH, :CHARGE, :SCARYFACE,
      ],
      :RelearnerMoves => [],
      :Moveset => [
        [0, :SUPERCELLSLAM],
        [1, :SUPERCELLSLAM],
        [1, :BRAVEBIRD],
        [1, :ASTONISH],
        [1, :EERIEIMPULSE],
        [1, :PECK],
        [1, :SPARK],
        [13, :SHADOWSNEAK],
        [17, :FURYATTACK],
        [21, :NIGHTSHADE],
        [25, :METALSOUND],
        [29, :DISCHARGE],
        [37, :UPROAR],
        [40, :ANCIENTPOWER],
        [42, :SHADOWBONE],
        [46, :MAGNETRISE],
        [50, :PHANTOMFORCE],
        [54, :BOOMBURST],
      ],
      :compatiblemoves => [
        :SNARL, :ROAR, :GIGAIMPACT, :TAUNT, :ANCIENTPOWER, :LIGHTSCREEN, :PROTECT, :RAINDANCE, :ENDURE, :SHOCKWAVE, :AERIALACE,
        :FACADE, :REST, :ROOST, :WEATHERBALL, :VOLTSWITCH, :SUBSTITUTE, :AIRSLASH, :ZENHEADBUTT, :SHADOWCLAW, :THUNDERWAVE, :DAZZLINGGLEAM,
        :SLEEPTALK, :SIGNALBEAM, :DUALWINGBEAT, :SWIFT, :HYPERBEAM, :METALSOUND, :CURSE, :TRASHTALK, :ACROBATICS, :ROUND,
      ],
      :moveexceptions => [],
      :shadowmoves => [
        :SHADOWBLITZ, :SHADOWRUSH, :SHADOWHOLD,
      ],
      :Color => "White",
      :EggGroups => [:Flying],
      :Height => 32,
      :Weight => 656,
      :kind => "Shrieking",
      :dexentry => "The deafening screech it emits can cause your ears to ring for days. When it lived, it was an aerial predator, but now it mainly stays on the ground.",
      :BattlerPlayerX => 0,
      :BattlerPlayerY => 0,
      :BattlerEnemyX => 0,
      :BattlerEnemyY => 0,
      :BattlerShadowSize => 1,
    },
  })
}
