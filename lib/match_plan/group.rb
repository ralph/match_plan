class MatchPlan::Group
  include MatchPlan::Shared
  attr_accessor :name
  attr_reader :teams

  def initialize(name, &block)
    @name = name
    @teams = []
    instance_eval(&block) if block_given?
  end

  def match(home, guest, options = {})
    @teams << home unless @teams.include?(home)
    @teams << guest unless @teams.include?(guest)
    super
  end

  def [](index)
    if finished?
      ranked_teams[index]
    else
      "group_#{name}_#{index}".to_sym
    end
  end

  def finished?
    matches == matches.select { |match| match.result }
  end

private
  def teams_with_score
    teams_with_score = {}
    # Memoize score and number of goals:
    @teams.each { |team| teams_with_score[team] = [0,0] }
    matches.each do |match|
      if match.drawn?
        # Memoize score:
        teams_with_score[match.team_a][0] += 1
        teams_with_score[match.team_b][0] += 1
      else
        # Memoize score:
        teams_with_score[match.winner][0] += 3
      end
      # Memoize goals:
      teams_with_score[match.team_a][1] += match.result.first
      teams_with_score[match.team_b][1] += match.result.last
    end

    teams_with_score
  end

  def ranked_teams
    teams_with_score.to_a.sort do |team_a, team_b|
      team_a_score = team_a[1][0]
      team_b_score = team_b[1][0]
      team_a_goals = team_a[1][1]
      team_b_goals = team_b[1][1]
      goal_difference = team_b_goals - team_a_goals

      # same score and no goal difference => number of goals
      if team_a_score == team_b_score && goal_difference == 0
        team_b_goals <=> team_a_goals
      # same score => goal difference
      elsif team_a_score == team_b_score
        goal_difference
      else
        team_b_score <=> team_a_score
      end
    end.map(&:first)
  end
end
