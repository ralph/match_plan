require 'match_plan/shared/shared_helper'

class MatchPlan::Shared::TeamsTest < MiniTest::Unit::TestCase
  include MatchPlan

  def setup
    @instance = PlaceholderClass.new
    @instance.phase(:knock_out) do |p|
      group(:first) do
        match :germany, :spain
        match :portugal, :italy
      end

      group(:second) do
        match :england, :croatia
        match :poland, :greece
        match :germany, :greece
      end

      group(:third) do
        prev_match_1 = p.group(:second).matches[0]
        prev_match_2 = p.group(:second).matches[1]
        match prev_match_1.winner, prev_match_2.winner
      end
    end
  end

  def test_teams_for_tournament
    expected = [
      :germany, :spain, :portugal, :italy,
      :england, :croatia, :poland, :greece
    ].sort

    assert_equal expected, @instance.teams.sort
  end

  def test_teams_for_phase
    expected = [
      :germany, :spain, :portugal, :italy,
      :england, :croatia, :poland, :greece
    ].sort

    assert_equal expected, @instance.phase(:knock_out).teams.sort
  end

  def test_teams_for_group
    expected = [:germany, :spain, :portugal, :italy,].sort

    assert_equal expected, @instance.phase(:knock_out).group(:first).teams.sort
  end
end
