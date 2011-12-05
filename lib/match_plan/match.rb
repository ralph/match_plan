require 'date'

class MatchPlan::Match
  attr_accessor :result, :teams
  attr_reader :teams, :at

  def initialize(team_a, team_b, options = {})
    @teams = [team_a, team_b]
    if at = options[:at]
      @at = (at.is_a?(DateTime) ? at : DateTime.parse(at))
    end
  end

  def team_a
    @teams.first
  end

  def team_b
    @teams.last
  end

  def ==(other_match)
    @teams == other_match.teams
  end

  def drawn?
    @result && @result.first == @result.last
  end

  def winner
    return "match_#{team_a}_vs_#{team_b}_winner".to_sym if !result
    @teams[@result.index(@result.max)] if !drawn?
  end

  def loser
    return "match_#{team_a}_vs_#{team_b}_loser".to_sym if !result
    @teams[@result.index(@result.min)] if !drawn?
  end
end
