module Sufia
  class AdminStatsPresenter
    attr_reader :limit, :stats_filters

    def initialize(stats_filters, limit)
      @stats_filters = stats_filters
      @limit = limit
    end

    def start_date
      @start_date ||= Time.zone.parse(stats_filters[:start_date]).beginning_of_day if stats_filters[:start_date].present?
    end

    def end_date
      @end_date ||= Time.zone.parse(stats_filters[:end_date]).end_of_day if stats_filters[:end_date].present?
    end

    def depositors
      @depositors ||= Sufia::Statistics::Depositors::Summary.new(start_date, end_date).depositors
    end

    def recent_users
      @recent_users ||= stats.recent_users
    end

    def active_users
      @active_users ||= Sufia::Statistics::Works::ByDepositor.new(@limit).query
    end

    def top_formats
      @top_formats ||= Sufia::Statistics::FileSets::ByFormat.new(@limit).query
    end

    def works_count
      @works_count ||= Sufia::Statistics::Works::Count.new(start_date, end_date).by_permission
    end

    def users_count
      @users_count ||= stats.users_count
    end

    def date_filter_string
      if start_date.blank?
        "unfiltered"
      elsif end_date.blank?
        "#{start_date.to_date.to_formatted_s(:standard)} to #{Date.current.to_formatted_s(:standard)}"
      else
        "#{start_date.to_date.to_formatted_s(:standard)} to #{end_date.to_date.to_formatted_s(:standard)}"
      end
    end

    private

      def stats
        @stats ||= Sufia::Statistics::SystemStats.new(limit, start_date, end_date)
      end
  end
end
