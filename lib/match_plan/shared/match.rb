module MatchPlan::Shared
  module Match
    def match(home, guest, options = {})
      @matches ||= []
      match = MatchPlan::Match.new(home, guest, options)
      if match_index = @matches.index(match)
        @matches[match_index]
      else
        @matches << match
        match
      end
    end

    def matches
      matches = @matches || []
      groups.each { |group| matches += group.matches }
      phases.each { |phase| matches += phase.matches }
      matches
    end
  end
end
