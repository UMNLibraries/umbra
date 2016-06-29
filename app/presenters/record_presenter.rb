class RecordPresenter < BasePresenter
  presents :record

  attr_accessor :flag_vote, :solr_doc
  def initialize(object, template: nil, flag_vote: FlagVote)
    super(object, template: template)
    @flag_vote = flag_vote
  end

  def to_solr(doc: {})
    @solr_doc = (doc.length > 0) ? doc : solr_doc
    solr_doc['editor_tags_ssim']  = normalize tags
    solr_doc['keywords_ssim']     = keywords
    solr_doc['flags_isim']        = flags(solr_doc['id'])
    solr_doc.delete('_version_')
    solr_doc
  end

  private

  def flags(record_id)
    flag_vote.where(record_id: record_id).map { |fv| fv.flag.id }
  end

  def keywords
    (normalize subjects + tags).uniq.sort
  end

  def normalize(terms)
    terms.sort.uniq.map { |term| term.titleize }
  end

  def subjects
    @subjects ||= solr_doc.fetch('subject_ssim', [])
  end

  def tags
    record.tag_list.split(',').map {|tag| tag.strip }
  end

  def solr_doc
    @solr_doc ||= record.solr_doc
  end
end