require 'match_plan'
require 'minitest/autorun'

class MatchPlan::GroupTest < MiniTest::Unit::TestCase
  include MatchPlan

  def test_initialize_sets_name
    group = Group.new(:my_group)
    assert_equal :my_group, group.name
  end

  def test_initialize_evaluates_block
    local_variable = 'something'
    group = Group.new(:my_group) { local_variable = 'changed' }
    assert_equal 'changed', local_variable
  end

  def test_set_teams
    group = Group.new(:my_group) do
      match :germany, :france
      match :poland, :spain
    end
    assert_equal [:germany, :france, :poland, :spain], group.teams
  end


  class FinishedTest < self
    def setup
      super
      @group = Group.new(:my_group) do
        match :germany, :france
        match :poland, :spain
      end
    end

    def test_not_finished_without_results
      refute @group.finished?
    end

    def test_finished_with_results
      @group.match(:germany, :france).result = [1,1]
      @group.match(:poland, :spain).result = [1,2]
      assert @group.finished?
    end
  end


  class SquareBracketsTest < self
    def setup
      super
      @group = Group.new(:my_group) do
        match :germany, :france
        match :germany, :poland
        match :germany, :spain
        match :france, :poland
        match :france, :spain
        match :poland, :spain
      end
    end

    def test_returns_placeholders_if_not_finished
      assert_equal :group_my_group_0, @group[0]
      assert_equal :group_my_group_6, @group[6]
    end

    def test_returns_actual_rankings_if_finished
      @group.match(:germany, :france).result = [3,1]
      @group.match(:germany, :poland).result = [2,1]
      @group.match(:germany, :spain).result  = [9,1]
      @group.match(:france, :poland).result  = [3,1]
      @group.match(:france, :spain).result   = [1,1]
      @group.match(:poland, :spain).result   = [1,8]

      expected = [:germany, :spain, :france, :poland]
      assert_equal expected, [@group[0], @group[1], @group[2], @group[3]]
    end
  end
end
