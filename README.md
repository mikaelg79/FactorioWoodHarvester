# FactorioWoodHarvester

A mod for Factorio to auto harvest trees from the world. Intended as an early-game help for clearing out forests and automating early wood gathering, not intended as a self-sustaining wood factory.

If you're looking for regrowing or plantable trees, check out the "tree-growth" or "treefarm" mods


Big thanks to eradicator on the Factorio forums for helping a newbie out.

Official forums thread: https://forums.factorio.com/61448




--- Version 0.17.1 ---

Compatibility:

* Updated to work with Factorio 0.17

* Mod should now work better when installed alongside other mods that modify trees such as BioIndustries, TreeFarm and TreeGrowth.

Changes:

* Harvesters no longer silently disable themselves when running out of trees to harvest, but mark themselves for deconstruction once all materials have been removed. (Can be changed in mod settings)

* Harvester recipe changed due to removal of iron axes, now only requires 5 gears and 10 plates.

Bugfixes:

* Harvesters now actually stop harvesting when marked for deconstruction, and won't refill the input slot while inactive.

Cosmetic:

* Major/minor mod version follows Factorio, so mod version 0.17.x is compatible with Factorio 0.17

--- Older versions ---

0.0.11: Fixed a crash when a tree in rare occasions would provide raw wood with a nil amount.

0.0.10: Fixed recipe items amounts incorrectly defined as strings instead of ints.

0.0.9:  Fixed an error message when the mod was added to an existing game.

0.0.8:  Fixed the recipe sorting, now sorts after Pumpjacks in the extraction machine subcategory.

        Harvester now starts cutting trees closest to itself and works its way out.
