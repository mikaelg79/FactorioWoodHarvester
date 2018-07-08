--control.lua

local harvest_speed = 5*60 -- in ticks (60 tick/s)
local harvest_range = 10 -- radius of harvesting area, in tiles

script.on_event(
    {
        defines.events.on_built_entity,
        defines.events.on_robot_built_entity
    },
    function(event) onBuilt(event.created_entity) end
)

function registerTickHandler()
    if global.woodHarvesters then
        script.on_nth_tick(harvest_speed,doHarvest)
    end
end

script.on_load(registerTickHandler)
script.on_init(registerTickHandler)
script.on_configuration_changed(registerTickHandler)

function unRegisterTickHandler()
    script.on_nth_tick(harvest_speed,nil)
end

function onBuilt(entity)
    if entity.name == "wood-harvester" then
        if not global.woodHarvesters then global.woodHarvesters = {} end
        global.woodHarvesters[#global.woodHarvesters+1] = entity
        game.print("Harvesters: " .. #global.woodHarvesters)
        -- start animation
        registerTickHandler()
    end
end

function doHarvest()
    game.print(#global.woodHarvesters .. " active harvesters")
    for i,harvester in pairs(global.woodHarvesters) do
        if not harvester.valid then
            game.print "Removed invalid harvester"
            table.remove(global.woodHarvesters, i)
        else
            local searchArea = {
                {harvester.position.x-harvest_range,harvester.position.y-harvest_range},
                {harvester.position.x+harvest_range,harvester.position.y+harvest_range}
            }
            local tree = harvester.surface.find_entities_filtered{type="tree",limit=1,area=searchArea}[1]
            if not tree then
                game.print "Harvester has run out of trees"
                -- stop animation
                table.remove(global.woodHarvesters,i)
            else
                local treeProducts = tree.prototype.mineable_properties.products
                local harvested_amount = 0
                for _,product in pairs(treeProducts) do
                    if harvester.can_insert(product) then
                        game.print("Harvested " .. product.amount .. " units of " .. product.name)
                        harvester.insert{name=product.name,count=product.amount}
                        tree.die()
                        -- start animation
                    else
                        game.print "Harvester is full"
                        -- stop animation
                    end
                end
            end
        end
    end
    if #global.woodHarvesters == 0 then
        game.print "No valid harvesters left"
        global.woodHarvesters = nil
        unRegisterTickHandler()
    end
end




