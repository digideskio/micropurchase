class DcTimePresenter
  NULL = "&nbsp;".html_safe.freeze
  FORMAT = "%B %d, %Y %r".freeze
  TIME_ZONE_NAME = 'Eastern Time (US & Canada)'.freeze

  attr_reader :time

  def initialize(time)
    @time = time
  end

  def self.convert(time)
    new(time).convert
  end

  def self.convert_and_format(time, format = FORMAT)
    new(time).convert_and_format(format)
  end

  def self.time_zone
    ActiveSupport::TimeZone[TIME_ZONE_NAME]
  end

  def convert
    return unless time
    time.in_time_zone(time_zone)
  end

  def convert_and_format(format = FORMAT)
    if time
      convert.strftime(format) + " #{timezone_label}"
    else
      NULL
    end
  end

  def time_zone
    self.class.time_zone
  end

  def timezone_label
    convert.zone
  end
end
