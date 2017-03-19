class ImportsController < ApplicationController
  require 'roo'

  def parse
    file = params[:file]

    spreadsheet = open_spreadsheet(file)
    # spreadsheet.each_with_pagename do |name, sheet|
    #   byebug
    #   p sheet.row(1)
    # end
    competencies_sheet = spreadsheet.sheet("Competencies")
    # competencies = competencies_sheet.parse(header_search: ["Name", "Description"])
    competencies_hash = competencies_sheet.parse(name: "Name", description: "Description")
    competencies = []
    # competencies_sheet.each_row_streaming do |row|
    #   byebug
    #   puts row.inspect # Array of Excelx::Cell objects
    # end
    competencies_hash.each_with_index do |c, index|
      competency = Competency.new
      competency.attributes = c.to_hash
      competencies << competency
    end

    save_competencies(competencies)

    levels_sheet = spreadsheet.sheet("Levels")
    levels = levels_sheet.parse(header_search: ["Name", "Description", "Ranking"])

    redirect_to competencies_url
  end

  def save_competencies(competencies)
    if competencies.map(&:valid?).all?
      competencies.each(&:save!)
      true
    else
      flash[:error] = []
      competencies.each_with_index do |competency, index|
        competency.errors.full_messages.each do |message|
          flash[:error] << "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def open_spreadsheet(file)
    # case File.extname(file.original_filename)
    # when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    # when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    # when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    # else raise "Unknown file type: #{file.original_filename}"
    # end
    Roo::Spreadsheet.open(file.path)
  end
end