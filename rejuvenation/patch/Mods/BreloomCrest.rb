PBStuff::POKEMONTOCREST[:BRELOOM] = :BRELOCREST

ModCacheInjection.hook(:items) {
  $cache.items[:BRELOCREST] = ItemData.new(:BRELOCREST, {
    name: "Breloom Crest",
    desc: "Makes the first damage-dealing electric move Thunder Raid.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
  alias :brelocrest_old_crestStats :crestStats unless method_defined?(:brelocrest_old_crestStats)

  def crestStats
    if @crested == :BRELOOM
      @moves.each_with_index do |move, i|
        next unless move.type == :ELECTRIC
        next unless move.basedamage > 0

        old_pp = move.pp
        old_totalpp = move.totalpp

        @moves[i] = PokeBattle_Move.pbFromPBMove(@battle, PBMove.new(:THUNDERRAID), @pokemon)
        @moves[i].pp = (old_pp * (@moves[i].totalpp.to_f / old_totalpp)).floor
        break
      end
    end
    brelocrest_old_crestStats
  end
end

class PokeBattle_Battle
  alias :brelocrest_old_pbCrestEntry :pbCrestEntry unless method_defined?(:brelocrest_old_pbCrestEntry)

  def pbCrestEntry(index, pokemon)
    battler = @battlers[index]
    if battler.crested == :BRELOOM
      pbShowAbilityBox(battler, attrname: getItemName(:BRELOCREST), crest: true)
      pbDisplay(_INTL("{1} learned Thunder Raid!", battler.pbThis))
      pbHideAbilityBox(battler)
    end
    brelocrest_old_pbCrestEntry(index, pokemon)
  end
end
