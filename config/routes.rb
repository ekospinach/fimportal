FimAlumni::Application.routes.draw do
  resources :profile_candidates, :path => 'candidates' do
    collection do
      get 'step1'
      get 'step2'
      get 'step3'
      get 'step4'
      
      match 'upload_photo' => 'profile_candidates#upload_photo', :via => :post
      match 'upload_recommendation_letter' => 'profile_candidates#upload_recommendation_letter', :via => :post
    end
  end
  
  resource :profile
  resources :profiles
  
  match '/alumni' => 'home#index_alumni', :as => 'alumni_home'
  match '/candidate' => 'home#index_candidate', :as => 'candidate_home'
  
  # authenticated :user do
    # root :to => 'home#index_authenticated'
  # end
  root :to => "home#index"
  devise_for :users
  resources :users
end