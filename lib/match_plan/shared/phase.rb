module MatchPlan::Shared
  module Phase
    def phase(name, &block)
      @phases ||= {}
      if block_given?
        @phases[name] = MatchPlan::Phase.new(name, &block)
      else
        @phases[name]
      end
    end

    def phases
      @phases ||= {}
      @phases.values
    end
  end
end
