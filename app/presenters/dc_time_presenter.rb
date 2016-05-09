class DcTimePresenter < Struct.new(:time)
  FORMAT = "%B %d, %Y %r".freeze
  def convert
    return unless time
    time.in_time_zone(ActiveSupport::TimeZone['Eastern Time (US & Canada)'])
  end

  def convert_and_format(format = FORMAT)
    return NullBidPresenter::NULL unless time
    convert.strftime(format) + " #{timezone_label}"
  end

  def self.convert(time)
    new(time).convert
  end

  def self.convert_and_format(time, format = FORMAT)
    new(time).convert_and_format(format)
  end

  def timezone_label
    convert.zone
  end
end
