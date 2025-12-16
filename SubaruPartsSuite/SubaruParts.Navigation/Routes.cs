namespace SubaruParts.Navigation;

public static class Routes
{
    // Top level
    public const string Home = "home";
    public const string Browse = "browse";
    public const string PartLookup = "part-lookup";
    public const string SpecsLibrary = "specs-library";
    public const string CompatTools = "compat-tools";
    public const string MyStuff = "my-stuff";
    public const string Contribute = "contribute";
    public const string Settings = "settings";

    // Browse / Vehicle
    public const string BrowseVehicle = "browse/vehicle";
    public const string BrowseVehicleSelect = "browse/vehicle/select";
    public const string VehiclePage = "browse/vehicle/page";
    public const string BrowseYmm = "browse/ymm";
    public const string VehiclePicker = "vehicle/picker";

    // Browse / Engine
    public const string BrowseEngine = "browse/engine";
    public const string BrowseEngineSelect = "browse/engine/select";
    public const string EnginePage = "browse/engine/page";

    // Parts
    public const string Parts = "parts";
    public const string PartsXref = "parts/xref";
    public const string PartsOem = "parts/oem";

    // Specs
    public const string Specs = "specs";
    public const string SpecsFluids = "specs/fluids";
    public const string SpecsTorque = "specs/torque";
    public const string SpecsFilters = "specs/filters";

    // Tools
    public const string Compat = "compat";
    public const string CompatEcu = "compat/ecu";
    public const string CompatTrans = "compat/trans";
    public const string CompatNa2t = "compat/na2t";

    // Part lookup (Legacy/Existing)
    public const string PartPage = "part-lookup/part";

    // Specs library (Legacy/Existing)
    public const string SpecsCategory = "specs-library/category"; // uses ?category=

    // Compatibility tools (Legacy/Existing)
    public const string SwapChecker = "compat-tools/swap-checker";
    public const string EcuHarness = "compat-tools/ecu-harness";
    public const string SensorDiff = "compat-tools/sensor-diff";

    // My stuff
    public const string Favorites = "my-stuff/favorites";
    public const string Recents = "my-stuff/recents";
    public const string SavedBuilds = "my-stuff/saved-builds";
    public const string OfflinePacks = "my-stuff/offline-packs";

    // Contribute
    public const string SubmitCorrection = "contribute/submit-correction";
    public const string AddCrossRef = "contribute/add-crossref";
    public const string AddNote = "contribute/add-note";
    public const string AddSource = "contribute/add-source";

    // Settings
    public const string Units = "settings/units";
    public const string DefaultFilters = "settings/default-filters";
    public const string OfflineCache = "settings/offline-cache";
    public const string Sources = "settings/sources";
    public const string AppInfo = "settings/app-info";

    // Audit
    public const string RouteAudit = "debug/route-audit";
}
