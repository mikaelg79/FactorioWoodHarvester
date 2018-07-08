-- migrations.lua

for index,force in pairs(game.forces) do
    force.recipes["wood-harvester"].enabled = force.technologies["automation"].researched
    force.recipes["wood-harvester"].reload()
end
