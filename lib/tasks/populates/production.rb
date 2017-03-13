# For production environment only populate these models:
# Level, Paradigm, User

# Step 1: Create the Levels
levels = 
  [
    ["Champion", "The highest level of indicators.", 1, true],
    ["Contributer", "The middle level of indicators.", 2, true],
    ["Companion", "The lowest level of indicators.", 3, true]
  ]
levels.each do |level|
  l = Level.new
  l.name = level[0] 
  l.description = level[1]
  l.ranking = level[2]
  l.active = level[3]
  l.save!
end