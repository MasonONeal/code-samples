class Event < ActiveRecord::Base
  validates_presence_of :title, :message => "Please add an event title"
  validates_presence_of :date, :message => "Please include a date"
  validates_uniqueness_of :title, :message => "Events cannot have the same title"
  validate :date_is_not_past
  validate :date_valid_format
  validates_format_of :organizer_email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Enter valid email"

  def date_is_not_past
    if date.present? && date < Date.today
      errors.add(:date, "Event date cannot be past")
    end
  end

  def date_valid_format
    unless :date =~ %r{^(\w+), (\d+) (\w+) (\d+)$}
      errors.add(:date, "Enter valid Date")
    end
  end

end