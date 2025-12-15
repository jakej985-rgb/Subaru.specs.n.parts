using System.Collections.Generic;

namespace SubaruParts.Navigation;

public sealed record NavNode(
    string Route,
    string Title,
    IReadOnlyList<NavLink> Children,
    IReadOnlyDictionary<string, object>? DefaultParams = null
);

public sealed record NavLink(
    string Route,
    string Title,
    IReadOnlyDictionary<string, object>? DefaultParams = null
);

public static class NavGraph
{
    // Helper to reduce typing
    private static IReadOnlyDictionary<string, object> P(params (string k, object v)[] items)
    {
        var d = new Dictionary<string, object>();
        foreach (var (k, v) in items) d[k] = v;
        return d;
    }

    public static IReadOnlyList<NavNode> Nodes { get; } = new List<NavNode>
    {
        // HOME
        new NavNode(
            Routes.Home,
            "Home",
            new List<NavLink>
            {
                new(Routes.Browse, "Browse"),
                new(Routes.PartLookup, "Part Lookup"),
                new(Routes.SpecsLibrary, "Specs Library (Just Specs)"),
                new(Routes.CompatTools, "Compatibility Tools"),
                new(Routes.MyStuff, "My Stuff"),
                new(Routes.Contribute, "Contribute"),
                new(Routes.Settings, "Settings"),
                new(Routes.RouteAudit, "Route Audit (Debug)")
            }
        ),

        // BROWSE HUB
        new NavNode(
            Routes.Browse,
            "Browse",
            new List<NavLink>
            {
                new(Routes.BrowseVehicle, "By Vehicle"),
                new(Routes.BrowseEngine, "By Engine"),
                new(Routes.BrowseYmm, "Year/Make/Model"),
            }
        ),

        // BY VEHICLE - HUB
        new NavNode(
            Routes.BrowseVehicle,
            "Browse • By Vehicle",
            new List<NavLink>
            {
                new(Routes.BrowseVehicleSelect, "Select Vehicle"),
                new(Routes.VehiclePage, "Open Vehicle Page (example)", P(
                    (RouteKeys.Year, "2005"),
                    (RouteKeys.Make, "Subaru"),
                    (RouteKeys.Model, "Impreza"),
                    (RouteKeys.Trim, "2.5RS"),
                    (RouteKeys.EngineCode, "EJ251"),
                    (RouteKeys.Trans, "5MT"),
                    (RouteKeys.Tab, "specs")
                ))
            }
        ),

        // VEHICLE SELECT
        new NavNode(
            Routes.BrowseVehicleSelect,
            "Browse • Vehicle Select",
            new List<NavLink>
            {
                new(Routes.VehiclePage, "Go to Vehicle Page", P(
                    (RouteKeys.Year, "2005"),
                    (RouteKeys.Make, "Subaru"),
                    (RouteKeys.Model, "Impreza"),
                    (RouteKeys.Trim, "2.5RS"),
                    (RouteKeys.EngineCode, "EJ251"),
                    (RouteKeys.Trans, "5MT"),
                    (RouteKeys.Tab, "specs")
                ))
            }
        ),

        // VEHICLE PAGE (tabs)
        new NavNode(
            Routes.VehiclePage,
            "Vehicle Page",
            new List<NavLink>
            {
                new(Routes.VehiclePage, "Specs", P((RouteKeys.Tab, "specs"))),
                new(Routes.VehiclePage, "Parts", P((RouteKeys.Tab, "parts"))),
                new(Routes.VehiclePage, "Jobs",  P((RouteKeys.Tab, "jobs"))),
                new(Routes.VehiclePage, "Mods & Swaps", P((RouteKeys.Tab, "mods"))),

                // Extra deep-links reflecting your original bullets (still within Mods tab)
                new(Routes.VehiclePage, "Plug-and-Play Mods", P((RouteKeys.Tab, "mods"), ("modsSection", "plug-and-play"))),
                new(Routes.VehiclePage, "No-Fuss Swaps", P((RouteKeys.Tab, "mods"), ("modsSection", "no-fuss-swaps"))),
                new(Routes.VehiclePage, "Transmission Mods/Swaps", P((RouteKeys.Tab, "mods"), ("modsSection", "trans"))),
                new(Routes.VehiclePage, "NA → Turbo", P((RouteKeys.Tab, "mods"), ("modsSection", "na-to-turbo")))
            },
            DefaultParams: P(
                (RouteKeys.Year, "2005"),
                (RouteKeys.Make, "Subaru"),
                (RouteKeys.Model, "Impreza"),
                (RouteKeys.Trim, "2.5RS"),
                (RouteKeys.EngineCode, "EJ251"),
                (RouteKeys.Trans, "5MT"),
                (RouteKeys.Tab, "specs")
            )
        ),

        // BY ENGINE - HUB
        new NavNode(
            Routes.BrowseEngine,
            "Browse • By Engine",
            new List<NavLink>
            {
                new(Routes.BrowseEngineSelect, "Select Engine"),
                new(Routes.EnginePage, "Open Engine Page (example)", P(
                    (RouteKeys.EngineFamily, "EJ"),
                    (RouteKeys.Phase, "2"),
                    (RouteKeys.EngineCode, "EJ251"),
                    (RouteKeys.Tab, "specs")
                ))
            }
        ),

        // ENGINE SELECT
        new NavNode(
            Routes.BrowseEngineSelect,
            "Browse • Engine Select",
            new List<NavLink>
            {
                new(Routes.EnginePage, "Go to Engine Page", P(
                    (RouteKeys.EngineFamily, "EJ"),
                    (RouteKeys.Phase, "2"),
                    (RouteKeys.EngineCode, "EJ251"),
                    (RouteKeys.Tab, "specs")
                ))
            }
        ),

        // ENGINE PAGE (tabs)
        new NavNode(
            Routes.EnginePage,
            "Engine Page",
            new List<NavLink>
            {
                new(Routes.EnginePage, "Specs", P((RouteKeys.Tab, "specs"))),
                new(Routes.EnginePage, "Compatibility", P((RouteKeys.Tab, "compatibility"))),
                new(Routes.EnginePage, "Where Used", P((RouteKeys.Tab, "where-used")))
            },
            DefaultParams: P(
                (RouteKeys.EngineFamily, "EJ"),
                (RouteKeys.Phase, "2"),
                (RouteKeys.EngineCode, "EJ251"),
                (RouteKeys.Tab, "specs")
            )
        ),

        // PART LOOKUP
        new NavNode(
            Routes.PartLookup,
            "Part Lookup",
            new List<NavLink>
            {
                new(Routes.PartsXref, "Cross Reference"),
                new(Routes.PartsOem, "OEM Part Number"),
                new(Routes.PartPage, "Open Part Page (OEM example)", P(
                    (RouteKeys.Oem, "15208AA15A"),
                    (RouteKeys.Tab, "cross-references")
                )),
                new(Routes.PartPage, "Open Part Page (Aftermarket example)", P(
                    (RouteKeys.Aftermarket, "WIX-57712"),
                    (RouteKeys.Tab, "cross-references")
                ))
            }
        ),

        // PART PAGE (tabs)
        new NavNode(
            Routes.PartPage,
            "Part Page",
            new List<NavLink>
            {
                new(Routes.PartPage, "Cross-References", P((RouteKeys.Tab, "cross-references"))),
                new(Routes.PartPage, "Where Used", P((RouteKeys.Tab, "where-used"))),
                new(Routes.PartPage, "Notes", P((RouteKeys.Tab, "notes")))
            },
            DefaultParams: P((RouteKeys.Oem, "15208AA15A"), (RouteKeys.Tab, "cross-references"))
        ),

        // SPECS LIBRARY
        new NavNode(
            Routes.SpecsLibrary,
            "Specs Library (Just Specs)",
            new List<NavLink>
            {
                new(Routes.SpecsCategory, "Fluids & Capacities", P((RouteKeys.Category, "fluids"))),
                new(Routes.SpecsCategory, "Filters", P((RouteKeys.Category, "filters"))),
                new(Routes.SpecsCategory, "Torque Specs", P((RouteKeys.Category, "torque"))),
                new(Routes.SpecsCategory, "Ignition", P((RouteKeys.Category, "ignition"))),
                new(Routes.SpecsCategory, "Belts / Service Items", P((RouteKeys.Category, "belts"))),
                new(Routes.SpecsCategory, "Conversions / Tools", P((RouteKeys.Category, "conversions")))
            }
        ),

        // SPECS CATEGORY PAGE
        new NavNode(
            Routes.SpecsCategory,
            "Specs Category",
            new List<NavLink>
            {
                new(Routes.SpecsCategory, "Fluids", P((RouteKeys.Category, "fluids"))),
                new(Routes.SpecsCategory, "Filters", P((RouteKeys.Category, "filters"))),
                new(Routes.SpecsCategory, "Torque", P((RouteKeys.Category, "torque"))),
                new(Routes.SpecsCategory, "Ignition", P((RouteKeys.Category, "ignition"))),
                new(Routes.SpecsCategory, "Belts", P((RouteKeys.Category, "belts"))),
                new(Routes.SpecsCategory, "Conversions", P((RouteKeys.Category, "conversions")))
            },
            DefaultParams: P((RouteKeys.Category, "fluids"))
        ),

        // COMPATIBILITY TOOLS
        new NavNode(
            Routes.CompatTools,
            "Compatibility Tools",
            new List<NavLink>
            {
                new(Routes.SwapChecker, "Swap Checker Wizard"),
                new(Routes.EcuHarness, "ECU / Harness Helper"),
                new(Routes.SensorDiff, "Sensor Difference Finder")
            }
        ),

        new NavNode(Routes.SwapChecker, "Swap Checker Wizard", new List<NavLink>()),
        new NavNode(Routes.EcuHarness, "ECU / Harness Helper", new List<NavLink>()),
        new NavNode(Routes.SensorDiff, "Sensor Difference Finder", new List<NavLink>()),

        // MY STUFF
        new NavNode(
            Routes.MyStuff,
            "My Stuff",
            new List<NavLink>
            {
                new(Routes.Favorites, "Favorites"),
                new(Routes.Recents, "Recently Viewed"),
                new(Routes.SavedBuilds, "Saved Builds"),
                new(Routes.OfflinePacks, "Offline Packs")
            }
        ),

        new NavNode(Routes.Favorites, "Favorites", new List<NavLink>()),
        new NavNode(Routes.Recents, "Recently Viewed", new List<NavLink>()),
        new NavNode(Routes.SavedBuilds, "Saved Builds", new List<NavLink>()),
        new NavNode(Routes.OfflinePacks, "Offline Packs", new List<NavLink>()),

        // CONTRIBUTE
        new NavNode(
            Routes.Contribute,
            "Contribute",
            new List<NavLink>
            {
                new(Routes.SubmitCorrection, "Submit Correction"),
                new(Routes.AddCrossRef, "Add Cross-Reference"),
                new(Routes.AddNote, "Add Note / Gotcha"),
                new(Routes.AddSource, "Add Source Link")
            }
        ),

        new NavNode(Routes.SubmitCorrection, "Submit Correction", new List<NavLink>()),
        new NavNode(Routes.AddCrossRef, "Add Cross-Reference", new List<NavLink>()),
        new NavNode(Routes.AddNote, "Add Note / Gotcha", new List<NavLink>()),
        new NavNode(Routes.AddSource, "Add Source Link", new List<NavLink>()),

        // SETTINGS
        new NavNode(
            Routes.Settings,
            "Settings",
            new List<NavLink>
            {
                new(Routes.Units, "Units"),
                new(Routes.DefaultFilters, "Default Filters"),
                new(Routes.OfflineCache, "Offline Cache / Packs"),
                new(Routes.Sources, "Sources / Disclaimer"),
                new(Routes.AppInfo, "App Info / Changelog")
            }
        ),

        new NavNode(Routes.Units, "Units", new List<NavLink>()),
        new NavNode(Routes.DefaultFilters, "Default Filters", new List<NavLink>()),
        new NavNode(Routes.OfflineCache, "Offline Cache / Packs", new List<NavLink>()),
        new NavNode(Routes.Sources, "Sources / Disclaimer", new List<NavLink>()),
        new NavNode(Routes.AppInfo, "App Info / Changelog", new List<NavLink>()),

        // DEBUG
        new NavNode(
            Routes.RouteAudit,
            "Route Audit (Debug)",
            new List<NavLink>()
        ),
    };

    public static NavNode? GetNode(string route)
    {
        foreach (var n in Nodes)
            if (n.Route == route) return n;
        return null;
    }
}
