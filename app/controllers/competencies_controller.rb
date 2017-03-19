class CompetenciesController < ApplicationController
  require 'csv'
  # GET /competencies
  # GET /competencies.json
  def index
    @competencies = Competency.all
  end

  def new
    @competency = Competency.new
    # @competency.attributes = {name: "", description: "temp"}
    # if @competency.save
    #   redirect_to competencies_path, notice: "Successfully created #{@competency.name}"
    # else
    #   render "new"
    # end
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