require 'match_plan/shared/shared_helper'

class MatchPlan::Shared::PhaseTest < MiniTest::Unit::TestCase
  include MatchPlan

  def setup
    @instance = PlaceholderClass.new
  end

  def test_phase
    @instance.phase(:knock_out) {}
    assert_equal :knock_out, @instance.phase(:knock_out).name
  end

  def test_phases
    @instance.phase(:group_phase) {}
    @instance.phase(:knock_out) {}
    assert_equal [:group_phase, :knock_out], @instance.phases.map(&:name)
  end
end
