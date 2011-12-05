require 'match_plan'
require 'minitest/autorun'

class MatchPlan::PhaseTest < MiniTest::Unit::TestCase
  include MatchPlan

  def test_initialize_sets_name
    phase = Phase.new(:my_phase)
    assert_equal :my_phase, phase.name
  end

  def test_initialize_evaluates_block
    local_variable = 'something'
    group = Phase.new(:my_phase) { local_variable = 'changed' }
    assert_equal 'changed', local_variable
  end
end
