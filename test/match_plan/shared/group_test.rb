require 'match_plan/shared/shared_helper'

class MatchPlan::Shared::GroupTest < MiniTest::Unit::TestCase
  def setup
    @instance = PlaceholderClass.new
    @instance.group(:a) {}
    @instance.group(:b) {}
  end

  def test_group
    assert_equal :a, @instance.group(:a).name
  end

  def test_groups
    assert_equal [:a, :b], @instance.groups.map(&:name)
  end
end
