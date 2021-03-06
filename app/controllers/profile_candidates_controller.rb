class ProfileCandidatesController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :authenticate_user!, :only => [:new, :step1, :index, :progress_status]
  before_filter :check_submission_status!, :only => [:step2, :step3, :step4]
  
  def step1
    @user = User.new
    if user_signed_in?
      redirect_to step2_profile_candidates_path
    else
      session[:after_sign_in_path_for] = step2_profile_candidates_path
    end
  end
  
  def step2
    # current_user is the currently signed in user
    @profile = current_user.profile_candidate
    
    if @profile.nil?
      @profile = ProfileCandidate.new
    else
      @is_announcement_displayed = check_announcement(@profile)
    end

    respond_to do |format|
      format.html 
      format.json { render json: @profile }
    end
  end

  def step2_branching
    # current_user is the currently signed in user
    @profile = current_user.profile_candidate
    if @profile.nil?
      redirect_to step2_profile_candidates_path, :alert => 'Mohon isi halaman ini terlebih dahulu'
    else
      case @profile.choose_type
        when 0
          redirect_to new_strategic_leader_profile_path, :alert => flash[:alert]
        when 1
          redirect_to new_local_leader_profile_path, :alert => flash[:alert]
        when 2
          redirect_to new_activist_profile_path, :alert => flash[:alert]
      end
    end
  end
  
  def step3
    @profile = current_user.profile_candidate
    @profileactivist = current_user.activist_profile
    @profilelocal = current_user.local_leader_profile
    @profilestrategic = current_user.strategic_leader_profile
    if @profile.nil?
      redirect_to step2_profile_candidates_path, :alert => 'Mohon isi halaman ini terlebih dahulu'
    elsif @profilestrategic.nil? and @profilelocal.nil? and @profileactivist.nil?
      redirect_to step2_branching_profile_candidates_path, :alert => 'Mohon isi halaman ini terlebih dahulu (Bagian Khusus)'
    else
      if params[:uploaded]
        flash[:notice] = "Foto Anda sudah diupload. Jika tidak ingin menganti, silakan klik Next"
      else
        flash[:notice] = nil
      end
      @is_announcement_displayed = check_announcement(@profile)
      
      respond_to do |format|
        format.html 
        format.json { render json: @profile }
      end
    end
  end 
  
  def step3a
    @profile = current_user.profile_candidate
    if @profile.nil? or !@profile.photo?
      redirect_to step3_profile_candidates_path, :alert => 'Mohon isi halaman ini terlebih dahulu'
    else
      if params[:uploaded]
        flash[:notice] = "KTP Anda sudah diupload. Jika tidak ingin menganti, silakan klik Next"
      else
        flash[:notice] = nil
      end
      @is_announcement_displayed = check_announcement(@profile)
      
      respond_to do |format|
        format.html 
        format.json { render json: @profile }
      end
    end
  end

  def step4
    @profile = current_user.profile_candidate
    if @profile.nil? or !@profile.identification_card?
      redirect_to step3a_profile_candidates_path, :alert => 'Mohon isi halaman ini terlebih dahulu'
    else
      if params[:uploaded]
        flash[:notice] = "Surat rekomendasi Anda sudah diupload. Jika tidak ingin mengganti, silakan klik Next"
      else
        flash[:notice] = nil
      end
      @is_announcement_displayed = check_announcement(@profile)
      
      respond_to do |format|
        format.html 
        format.json { render json: @profile }
      end
    end
  end
  
  def step5
    @profile = current_user.profile_candidate
    @profileactivist = current_user.activist_profile
    @profilelocal = current_user.local_leader_profile
    @profilestrategic = current_user.strategic_leader_profile
    if @profile.nil? or !@profile.recommendation_letter?
      redirect_to step4_profile_candidates_path, :alert => 'Mohon isi halaman ini terlebih dahulu'
    elsif @profilestrategic.nil? and @profilelocal.nil? and @profileactivist.nil?
      redirect_to step2_branching_profile_candidates_path, :alert => 'Mohon isi halaman ini terlebih dahulu (Bagian Khusus)'
    else
      @is_announcement_displayed = check_announcement(@profile)
      
      respond_to do |format|
        format.html 
        format.json { render json: @profile }
      end
    end
  end
  
  def index
    @profiles = ProfileCandidate.submitted.chronological
    
    if params[:province]
      @profiles = @profiles.where(:province => params[:province])
    end
    if params[:fullname]
      @profiles = @profiles.where("lower(fullname) like lower('%' || ? || '%')", params[:fullname])
    end
    if params[:school]
      @profiles = @profiles.where(:school => params[:school])
    end
    
    @profiles = @profiles.paginate(:page => params[:page],:per_page => 20)
    
    if user_signed_in?
      @profile = ProfileCandidate.find_by_user_id(current_user.id)
    end
        
    (@latitudes, @longitudes) = get_profile_candidates_latitudes_longitudes
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @profiles }
    end
  end

  #redirect to step1
  def new
    redirect_to step1_profile_candidates_path
  end

  #step2 post
  def create
    if !current_user.profile_candidate.nil?
      redirect_to step2a_profile_candidates_path
    else
      @profile = ProfileCandidate.new(params[:profile_candidate])
      @profile.user_id = current_user.id
      
      respond_to do |format|
        if @profile.save
          format.html { redirect_to step2_branching_profile_candidates_path }
          format.json { render json: @profile, status: :created, location: @profile }
        else
          format.html { render action: "step2" }
          format.json { render json: @profile.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  #step2 put
  def update
    @profile = current_user.profile_candidate
    
    respond_to do |format|
      if @profile.update_attributes(params[:profile_candidate])
        format.html { redirect_to step2_branching_profile_candidates_path, notice: 'Data Anda telah diupdate' }
        format.json { head :no_content }
      else
        format.html { render action: "step2" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload_photo
    @profile = current_user.profile_candidate
    if !params[:profile_candidate].nil? && @profile.update_attribute(:photo, params[:profile_candidate][:photo])
      @success = true
      render "upload_photo_response", :layout => false
    else
      @success = false
      render "upload_photo_response", :layout => false
    end
  end

  def upload_identification_card
    @profile = current_user.profile_candidate
    if !params[:profile_candidate].nil? && @profile.update_attribute(:identification_card, params[:profile_candidate][:identification_card])
      @success = true
      render "upload_identification_card_response", :layout => false
    else
      @success = false
      render "upload_identification_card_response", :layout => false
    end
  end
  
  def upload_recommendation_letter
    @profile = current_user.profile_candidate
    if !params[:profile_candidate].nil? && @profile.update_attribute(:recommendation_letter, params[:profile_candidate][:recommendation_letter])
      @success = true
      render "upload_recommendation_letter_response", :layout => false
    else
      @success = false
      render "upload_recommendation_letter_response", :layout => false
    end
  end
  
  def submit_confirmation
    @profile = current_user.profile_candidate
    if params[:confirmation] && params[:confirmation] == "1" && @profile.update_attributes({:status => 'SUBMITTED', :submitted_at => Time.now}, :as => :confirmation_step)
      Rails.cache.delete('profile_candidates_latitudes_longitudes')
      redirect_to profile_candidates_path, notice: 'Data Anda sudah kami terima. Terimakasih'
    else
      redirect_to step5_profile_candidates_path, :alert => 'Anda harus mencentang persetujuan di bawah'
    end
  end
  
  #only for updating biodata
  def update_biodata
    @profile = current_user.profile_candidate
    
    respond_to do |format|
      if @profile.update_attributes(params[:profile_candidate], :as => :additional_fields)
        format.html { redirect_to profile_candidates_path, notice: 'Data Anda telah diupdate' }
        format.json { head :no_content }
      else
        format.html { redirect_to profile_candidates_path, alert: 'Data Anda tidak valid. Pastikan jumlah karakter tidak melebihi 160 karakter' }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    authorize! :update, ProfileCandidate, :message => 'Not authorized as a recruiter.'
    @profile = ProfileCandidate.find(params[:id])
  end
  
  def update_point
    authorize! :update, ProfileCandidate, :message => 'Not authorized as a recruiter.'
    @profile = ProfileCandidate.find(params[:profile_candidate][:id])
    
    respond_to do |format|
      if @profile.update_attributes(params[:profile_candidate], :as => :recruiter)
        @profile.update_attributes({:marked_by => current_user, :status => 'MARKED'}, :as => :recruiter)
        format.html { redirect_to recruiter_index_path(:page => params[:page]), :notice => "Data telah disimpan" }
        format.json { head :no_content }
      else
        format.html { render "edit" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update_marked_by
    authorize! :update, ProfileCandidate, :message => 'Not authorized as a recruiter.'
    
    ProfileCandidate.update_all({marked_by_id: params[:recruiter][:id]}, {id: params[:profile_candidate_ids]})
    index_param = if params[:page] then {:page => params[:page]} end
    redirect_to recruiter_index_path(index_param)
  end
  
  def progress_status
    email = params[:email]
    unless email.nil?
      user = User.where("lower(email) like lower(?)", email.strip).first
      unless user.nil?
        profile_candidate = user.profile_candidate
        @is_biodata_filled = !profile_candidate.nil?
        if @is_biodata_filled
          @is_photo_uploaded = profile_candidate.photo?
          @is_identification_card_uploaded = profile_candidate.identification_card?
          @is_recommendation_letter_uploaded = profile_candidate.recommendation_letter?
          @is_submitted = profile_candidate.status != 'NOT SUBMITTED' 
        end
      end
    end
  end

  def acceptance_status
    @profile = current_user.profile_candidate
  end
  
  def update_acceptance_status
    @profile = current_user.profile_candidate
    is_candidate_accept_offer = params[:profile_candidate][:is_candidate_accept_offer]
    
    @profile.update_attributes({:is_candidate_accept_offer => is_candidate_accept_offer}, :as => :update_acceptance)
    redirect_to acceptance_status_profile_candidates_path, :notice => "Pilihan Anda telah diterima"
  end
end
