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
using SubaruParts.App.Pages.Parts;
using SubaruParts.App.Pages.Specs;
using SubaruParts.App.Pages.Tools;
using SubaruParts.App.Pages.Vehicle;

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
            // NEW / UPDATED ROUTES for Blank Scaffold Pages

            // Browse
            Routing.RegisterRoute(Routes.BrowseYmm, typeof(BrowseYmmPage));
            Routing.RegisterRoute(Routes.BrowseEngine, typeof(BrowseEnginePage)); // Was EngineBrowsePage

            // Parts
            Routing.RegisterRoute("parts", typeof(PartsHomePage));
            Routing.RegisterRoute(Routes.PartsXref, typeof(CrossReferencePage));
            Routing.RegisterRoute(Routes.PartsOem, typeof(OemNumberPage));

            // Specs
            Routing.RegisterRoute("specs", typeof(SpecsHomePage));
            Routing.RegisterRoute("specs/fluids", typeof(FluidsPage));
            Routing.RegisterRoute("specs/torque", typeof(TorquePage));
            Routing.RegisterRoute("specs/filters", typeof(FiltersPage));

            // Compat
            Routing.RegisterRoute("compat", typeof(ToolsHomePage));
            Routing.RegisterRoute("compat/ecu", typeof(EcuHarnessPage));
            Routing.RegisterRoute("compat/trans", typeof(TransmissionSwapPage));
            Routing.RegisterRoute("compat/na2t", typeof(NaToTurboPage));

            // Vehicle
            Routing.RegisterRoute(Routes.VehiclePicker, typeof(VehiclePickerPage));

            // Debug
            Routing.RegisterRoute("debug/route-audit", typeof(RouteAuditPage));

            // ----------------------------------------------------------------
            // Existing routes (kept to avoid breaking other flows)

            // Placeholder routes for unimplemented pages - Removing conflicts above
            // Routing.RegisterRoute(Routes.BrowseYmm, typeof(SubaruParts.App.Pages.Shared.PlaceholderPage)); // Replaced
            // Routing.RegisterRoute(Routes.VehiclePicker, typeof(SubaruParts.App.Pages.Shared.PlaceholderPage)); // Replaced
            // Routing.RegisterRoute(Routes.PartsXref, typeof(SubaruParts.App.Pages.Shared.PlaceholderPage)); // Replaced
            // Routing.RegisterRoute(Routes.PartsOem, typeof(SubaruParts.App.Pages.Shared.PlaceholderPage)); // Replaced

            // Browse / Vehicle
            Routing.RegisterRoute(Routes.BrowseVehicle, typeof(VehicleBrowsePage));
            Routing.RegisterRoute(Routes.BrowseVehicleSelect, typeof(VehicleSelectPage));
            Routing.RegisterRoute(Routes.VehiclePage, typeof(VehiclePage));

            // Browse / Engine
            // Routing.RegisterRoute(Routes.BrowseEngine, typeof(EngineBrowsePage)); // Replaced above
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
