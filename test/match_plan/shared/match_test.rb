require 'match_plan/shared/shared_helper'

class MatchPlan::Shared::MatchTest < MiniTest::Unit::TestCase
  include MatchPlan

  def setup
    @instance = PlaceholderClass.new
  end

  def test_adding_match
    @instance.match(:germany, :england)
    @instance.match(:spain, :poland)

    assert_equal Match.new(:germany, :england), @instance.matches[0]
    assert_equal Match.new(:spain, :poland), @instance.matches[1]
  end

  def test_getting_match
    @instance.match(:germany, :england)
    @instance.match(:spain, :poland)

    match = @instance.match(:germany, :england)
    assert_equal Match.new(:germany, :england), match
  end


  class MatchesTest < self
    def setup
      super
      @instance.phase(:knock_out) do
        group(:first) do
          match :germany, :spain
          match :portugal, :italy
        end

        group(:second) do
          match :england, :croatia
          match :poland, :greece
        end
      end
    end

    def test_matches_for_tournament
      assert_equal 4, @instance.matches.length
    end

    def test_teams_for_phase
      assert_equal 4, @instance.phase(:knock_out).matches.length
    end

    def test_teams_for_group
      assert_equal 2, @instance.phase(:knock_out).group(:first).matches.length
    end
  end
end
