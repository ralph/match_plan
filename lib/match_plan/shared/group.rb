module MatchPlan::Shared
  module Group
    def group(name, &block)
      @groups ||= {}
      if block_given?
        @groups[name] = MatchPlan::Group.new(name, &block)
      else
        @groups[name]
      end
    end

    def groups
      @groups ||= {}
      @groups.values
    end
  end
end
