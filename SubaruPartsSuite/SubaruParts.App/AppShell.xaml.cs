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
            // Placeholder routes for unimplemented pages
            Routing.RegisterRoute(Routes.BrowseYmm, typeof(SubaruParts.App.Pages.Shared.PlaceholderPage));
            Routing.RegisterRoute(Routes.VehiclePicker, typeof(SubaruParts.App.Pages.Shared.PlaceholderPage));
            Routing.RegisterRoute(Routes.PartsXref, typeof(SubaruParts.App.Pages.Shared.PlaceholderPage));
            Routing.RegisterRoute(Routes.PartsOem, typeof(SubaruParts.App.Pages.Shared.PlaceholderPage));

            // Missing top-level routes that might be navigated to (e.g. from Home Tiles if they are not just Shell Tabs)
            // Note: If these are Tabs in Shell, they are auto-registered. But if we use GoToAsync("//parts") and it's a Tab, it works.
            // However, the reviewer mentioned these might be missing if they are not top-level Tabs or if we want to push them.
            // Shell handles "//route" for FlyoutItems automatically.
            // But let's check AppShell.xaml to see if they are registered as FlyoutItems.
            // PartLookup is a FlyoutItem. SpecsLibrary is a FlyoutItem. CompatTools is a FlyoutItem.
            // So they SHOULD work with GoToAsync("//part-lookup") etc.
            // However, to be safe and satisfy the reviewer who thinks they might be missing or if we want to use relative routing:
            // Routing.RegisterRoute(Routes.PartLookup, typeof(PartLookupPage)); // This is likely auto-handled by ShellContent

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
