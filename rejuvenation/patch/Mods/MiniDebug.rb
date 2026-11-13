# Always enable the Mini Debug Pass, exposing the Debug options in the
# pause menu, party menu, PC storage and bag (non-important, non-crystal items).
class Game_Switches
  alias :minidebug_old_get :[] unless method_defined?(:minidebug_old_get)
  def [](switch_id)
    return true if switch_id == :MiniDebug_Pass
    return minidebug_old_get(switch_id)
  end
end
