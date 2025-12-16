using Microsoft.Maui.Controls;
using SubaruParts.Navigation;
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
            // Browse
            Routing.RegisterRoute(Routes.BrowseYmm, typeof(BrowseYmmPage));
            Routing.RegisterRoute(Routes.BrowseEngine, typeof(BrowseEnginePage));
            Routing.RegisterRoute(Routes.BrowseVehicle, typeof(VehicleBrowsePage));
            Routing.RegisterRoute(Routes.BrowseVehicleSelect, typeof(VehicleSelectPage));
            Routing.RegisterRoute(Routes.VehiclePage, typeof(VehiclePage));
            Routing.RegisterRoute(Routes.BrowseEngineSelect, typeof(EngineSelectPage));
            Routing.RegisterRoute(Routes.EnginePage, typeof(EnginePage));

            // Parts
            Routing.RegisterRoute(Routes.Parts, typeof(PartsHomePage));
            Routing.RegisterRoute(Routes.PartsXref, typeof(CrossReferencePage));
            Routing.RegisterRoute(Routes.PartsOem, typeof(OemNumberPage));
            Routing.RegisterRoute(Routes.PartPage, typeof(PartPage));

            // Specs
            Routing.RegisterRoute(Routes.Specs, typeof(SpecsHomePage));
            Routing.RegisterRoute(Routes.SpecsFluids, typeof(FluidsPage));
            Routing.RegisterRoute(Routes.SpecsTorque, typeof(TorquePage));
            Routing.RegisterRoute(Routes.SpecsFilters, typeof(FiltersPage));
            Routing.RegisterRoute(Routes.SpecsCategory, typeof(SpecsCategoryPage));

            // Compat
            Routing.RegisterRoute(Routes.Compat, typeof(ToolsHomePage));
            Routing.RegisterRoute(Routes.CompatEcu, typeof(EcuHarnessPage));
            Routing.RegisterRoute(Routes.CompatTrans, typeof(TransmissionSwapPage));
            Routing.RegisterRoute(Routes.CompatNa2t, typeof(NaToTurboPage));
            Routing.RegisterRoute(Routes.SwapChecker, typeof(SwapCheckerPage));
            Routing.RegisterRoute(Routes.EcuHarness, typeof(EcuHarnessHelperPage));
            Routing.RegisterRoute(Routes.SensorDiff, typeof(SensorDiffFinderPage));

            // Vehicle
            Routing.RegisterRoute(Routes.VehiclePicker, typeof(VehiclePickerPage));

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

            // Debug
            Routing.RegisterRoute(Routes.RouteAudit, typeof(RouteAuditPage));
        }
    }
}
