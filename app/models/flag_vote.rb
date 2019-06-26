require 'digest/sha1'

# TODO: Make a belongs_to for the record model and lazily instantiate
# corresponding records on flag vote creation.
class FlagVote < ActiveRecord::Base
  include Blacklight::SearchHelper
  after_commit :add_flag_to_record, on: :update
  after_commit :add_flag_to_record, on: :create
  after_commit :remove_flag_from_record, on: :destroy

  belongs_to :user
  belongs_to :flag
  validates :flag_id, presence: true
  validates :record_id, presence: true
  validates :user, presence: true
  validates :user_id, uniqueness: {scope: [:record_id, :flag_id]}
  scope :votes_above_threshold, ->(flag_id, threshold) { select(:record_id).where(flag_id: flag_id).group(:record_id).having("COUNT(record_id) >= ?", threshold) }
  scope :flag_vote, ->(record_id, user_id, flag_id) { where(record_id: record_id, user_id: user_id, flag_id: flag_id) }
  scope :by_record, ->(record_id) { where(record_id: record_id) }

  def css_class
    (!id.nil?) ? 'flagged' : 'unflagged'
  end

  def self.find_or_build(record_id, user_id, flag_id)
    vote = flag_vote(record_id, user_id, flag_id).take
    (!vote.nil?) ? vote : self.new(record_id: record_id, user_id: user_id, flag_id: flag_id)
  end

  def self.document(record_id)
    SolrClient.find_record(record_id)
  end

  def add_flag_to_record
    doc   = FlagVote.document(record_id)
    unless doc.nil?
      doc['flags_isim'] ||= []
      doc['flags_isim'] << flag.id
      update_record(doc)
    end
  end

  def remove_flag_from_record
    doc   = FlagVote.document(record_id)
    doc['flags_isim'] ||= []
    doc['flags_isim'].delete(flag.id)
    update_record(doc)
  end

  def self.flag_all!
    FlagVote.all.map {|vote| vote.add_flag_to_record }
  end

  def update_record(doc)
    SolrClient.add [doc.except('search_suggest')]
    SolrClient.commit
  end

  private

  def self.format_record(record)
    (record.respond_to?(:last)) ? record.last : record
  end

end