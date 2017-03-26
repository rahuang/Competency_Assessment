class Indicator < ActiveRecord::Base
  # Relationships
  belongs_to :competency
  belongs_to :level

  # Validations
  validates_presence_of :competency_id, :level_id, :description
  validates_numericality_of :competency_id, only_integer: true
  validates_numericality_of :level_id, only_integer: true

  # Scopes
  scope :alphabetical, -> { order("indicators.description") }
  scope :by_level, -> { joins(:level).order("levels.ranking") }
  scope :by_competency, -> { joins(:competency).order("competencies.name") }
  scope :for_level, -> (level) { joins(:level).where("levels.name LIKE ?", level) }
  scope :for_description, -> (desc) { where("indicators.description LIKE ?", desc) }
  scope :for_competency, -> (competency) { joins(:competency).where("competencies.name LIKE ?", competency) }
  scope :active, -> { where("indicators.active = ?", true) }
  scope :inactive, -> { where("indicators.active = ?", false) }


  # Methods
  def self.parse(spreadsheet, competencies, levels)
    indicators_sheet = spreadsheet.sheet("Indicators")
    indicators_hash = 
      indicators_sheet.parse(level_id: "Level_ID", description: "Description")

    indicators = []
    indicators_hash.each_with_index do |i, index|
      indicator = Indicator.new
      # Used to set the foreign keys. 
      # competency_id is always set to the first competency, since there's only 1 competency per spreadsheet
      i[:competency_id] = competencies[0].id
      # level_id should be the id of the level relative to the row number of levels
      i[:level_id] = levels[i[:level_id] - 2].id
      indicator.attributes = i.to_hash
      indicators << indicator
    end
    return indicators
  end

end
