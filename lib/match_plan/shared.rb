require 'match_plan/shared/group'
require 'match_plan/shared/match'
require 'match_plan/shared/phase'
require 'match_plan/shared/teams'

module MatchPlan::Shared
  include Group
  include Match
  include Phase
  include Teams
end
