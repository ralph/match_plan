module MatchPlan::Shared
  module Teams
    def teams
      teams_including_placeholders = matches.map(&:teams).flatten.uniq
      teams_including_placeholders.reject { |t| t =~ /^(match|group)/ }
    end
  end
end
