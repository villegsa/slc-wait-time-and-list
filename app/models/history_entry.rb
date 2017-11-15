class HistoryEntry < ActiveRecord::Base
  # enum appointment: [:drop_in, :scheduled, :weekly]
  belongs_to  :student
  has_one :tutor
  def self.get_drop_ins(date)
    where(created_at: date).where(meet_type: "drop-in")
  end

  def self.get_scheduled(date)
    where(created_at: date).where(meet_type: "scheduled")
  end

  def self.get_weeklys(date)
    where(created_at: date).where(meet_type: "weekly")
  end
end