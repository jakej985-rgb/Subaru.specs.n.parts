using Microsoft.Maui.Controls;
using SubaruParts.App.Navigation;
using SubaruParts.App.Pages;
using SubaruParts.App.Pages.Browse;
using SubaruParts.App.Pages.Browse.Vehicle;
using SubaruParts.App.Pages.Browse.Engine;
using SubaruParts.App.Pages.PartLookup;
using SubaruParts.App.Pages.SpecsLibrary;
using SubaruParts.App.Pages.CompatibilityTools;
using SubaruParts.App.Pages.MyStuff;
using SubaruParts.App.Pages.Contribute;
using SubaruParts.App.Pages.Settings;

namespace SubaruParts.App
{
    public partial class AppShell : Shell
    {
        public AppShell()
        {
            InitializeComponent();
            RegisterRoutes();
        }

        private void RegisterRoutes()
        {
            // Browse / Vehicle
            Routing.RegisterRoute(Routes.BrowseVehicle, typeof(VehicleBrowsePage));
            Routing.RegisterRoute(Routes.BrowseVehicleSelect, typeof(VehicleSelectPage));
            Routing.RegisterRoute(Routes.VehiclePage, typeof(VehiclePage));

            // Browse / Engine
            Routing.RegisterRoute(Routes.BrowseEngine, typeof(EngineBrowsePage));
            Routing.RegisterRoute(Routes.BrowseEngineSelect, typeof(EngineSelectPage));
            Routing.RegisterRoute(Routes.EnginePage, typeof(EnginePage));

            // Part lookup
            Routing.RegisterRoute(Routes.PartPage, typeof(PartPage));

            // Specs library
            Routing.RegisterRoute(Routes.SpecsCategory, typeof(SpecsCategoryPage));

            // Compatibility tools
            Routing.RegisterRoute(Routes.SwapChecker, typeof(SwapCheckerPage));
            Routing.RegisterRoute(Routes.EcuHarness, typeof(EcuHarnessHelperPage));
            Routing.RegisterRoute(Routes.SensorDiff, typeof(SensorDiffFinderPage));

            // My stuff
            Routing.RegisterRoute(Routes.Favorites, typeof(FavoritesPage));
            Routing.RegisterRoute(Routes.Recents, typeof(RecentsPage));
            Routing.RegisterRoute(Routes.SavedBuilds, typeof(SavedBuildsPage));
            Routing.RegisterRoute(Routes.OfflinePacks, typeof(OfflinePacksPage));

            // Contribute
            Routing.RegisterRoute(Routes.SubmitCorrection, typeof(SubmitCorrectionPage));
            Routing.RegisterRoute(Routes.AddCrossRef, typeof(AddCrossRefPage));
            Routing.RegisterRoute(Routes.AddNote, typeof(AddNotePage));
            Routing.RegisterRoute(Routes.AddSource, typeof(AddSourcePage));

            // Settings
            Routing.RegisterRoute(Routes.Units, typeof(UnitsPage));
            Routing.RegisterRoute(Routes.DefaultFilters, typeof(DefaultFiltersPage));
            Routing.RegisterRoute(Routes.OfflineCache, typeof(OfflineCachePage));
            Routing.RegisterRoute(Routes.Sources, typeof(SourcesPage));
            Routing.RegisterRoute(Routes.AppInfo, typeof(AppInfoPage));

            // Note: RouteAudit is in the Flyout, so it's auto-registered, but safe to register again or skip.
            // Since it's a root item in Flyout, we don't strictly need to register it for push nav,
            // but if we link to it from elsewhere using GoToAsync, Shell handles it.
        }
    }
}
