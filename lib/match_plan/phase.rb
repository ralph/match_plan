class MatchPlan::Phase
  include MatchPlan::Shared
  attr_accessor :name

  def initialize(name, &block)
    @name = name
    instance_eval(&block) if block_given?
  end
end
