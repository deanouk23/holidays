# == Schema Information
#
# Table name: vacation_requests
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer          default(0)
#
# Indexes
#
#  index_vacation_requests_on_user_id  (user_id)
#

class VacationRequest < ActiveRecord::Base
  enum status: [:pending, :processed]

  # Relations
  belongs_to :user
  has_many :requested_days, -> { order :day }, dependent: :destroy, inverse_of: :vacation_request
  accepts_nested_attributes_for :requested_days, allow_destroy: true, reject_if: :all_blank

  # Scopes
  scope :ordered, -> { order created_at: :desc }

  # Validations
  validate :at_least_one_requested_day
  validate :valid_dates
  validate :valid_number_of_days

  private

  def at_least_one_requested_day
    errors[:base] << 'At least one requested day is required' if requested_days.empty?
  end

  def valid_dates
    errors[:base] << 'Can\'t select a date in the past' if requested_days.select{ |request_date| request_date.day.past? }.any?
  end

  def valid_number_of_days
    available_days = user.available_days

    errors[:base] << "You only have #{available_days} available days" if available_days < requested_days.length
  end
end
