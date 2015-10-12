class FlagVotesController < ApplicationController
  include Blacklight::SearchHelper

  before_action :check_permissions, only: [:destroy]
  before_action :record_updated, only: [:create, :destroy]
  before_action :require_management_permission, only: [:index, :show]
  skip_before_action :require_management_permission, if: :skip_require_flag_manager



  def index
    respond_to do |format|
      format.html { @flag_votes = FlagVote.page(params[:page]).per(25) }
      format.json { render json: get_votes_and_records(FlagVote.all).to_json }
    end
  end

  def show
    votes = FlagVote.where(flag_id: params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => get_records(votes).to_json }
      format.text { render :text => get_records(votes).join("\n") }
    end
  end


  def create
    user_id = user_id(flag_vote_params[:user_id])
    @flag_vote = FlagVote.new(flag_vote_params.except(:delta).merge({:user_id => user_id}))
    @flag_vote.save
  end

  def destroy
    FlagVote.find_by(flag_vote_params.except(:delta)).destroy
  end

  private

  def get_votes_and_records(flag_votes)
    # See Blacklight::SearchHelper for def fetch
    FlagVote.votes_and_records(flag_votes) do |record_id|
      fetch(record_id).last
    end
  end

  def get_records(flag_votes)
    FlagVote.records(flag_votes) do |record_id|
      fetch_record(record_id)
    end
  end

  def fetch_record(record_id)
    fetch(record_id).last
  rescue Blacklight::Exceptions::RecordNotFound
    Rails.logger.error "Blacklight::Exceptions::RecordNotFound: #{record_id}"
    nil
  end

  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in(guest_user_id)
        guest_user(with_retry = false).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)
  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user if with_retry
  end

  # creates guest user by adding a record to the DB
  # with a guest name and email
  def create_guest_user
    email = "guest_#{Time.now.to_i}#{rand(99)}@example.com"
    u = User.create(:email => email)
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end

  def logging_in(guest_user_id)

  end

  def record_updated
    @record_id = flag_vote_params[:record_id]
    @flag_id = flag_vote_params[:flag_id]
    @delta = flag_vote_params[:delta]
  end

  def flag_vote_params
    params.require(:flag_vote).permit(:flag_id, :record_id, :user_id, :delta)
  end

  def user_id(user_id)
    (!user_id.blank?) ? user_id : current_or_guest_user.id
  end

  def check_permissions
    authorize! :manage, FlagVote unless is_flag_owner?
  end

  def is_flag_owner?
    !current_or_guest_user.nil? && flag_vote_params[:user_id].to_s == current_or_guest_user.id.to_s
  end

  def require_management_permission
    authorize! :manage, Flag
  end

  def skip_require_flag_manager
    (action_name == 'index' || action_name == 'show')  && (request.format.json? || request.format.xml? || request.format.text?)
  end
end