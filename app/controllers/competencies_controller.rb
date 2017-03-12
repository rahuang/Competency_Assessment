class CompetenciesController < ApplicationController
  # GET /competencies
  # GET /competencies.json
  def index
    @competencies = Competency.all
  end
end