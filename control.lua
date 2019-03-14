--control.lua

require("whutil")

debug_on = 0

local harvest_speed = 60 -- in ticks (60 tick/s)
local harvest_min_range = 2 -- starting radius of harvesting area, in tiles
local harvest_max_range = 24 -- max radius of harvesting area, in tiles
local harvest_stack = 6 -- Harvest this much timber before waiting for conversion to wood to finish.
local default_timber_amount = 3 -- How much timber to add if product.amount isn't provided.

local trees_base = { -- List of tree names in base factorio
    "dead-dry-hairy-tree","dead-grey-trunk","dead-tree-desert","dry-hairy-tree","dry-tree",
    "tree-01","tree-02","tree-02-red","tree-03","tree-04","tree-05","tree-06","tree-06-brown",
    "tree-07","tree-08","tree-08-brown","tree-08-red","tree-09","tree-09-brown","tree-09-red"
}
global.tree_names = {}

function registerTickHandler()
    if global.woodHarvesters then
        script.on_nth_tick(harvest_speed,doHarvest)
    end
end

function unRegisterTickHandler()
    script.on_nth_tick(harvest_speed,nil)
end

function checkForUpdate(event)
    if (event.mod_changes["WoodHarvester"]) then
        local mod = event.mod_changes["WoodHarvester"]
        if not mod.old_version then
            -- Mod was added, do nothing
        elseif not mod.new_version then
            -- Mod was removed.
            if (global.woodHarvesters) then global.woodHarvesters = nil end
        else
            local old_version = splitversion(mod.old_version)
            -- New global.woodHarvesters structure
            if (old_version.major < 1) and (old_version.minor < 1) and (old_version.build < 8) then
                if (global.woodHarvesters) then
                    local tempHarvesters = {}
                    for i,harvester in pairs(global.woodHarvesters) do
                        tempHarvesters[i] = {["machine"]=harvester,["range"]=2}
                    end
                    global.woodHarvesters = tempHarvesters
                end
            end
            -- Future changes below
        end
    end
    global.tree_names = trees_base
    if game.active_mods["Treefarm-Lite-fix"] then
        debug_print("WoodHarvester: TreeFarm installed")
        table.insert(global.tree_names,"tf-mature-tree")
        table.insert(global.tree_names,"tf-mature-coral")
    end
end

function onBuilt(entity)
    debug_print("In onBuilt")
    if entity.name == "wood-harvester" then
        if not global.woodHarvesters then
            global.woodHarvesters = {}
            registerTickHandler()
        end
        global.woodHarvesters[#global.woodHarvesters+1] = {["machine"]=entity,["range"]=harvest_min_range}
        debug_print("Harvesters: " .. #global.woodHarvesters)
    end
end

function doHarvest()
    debug_print("In doHarvest, " .. #global.woodHarvesters .. " active harvesters")
    for i,harvester in pairs(global.woodHarvesters) do
        if not harvester.machine.valid then
            debug_print("Removed invalid harvester")
            table.remove(global.woodHarvesters, i)
        else
            if  (harvester.machine.get_inventory(defines.inventory.assembling_machine_input).get_item_count() <= 4)
                and (harvester.machine.energy > 0)
                and not (harvester.machine.to_be_deconstructed("player"))
            then
                local tree
                while (not tree) and (harvester.range < harvest_max_range) do
                    local searchArea = {
                        {harvester.machine.position.x-harvester.range,harvester.machine.position.y-harvester.range},
                        {harvester.machine.position.x+harvester.range,harvester.machine.position.y+harvester.range}
                    }
                    tree = harvester.machine.surface.find_entities_filtered{name=global.tree_names,limit=1,area=searchArea}[1]
                    if not tree then
                        debug_print("No tree found at range " .. harvester.range ..", increasing range")
                        harvester.range = harvester.range + 1
                    end
                end
                if not tree then
                    debug_print("No more trees to harvest.")
                    if  (settings.global["wh-auto-deconstruct"].value)
                        and (harvester.machine.get_inventory(defines.inventory.assembling_machine_input).get_item_count() == 0)
                        and (harvester.machine.get_inventory(defines.inventory.assembling_machine_output).get_item_count() == 0)
                    then
                        harvester.machine.order_deconstruction("player")
                    else
                        harvester.range = harvest_min_range
                    end
                else
                    local got_product = nil
                    local treeProducts = tree.prototype.mineable_properties.products
                    for _,product in pairs(treeProducts) do
                        debug_print ("Found product: " .. product.name)
                        if (product.name == "wood") then
                            if (product.amount) then
                                timber_amount = product.amount
                            else
                                timber_amount = default_timber_amount
                            end
                            got_product = true
                            if harvester.machine.can_insert({name="timber",count=timber_amount}) then
                                --debug_print("Harvested " .. timber_amount .. " units of timber")
                                harvester.machine.insert{name="timber",count=timber_amount}
                                tree.die()
                            else
                                debug_print("Can't insert timber - invalid inputs in machine?")
                            end
                        else
                            debug_print("unknown product: " .. product.name)
                        end
                    end
                    if not got_product then
                        -- Tree modded not to give raw wood? Just kill it, otherwise harvester will be stuck on the same tree forever.
                        debug_print ("Tree did not provide wood - possible mod conflict.")
                        tree.die()
                    end
                end
            end
        end
    end
    if #global.woodHarvesters == 0 then
        debug_print("No valid harvesters left")
        global.woodHarvesters = nil
        unRegisterTickHandler()
    end
end

-- MOD SETUP

script.on_configuration_changed(checkForUpdate)

script.on_load(function()
    if global.woodHarvesters then
        registerTickHandler()
    end
end)

script.on_event(
    {
        defines.events.on_built_entity,
        defines.events.on_robot_built_entity
    },
    function(event) onBuilt(event.created_entity) end
)
