--item.lua

-- ["electric-mining-drill"] = {
--     flags = {
--       "goes-to-quickbar"
--     },
--     icon = "__base__/graphics/icons/electric-mining-drill.png",
--     icon_size = 32,
--     name = "electric-mining-drill",
--     order = "a[items]-b[electric-mining-drill]",
--     place_result = "electric-mining-drill",
--     stack_size = 50,
--     subgroup = "extraction-machine",
--     type = "item"
-- },

local woodHarvester = table.deepcopy(data.raw.item["assembling-machine-1"])
woodHarvester.name = "wood-harvester"
woodHarvester.icons = {
    {
       icon = woodHarvester.icon,
       tint = {
           r=0.5,
           g=0,
           b=0.5,
           a=0.5
        }
    },
 }
woodHarvester.place_result = "wood-harvester"

data:extend{woodHarvester}