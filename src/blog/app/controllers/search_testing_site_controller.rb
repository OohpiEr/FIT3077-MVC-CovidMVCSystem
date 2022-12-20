require_relative '../../../handler/testing_site_handler'
require_relative '../../../registration/testing_site'
require_relative '../../../registration/testing_site_type'

class SearchTestingSiteController < ApplicationController

  def index
  end

  def search
    testingSiteHandler = TestingSiteHandler.getInstance
    suburb = params[:suburb]
    facilityTypes = []
    if params["is_drive_through"] == "1"
      facilityTypes << TestingSiteType::DriveThrough
    end
    if params["is_walk_in"] == "1"
      facilityTypes << TestingSiteType::WalkIn
    end
    if params["is_clinic"] == "1"
      facilityTypes << TestingSiteType::Clinic
    end
    if params["is_gp"] == "1"
      facilityTypes << TestingSiteType::GP
    end
    if params["is_hospital"] == "1"
      facilityTypes << TestingSiteType::Hospital
    end
    @results = testingSiteHandler.filterTestingSites(suburb, facilityTypes).map!(&:toHTML)
    if @results.empty?
      flash.now[:notice] = "No Results"
      render :search
    else
      render :search
    end
  end

end
