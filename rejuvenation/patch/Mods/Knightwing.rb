class Pokedex
  alias :knightwing_refreshDex :refreshDex unless method_defined?(:knightwing_refreshDex)

  def refreshDex(forceRefresh = false)
    knightwing_refreshDex(forceRefresh)
    [:KNIGHTWING].each do |species|
      next unless @dexList&.has_key?(species)
      @dexList[species].forms.each do |formName, formData|
        next unless formData[:gender].is_a?(Array)
        formData[:gender] = { M: false, F: false }
      end
    end
  end
end

class PokedexListEntry
  alias :knightwing_setSeen :setSeen unless method_defined?(:knightwing_setSeen)
  alias :knightwing_setOwned :setOwned unless method_defined?(:knightwing_setOwned)

  def knightwing_fixGenderData(form)
    @forms[form][:gender] = { M: false, F: false } if @forms[form][:gender].is_a?(Array)
  end

  def setSeen(form = 0, gender = :M, shiny = false)
    resolvedForm = form.is_a?(Numeric) ? $cache.pkmn[@species].forms[form] : form
    resolvedForm = @forms.keys[0] if !$cache.pkmn[@species].forms.value?(resolvedForm) || resolvedForm.nil?
    knightwing_fixGenderData(resolvedForm)
    knightwing_setSeen(form, gender, shiny)
  end

  def setOwned(form = 0, gender = :M, shiny = false, shadow = false)
    resolvedForm = form.is_a?(Numeric) ? $cache.pkmn[@species].forms[form] : form
    resolvedForm = @forms.keys[0] if !$cache.pkmn[@species].forms.value?(resolvedForm) || resolvedForm.nil?
    knightwing_fixGenderData(resolvedForm)
    knightwing_setOwned(form, gender, shiny, shadow)
  end
end

ModCacheInjection.hook(:moves) {
  $cache.moves[:EVISCERATE] = MoveData.new(:EVISCERATE, {
    :name => "Eviscerate",
    :desc => "Quickly strikes the target up to three times, each hit increasing in power.",
    :function => 0x0BF,
    :type => :STEEL,
    :category => :physical,
    :basedamage => 20,
    :accuracy => 100,
    :maxpp => 20,
    :effect => 100,
    :target => :SingleNonUser,
  })
}

mod_replace_animation(:EVISCERATE, :STEELWING)

ModCacheInjection.hook(:pkmn) {
  braviaryData = $cache.pkmn[:BRAVIARY].pokemonData["Normal Form"]

  $cache.pkmn[:KNIGHTWING] = MonWrapper.new(:KNIGHTWING, {
    "Defend Forme" => {
      :name => "Knightwing",
      :dexnum => 1034,
      :Type1 => :STEEL,
      :Type2 => :FLYING,
      :BaseStats => [110, 70, 140, 70, 140, 70],
      :EVs => [0, 0, 2, 0, 1, 0],
      :Abilities => [:STANCECHANGE],
      :HiddenAbility => nil,
      :GrowthRate => :Slow,
      :GenderRatio => :FemZero,
      :BaseEXP => 240,
      :CatchRate => 30,
      :Happiness => 70,
      :EggSteps => 5120,
      :preevo => {
        :species => :BRAVIARY,
        :form => 0,
      },
      :RelearnerMoves => (braviaryData.RelearnerMoves + [
        :EVISCERATE, :KINGSSHIELD, :BEAKBLAST,
      ]).uniq,
      :Moveset => (braviaryData.Moveset.reject { |level, _| level == 0 } + [
        [0, :KINGSSHIELD],
        [1, :BEAKBLAST],
        [1, :EVISCERATE],
        [67, :EVISCERATE],
      ]).sort_by { |level, _| level },
      :moveexceptions => [],
      :Color => "Black",
      :EggGroups => [:Flying],
      :Height => 15,
      :Weight => 470,
      :kind => "Vanguard",
      :dexentry => "The scars from victories layed behind are filled in with something stronger, sealing its honor inside.",
      :BattlerPlayerX => 0,
      :BattlerPlayerY => 11,
      :BattlerEnemyX => 0,
      :BattlerEnemyY => 11,
      :BattlerShadowSize => 33,
      :BattlerShadowX => 0,
    },

    "Attack Forme" => {
      :BaseStats => [110, 140, 70, 140, 70, 70],
      :EVs => [0, 2, 0, 1, 0, 0],
      :BattlerPlayerX => 0,
      :BattlerPlayerY => 11,
      :BattlerEnemyX => 0,
      :BattlerEnemyY => 11,
      :BattlerShadowSize => 33,
      :BattlerShadowX => 0,
    },
  })

  $cache.pkmn[:KNIGHTWING].pokemonData.each_value do |formData|
    moves = formData.RelearnerMoves + formData.Moveset.map { |_, move| move }
    formData.instance_variable_set(:@compatiblemoves, (formData.compatiblemoves + moves + [
      :METEORMASH, :NIGHTSLASH, :BRUTALSWING,
    ]).uniq)
  end

  $cache.pkmn[:BRAVIARY].pokemonData.each_value do |formData|
    formData.instance_variable_set(:@evolutions, (formData.evolutions || []) + [
      { species: :KNIGHTWING, form: 0, method: :TradeItem, parameter: :METALCOAT },
    ])
  end
}

PBStuff::BattleForms.push([:KNIGHTWING, [0, 1]])

class PokeBattle_Battler
  alias :knightwing_pbCheckStance :pbCheckStance

  def pbCheckStance(basemove)
    return knightwing_pbCheckStance(basemove) unless self.pokemon && self.pokemon.species == :KNIGHTWING

    stanceChangeIllusions(basemove) if Rejuv
    return if self.isFainted? || self.effects[:clearDisguise]
    return unless self.ability == :STANCECHANGE && !@effects[:Transform]

    transformed = false
    chargingTurn = !basemove.nil? && PBStuff::TWOTURNMOVE.include?(basemove.move) && self.effects[:TwoTurnAttack] != basemove.move
    if self.form == 1 && !basemove.nil? && (basemove.move == :KINGSSHIELD)
      @battle.pbShowAbilityBox(self)
      self.form = 0
      @battle.pbCommonAnimation("StanceProtect", self, nil)
      transformed = true
    elsif self.form == 0 && !basemove.nil? && basemove.pbIsDamaging? && !chargingTurn
      @battle.pbShowAbilityBox(self)
      self.form = 1
      @battle.pbCommonAnimation("StanceAttack", self, nil)
      transformed = true
    end

    if transformed
      if self.type1 != @pokemon.type1 || self.type2 != @pokemon.type2
        pbUpdate(false)
      else
        pbUpdate(true)
      end
      @battle.scene.pbChangePokemon(self, @pokemon)
      message = self.form == 0 ? _INTL("Changed to Shield Forme!") : _INTL("Changed to Blade Forme!")
      @battle.pbDisplay(message)
      if @battle.FE == :FAIRYTALE || (Rejuv && @battle.FE == :CHESS)
        amounts = self.form == 0 ? [-1, 1] : [1, -1]
        self.pbChangeStats(PBStats::Physical, amounts, self, nil, abilitycheck: :hide)
      end
    end
    @battle.pbHideAbilityBox(self)
  end
end
