using System.Collections.Generic;
using SubaruParts.Navigation.Models;

namespace SubaruParts.Navigation;

public static class HomeMenuRegistry
{
    public static List<HomeTile> GetTiles(HomeSegment segment)
    {
        var tiles = new List<HomeTile>();

        switch (segment)
        {
            case HomeSegment.Browse:
                tiles.Add(new HomeTile { Title = "Year/Make/Model", Subtitle = "Search by vehicle", Icon = "search.png", Route = AppRoutes.BrowseYmm });
                tiles.Add(new HomeTile { Title = "By Engine", Subtitle = "Search by engine family", Icon = "engine.png", Route = AppRoutes.BrowseEngine });
                break;

            case HomeSegment.Parts:
                tiles.Add(new HomeTile { Title = "Part Lookup", Subtitle = "Search by keyword", Icon = "part.png", Route = AppRoutes.Parts });
                tiles.Add(new HomeTile { Title = "Cross Reference", Subtitle = "Find interchange", Icon = "swap.png", Route = AppRoutes.PartsXref });
                tiles.Add(new HomeTile { Title = "OEM Number", Subtitle = "Lookup by OEM #", Icon = "oem.png", Route = AppRoutes.PartsOem });
                break;

            case HomeSegment.Specs:
                tiles.Add(new HomeTile { Title = "Specs Library", Subtitle = "Full library", Icon = "library.png", Route = AppRoutes.Specs });
                tiles.Add(new HomeTile { Title = "Fluids", Subtitle = "Oil, coolant, etc.", Icon = "drop.png", Route = AppRoutes.SpecsFluids });
                tiles.Add(new HomeTile { Title = "Torque", Subtitle = "Torque specs", Icon = "wrench.png", Route = AppRoutes.SpecsTorque });
                tiles.Add(new HomeTile { Title = "Filters", Subtitle = "Filter lookup", Icon = "filter.png", Route = AppRoutes.SpecsFilters });
                break;

            case HomeSegment.Tools:
                tiles.Add(new HomeTile { Title = "Compat Tools", Subtitle = "All tools", Icon = "tools.png", Route = AppRoutes.Compat });
                tiles.Add(new HomeTile { Title = "ECU / Harness", Subtitle = "Wiring helpers", Icon = "ecu.png", Route = AppRoutes.CompatEcu });
                tiles.Add(new HomeTile { Title = "Transmission", Subtitle = "Swap helper", Icon = "gear.png", Route = AppRoutes.CompatTrans });
                tiles.Add(new HomeTile { Title = "NA to Turbo", Subtitle = "Conversion guide", Icon = "turbo.png", Route = AppRoutes.CompatNa2t });
                break;
        }

        return tiles;
    }

    public static string GetSegmentTitle(HomeSegment segment)
    {
        return segment switch
        {
            HomeSegment.Browse => "Browse Catalog",
            HomeSegment.Parts => "Part Lookup",
            HomeSegment.Specs => "Specs Library",
            HomeSegment.Tools => "Compatibility Tools",
            _ => ""
        };
    }
}
