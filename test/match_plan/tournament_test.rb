require 'match_plan'
require 'minitest/autorun'

class MatchPlan::TournamentTest < MiniTest::Unit::TestCase
  include MatchPlan

  def test_initialize_sets_name
    tournament = Tournament.new(:my_tournament)
    assert_equal :my_tournament, tournament.name
  end

  def test_initialize_evaluates_block
    local_variable = 'something'
    tournament = Tournament.new(:my_tournament) { local_variable = 'changed' }
    assert_equal 'changed', local_variable
  end
end
