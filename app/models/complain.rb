class Complain < ActiveRecord::Base
	belongs_to :contravertion
	belongs_to :crime
	belongs_to :patrol_unit
	belongs_to :complainant
	belongs_to :user
  before_validation :uppercase
	attr_accessor :auxValue
	validates :description, :presence => {:message => ' no debe dejarse en blanco.'}
#	validates :protagonists, :presence => {:message => ' no debe dejarse en blanco.'}

  validates :latitude, :presence => {:message => ' y Longitud deben definirse en el mapa'}


	def self.search(search)
		where("name LIKE :search ", search:"%#{search}%")
	end
	def crime_name
		crime.name if crime
	end
	def crime_name=(name)
	self.crime= Crime.find_by_name(name) unless name.blanck?
	end

	protected
	def uppercase
  #	self.protagonists = self.protagonists.upcase
	end



end
