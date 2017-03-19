class CompetenciesController < ApplicationController
  require 'csv'
  # GET /competencies
  # GET /competencies.json
  def index
    @competencies = Competency.all
  end

  def import
    file = params[:file]
    CSV.foreach(file.path, {:headers => true, :encoding => 'ISO-8859-1'}) do |row|
      puts(file.path)
      byebug
    end
    redirect_to competencies_url
  end
end