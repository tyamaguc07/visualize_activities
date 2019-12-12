module VisualizeActivities
  class Setting
    attr_reader :owner, :repository, :target, :target_time

    def initialize(owner, repository, target, target_time)
      @owner = owner
      @repository = repository
      @target = target
      @target_time = target_time
    end
  end
end
