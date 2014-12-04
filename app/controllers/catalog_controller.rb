# -*- encoding : utf-8 -*-
#
class CatalogController < ApplicationController  

  include Blacklight::Catalog
  include BlacklightMoreLikeThis::SolrHelperExtension

  # Override blacklights limit param for facets.
  # See: def solr_facet_params - blacklight-5.7.2/lib/blacklight/solr_helper.rb
  def facet_list_limit
    (params[:limit]) ? params[:limit] : 20
  end

  layout 'umbra'   # use layouts/umbra instead of default layouts/blacklight

  configure_blacklight do |config|
    config.index.thumbnail_field = :object_s

    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      :qt => 'search_dpla',
      :fl => '*',
      :rows => 50,
      :bq => 'sourceResource_type_s:text^50.0'
    }

    # solr path which will be added to solr base url before the other solr params.
    #config.solr_path = 'select'

    # items to show per page, each number in the array represent another option to choose from.
    #config.per_page = [10,20,50,100]

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SolrHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    #config.default_document_solr_params = {
    #  :qt => 'document',
    #  ## These are hard-coded in the blacklight 'document' requestHandler
    #  # :fl => '*',
    #  # :rows => 1
    #  # :q => '{!raw f=id v=$id}'
    #}

    # solr field configuration for search results/index views
    config.index.title_field = 'title_display'
    config.index.display_type_field = 'sourceResource_type_s'
    config.index.thumbnail_method = :cached_thumbnail_tag
    config.show.thumbnail_method = :cached_thumbnail_tag

    config.view.gallery.partials = [:index]
    config.view.gallery.icon_class = "glyphicon-th"
    # solr field configuration for document/show views
    #config.show.title_field = 'title_display'
    #config.show.display_type_field = 'format'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar

    config.add_facet_field 'sourceResource_type_s', :label => 'Type', :limit => 4
    config.add_facet_field 'subject_topic_facet', :label => 'Subject', :limit => 20
    config.add_facet_field 'creator_facet', :label => 'Creator', :limit => 20
    config.add_facet_field 'pub_date', :label => 'Publication Year', :single => true
    config.add_facet_field 'language_facet', :label => 'Language', :limit => true
    # Note: This tries to set assumed_boundaries for blacklight_range_limit, but it's not working.  Leaving the value set in case it gets fixed in future releases of blacklight_range_limit
    config.add_facet_field 'sourceResource_date_begin_i', :label => 'Year', :range => {:assumed_boundaries => [1100, Time.now.year + 2]}
    config.add_facet_field 'sourceResource_spatial_state_s', :label => 'State', :limit => 10
    config.add_facet_field 'sourceResource_spatial_city_s', :label => 'City', :limit => 10
    config.add_facet_field 'sourceResource_spatial_county_s', :label => 'County', :limit => 10
    config.add_facet_field 'sourceResource_spatial_region_s', :label => 'Region', :limit => 10
    config.add_facet_field 'dataProvider_s', :label => 'Contributing Institution', :limit => 10
    config.add_facet_field 'sourceResource_collection_title_s', :label => 'From Collection', :limit => 10
    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field 'sourceResource_creator_display'
    config.add_index_field 'dataProvider_s', :label => 'Provided By'

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display

    #config.add_show_field 'sourceResource_creator_display', :label => 'Creators'
    #config.add_show_field 'sourceResource_description_txt', :label => 'Description'

    config.add_show_field 'sourceResource_type_s', :label => 'Type'
    config.add_show_field 'sourceResource_format_s', :label => 'Format'
    config.add_show_field 'id', :label => 'Record ID'

    config.add_show_field 'sourceResource_contributor_s', :label => 'Contributors'
    config.add_show_field 'sourceResource_date_displaydate_s', :label => 'Created Date'
    config.add_show_field 'sourceResource_publisher_s', :label => 'Publisher'
    config.add_show_field 'language_facet', :label => 'Language'
    config.add_show_field 'sourceResource_extent_s', :label => 'Extent'
    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field 'all_fields', :label => 'All Fields'


    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field('title') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
        :qf => '$title_qf',
        :pf => '$title_pf'
      }
    end

    config.add_search_field('creator') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'creator' }
      field.solr_local_parameters = {
        :qf => '$creator_qf',
        :pf => '$creator_pf'
      }
    end

    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as
    # config[:default_solr_parameters][:qt], so isn't actually neccesary.
    config.add_search_field('subject') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
      field.qt = 'search'
      field.solr_local_parameters = {
        :qf => '$subject_qf',
        :pf => '$subject_pf'
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, pub_date_sort desc, title_sort asc', :label => 'relevance'
    config.add_sort_field 'pub_date_sort desc, title_sort asc', :label => 'year'
    config.add_sort_field 'author_sort asc, title_sort asc', :label => 'author'
    config.add_sort_field 'title_sort asc, pub_date_sort desc', :label => 'title'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
  end

end 
