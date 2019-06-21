require 'rails_helper'
require './app/presenters/example_search_presenter.rb'

describe ExampleSearchPresenter do
  include ActionView::TestCase::Behavior
  let(:example_search) { ExampleSearch.new(q: '*:*', fq: ['creator_ssi:Fred'], title: 'A search for meaning.')}
  it "runs a search and returns the number found" do
    presenter = ExampleSearchPresenter.new(example_search, solr: solr)
    expect(presenter.items_found).to eq "101 items"
  end

  it "produces a url to a catalog search" do
    presenter = ExampleSearchPresenter.new(example_search, params: {rows: 101}, template: view)
    expect(presenter.url).to eq "/catalog?rows=101&q=*:*&rows=101&f[creator_ssi][]=Fred&example-search="
  end

  def solr
    Struct.new("SolrStub") do
      def self.get(action, params: {})
        {'response' => {'numFound' => 101}}
      end
    end
  end
end

