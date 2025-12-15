using Xunit;
using SubaruParts.Navigation;
using SubaruParts.Navigation.Models;
using System.Linq;

namespace SubaruParts.Tests.Navigation;

public class HomeMenuTests
{
    [Fact]
    public void AppRoutes_ShouldContainExpectedConstants()
    {
        Assert.Equal("//browse/ymm", AppRoutes.BrowseYmm);
        Assert.Equal("//parts/xref", AppRoutes.PartsXref);
        Assert.Equal("//compat/ecu", AppRoutes.CompatEcu);
    }

    [Fact]
    public void HomeMenuRegistry_Browse_ShouldReturnCorrectTiles()
    {
        var tiles = HomeMenuRegistry.GetTiles(HomeSegment.Browse);

        Assert.Contains(tiles, t => t.Title == "Year/Make/Model" && t.Route == AppRoutes.BrowseYmm);
        Assert.Contains(tiles, t => t.Title == "By Engine" && t.Route == AppRoutes.BrowseEngine);
    }

    [Fact]
    public void HomeMenuRegistry_Parts_ShouldReturnCorrectTiles()
    {
        var tiles = HomeMenuRegistry.GetTiles(HomeSegment.Parts);

        Assert.Contains(tiles, t => t.Title == "Part Lookup" && t.Route == AppRoutes.Parts);
        Assert.Contains(tiles, t => t.Title == "Cross Reference" && t.Route == AppRoutes.PartsXref);
        Assert.Contains(tiles, t => t.Title == "OEM Number" && t.Route == AppRoutes.PartsOem);
    }

    [Fact]
    public void HomeMenuRegistry_Specs_ShouldReturnCorrectTiles()
    {
        var tiles = HomeMenuRegistry.GetTiles(HomeSegment.Specs);

        Assert.Contains(tiles, t => t.Title == "Specs Library" && t.Route == AppRoutes.Specs);
        Assert.Contains(tiles, t => t.Title == "Fluids" && t.Route == AppRoutes.SpecsFluids);
    }

    [Fact]
    public void HomeMenuRegistry_Tools_ShouldReturnCorrectTiles()
    {
        var tiles = HomeMenuRegistry.GetTiles(HomeSegment.Tools);

        Assert.Contains(tiles, t => t.Title == "Compat Tools" && t.Route == AppRoutes.Compat);
        Assert.Contains(tiles, t => t.Title == "ECU / Harness" && t.Route == AppRoutes.CompatEcu);
    }

    [Fact]
    public void HomeMenuRegistry_GetSegmentTitle_ShouldReturnCorrectTitles()
    {
        Assert.Equal("Browse Catalog", HomeMenuRegistry.GetSegmentTitle(HomeSegment.Browse));
        Assert.Equal("Part Lookup", HomeMenuRegistry.GetSegmentTitle(HomeSegment.Parts));
        Assert.Equal("Specs Library", HomeMenuRegistry.GetSegmentTitle(HomeSegment.Specs));
        Assert.Equal("Compatibility Tools", HomeMenuRegistry.GetSegmentTitle(HomeSegment.Tools));
    }
}
