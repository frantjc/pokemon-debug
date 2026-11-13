# Registers a fallback battle animation for a custom move.
# Newer game versions keep the table at top-level ReplacementAnimations;
# older ones keep it at PBStuff::ReplacementAnimations.
# Resolved at call time, so it works from patch/Mods (after SCRIPTS load).
def mod_replace_animation(move, animation)
  table = if defined?(::ReplacementAnimations)
    ::ReplacementAnimations
  elsif defined?(PBStuff::ReplacementAnimations)
    PBStuff::ReplacementAnimations
  end
  table[move] = animation if table
end
