require 'match_plan'
require 'minitest/autorun'

class MatchPlan::MatchTest < MiniTest::Unit::TestCase
  include MatchPlan

  class TeamMethodsTest < self
    def setup
      @match = Match.new :germany, :england
    end

    def test_teams
      assert_equal [:germany, :england], @match.teams
    end

    def test_team_a
      assert_equal :germany, @match.team_a
    end

    def test_team_b
      assert_equal :england, @match.team_b
    end
  end

  class OptionsTest < self
    def test_at_with_string
      time_string = '2012-06-30T00:00:00+00:00'
      match = Match.new :germany, :england, :at => time_string
      assert_instance_of DateTime, match.at
      assert_equal DateTime.parse(time_string), match.at
    end

    def test_at_with_date_time
      date_time = DateTime.parse '2012-06-30T00:00:00+00:00'
      match = Match.new :germany, :england, :at => date_time
      assert_instance_of DateTime, match.at
      assert_equal date_time, match.at
    end
  end

  class DrawnTest < self
    def setup
      @match = Match.new :germany, :england
    end

    def test_drawn_match
      @match.result = [1,1]
      assert @match.drawn?
    end

    def test_non_drawn_match
      @match.result = [1,2]
      refute @match.drawn?
    end

    def test_non_played_match
      refute @match.drawn?
    end
  end

  class WinnerTest < self
    def setup
      @match = Match.new :germany, :england
    end

    def test_team_a_winner
      @match.result = [2,1]
      assert_equal :germany, @match.winner
    end

    def test_team_b_winner
      @match.result = [1,2]
      assert_equal :england, @match.winner
    end

    def test_non_played_match
      assert_equal :match_germany_vs_england_winner, @match.winner
    end

    def test_drawn_match
      @match.result = [1,1]
      refute @match.winner
    end
  end

  class LoserTest < self
    def setup
      @match = Match.new :germany, :england
    end

    def test_team_a_loser
      @match.result = [1,2]
      assert_equal :germany, @match.loser
    end

    def test_team_b_loser
      @match.result = [2,1]
      assert_equal :england, @match.loser
    end

    def test_non_played_match
      assert_equal :match_germany_vs_england_loser, @match.loser
    end

    def test_drawn_match
      @match.result = [1,1]
      refute @match.loser
    end
  end
end
