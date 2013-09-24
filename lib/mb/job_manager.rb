module MotherBrain
  class JobManager
    class << self
      # @raise [Celluloid::DeadActorError] if job manager has not been started
      #
      # @return [Celluloid::Actor(JobManager)]
      def instance
        MB::Application[:job_manager] or raise Celluloid::DeadActorError, "job manager not running"
      end

      def running?
        MB::Application[:job_manager] && instance.alive?
      end

      def stopped?
        !running?
      end
    end

    include Celluloid
    include MB::Logging

    trap_exit :force_complete

    # @return [Set<JobRecord>]
    #   listing of records of all jobs; completed and active
    attr_reader :records
    alias_method :list, :records

    finalizer :finalize_callback

    def initialize
      log.debug { "Job Manager starting..." }
      @records = Set.new
      @_active = Set.new
    end

    # Track and record the given job
    #
    # @param [Job] job
    def add(job)
      @_active.add(job)
      records.add JobRecord.new(job)
      monitor(job)
    end

    # Complete the given active job
    #
    # @param [Job] job
    def complete_job(job)
      @_active.delete(job)
    end

    # listing of all active jobs
    #
    # @return [Set<JobRecord>]
    def active
      active_ids = @_active.collect {|j| j.id }
      records.select {|r| active_ids.include?(r.id) }
    end

    # @param [String] id
    def find(id)
      records.find { |record| record.id == id }
    end

    # Update the record for the given Job
    #
    # @param [Job] job
    def update(job)
      find(job.id).update(job)
    end

    def terminate_active
      @_active.map { |job| job.async.terminate if job.alive? }
    end

    # Generate a new Job ID
    #
    # @return [String]
    def uuid
      Celluloid::UUID.generate
    end

    private

      def finalize_callback
        log.debug { "Job Manager stopping..." }
        terminate_active
      end

      def force_complete(actor, reason)
        complete_job(actor)
      end
  end
end
