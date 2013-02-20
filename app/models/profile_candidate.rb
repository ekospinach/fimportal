class ProfileCandidate < ActiveRecord::Base
  attr_accessible :application_count, :batch, :blood_type, :committee, :dob, :fullname, :gender, :hobby, :information_from, :location, :motivation, :non_formal_education, :organization, :performance_type, :phone, :place_of_birth, :referal, :religion, :school, :workshop, :latitude, :longitude, :agreement
  belongs_to :user
  
  validates :application_count, :batch, :blood_type, :dob, :fullname, :gender, :information_from, :location, :motivation, :phone, :place_of_birth, :religion, :school, :latitude, :longitude, :agreement, :presence => true
end
