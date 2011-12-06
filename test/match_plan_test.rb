require 'match_plan'
require 'minitest/autorun'

class MatchPlanTest < MiniTest::Unit::TestCase
  include MatchPlan

  def setup
    @tournament = Tournament.new(:euro_2012) do |t|
      phase(:group_stage) do
        group(:a) do
          match :poland,         :greece,         :at => '2012-06-08T18:00:00+02:00'
          match :russia,         :czech_republic, :at => '2012-06-08T20:45:00+02:00'
          match :greece,         :czech_republic, :at => '2012-06-12T18:00:00+02:00'
          match :poland,         :russia,         :at => '2012-06-12T20:45:00+02:00'
          match :czech_republic, :poland,         :at => '2012-06-16T20:45:00+02:00'
          match :greece,         :russia,         :at => '2012-06-16T20:45:00+02:00'
        end
        group(:b) do
          match :netherlands,    :denmark,        :at => '2012-06-09T19:00:00+03:00'
          match :germany,        :portugal,       :at => '2012-06-09T21:45:00+03:00'
          match :denmark,        :portugal,       :at => '2012-06-13T19:00:00+03:00'
          match :netherlands,    :germany,        :at => '2012-06-13T21:45:00+03:00'
          match :portugal,       :netherlands,    :at => '2012-06-17T21:45:00+03:00'
          match :denmark,        :germany,        :at => '2012-06-17T21:45:00+03:00'
        end
        group(:c) do
          match :spain,          :italy,          :at => '2012-06-10T18:00:00+02:00'
          match :republic_of_ireland, :croatia,   :at => '2012-06-10T20:45:00+02:00'
          match :italy,          :croatia,        :at => '2012-06-14T18:00:00+02:00'
          match :spain,     :republic_of_ireland, :at => '2012-06-14T20:45:00+02:00'
          match :croatia,        :spain,          :at => '2012-06-18T20:45:00+02:00'
          match :italy,     :republic_of_ireland, :at => '2012-06-18T20:45:00+02:00'
        end
        group(:d) do
          match :france,         :england,        :at => '2012-06-11T19:00:00+03:00'
          match :ukraine,        :sweden,         :at => '2012-06-11T21:45:00+03:00'
          match :sweden,         :england,        :at => '2012-06-15T21:45:00+03:00'
          match :ukraine,        :france,         :at => '2012-06-15T19:00:00+03:00'
          match :england,        :ukraine,        :at => '2012-06-19T21:45:00+03:00'
          match :sweden,         :france,         :at => '2012-06-19T21:45:00+03:00'
        end
      end

      phase(:knock_out) do |knock_out_phase|
        group(:quarter_finals) do
          prev = t.phase(:group_stage)
          match prev.group(:a)[0], prev.group(:b)[1], :at => '2012-06-21T20:45:00+02:00'
          match prev.group(:b)[0], prev.group(:a)[1], :at => '2012-06-22T20:45:00+02:00'
          match prev.group(:c)[0], prev.group(:d)[1], :at => '2012-06-23T21:45:00+03:00'
          match prev.group(:d)[0], prev.group(:c)[1], :at => '2012-06-24T21:45:00+03:00'
        end

        group(:half_finals) do
          prev = knock_out_phase.group(:quarter_finals)
          match prev.matches[0].winner, prev.matches[2].winner, :at => '2012-06-27T21:45:00+03:00'
          match prev.matches[1].winner, prev.matches[3].winner, :at => '2012-06-28T20:45:00+02:00'
        end

        group(:finals) do
          prev = knock_out_phase.group(:half_finals)
          match prev.matches[0].winner, prev.matches[1].winner, :at => '2012-07-01T21:45:00+03:00'
        end
      end
    end
  end

  class TeamsTest < self
    def test_get_teams_of_tournament
      expected = [
        :croatia, :czech_republic, :denmark, :england, :france, :germany,
        :greece, :italy, :netherlands, :poland, :portugal,
        :republic_of_ireland, :russia, :spain, :sweden, :ukraine
      ]
      assert_equal expected, @tournament.teams.sort
    end

    def test_get_teams_of_phase
      expected = [
        :croatia, :czech_republic, :denmark, :england, :france, :germany,
        :greece, :italy, :netherlands, :poland, :portugal,
        :republic_of_ireland, :russia, :spain, :sweden, :ukraine
      ]
      assert_equal expected, @tournament.phase(:group_stage).teams.sort
    end

    def test_get_teams_of_group
      expected = [:czech_republic, :greece, :poland, :russia]
      assert_equal expected, @tournament.phase(:group_stage).group(:a).teams.sort
    end
  end

  class MatchesTest
    def test_get_matches_returns_match
      assert_equal [MatchPlan::Match], @tournament.matches.map(&:class).uniq
    end

    def test_get_matches_of_tournament
      # 6 matches per 4 groups, quarter finals, semi finals, final
      assert_equal 6*4 + 4 + 2 + 1, @tournament.matches.length
    end

    def test_get_matches_of_phase
      # 6 matches per 4 groups
      assert_equal 6*4, @tournament.phase(:group_stage).matches.length
      # quarter finals, semi finals, final
      assert_equal 4 + 2 + 1, @tournament.phase(:knock_out).matches.length
    end

    def test_get_matches_of_group
      # 6 matches per group
      assert_equal 6, @tournament.phase(:group_stage).group(:a).matches.length
    end
  end

  class ResultWinnerLoserTest < self
    def setup
      super
      @match = @tournament.phase(:group_stage).group(:a).match(:poland, :greece)
    end

    def test_result_is_not_set
      assert_nil @match.result
    end

    def test_set_result
      @match.result = [3,5]
      assert_equal [3,5], @match.result
    end

    def test_winner
      @match.result = [3,5]
      assert_equal :greece, @match.winner
    end

    def test_loser
      @match.result = [3,5]
      assert_equal :poland, @match.loser
    end

    def test_winner_for_draw
      @match.result = [1,1]
      assert_nil @match.winner
    end

    def test_loser_for_draw
      @match.result = [1,1]
      assert_nil @match.loser
    end
  end
end
