using System.Collections.ObjectModel;
using System.Windows.Input;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using SubaruParts.App.Models;
using SubaruParts.App.Navigation;
using SubaruParts.App.Services;

namespace SubaruParts.App.ViewModels;

public enum HomeSegment { Browse, Parts, Specs, Tools }

public partial class HomeViewModel : ObservableObject
{
    private readonly IVehicleContextService _vehicleContext;

    [ObservableProperty]
    private string _currentVehicleLabel;

    [ObservableProperty]
    private string _segmentTitle;

    [ObservableProperty]
    private ObservableCollection<HomeTile> _segmentTiles;

    [ObservableProperty]
    private bool _isBrowse;

    [ObservableProperty]
    private bool _isParts;

    [ObservableProperty]
    private bool _isSpecs;

    [ObservableProperty]
    private bool _isTools;

    public ICommand SetSegmentCommand { get; }
    public ICommand NavigateTileCommand { get; }
    public ICommand GoVehiclePickerCommand { get; }
    public ICommand NavCommand { get; }

    public HomeViewModel(IVehicleContextService vehicleContext)
    {
        _vehicleContext = vehicleContext;
        _segmentTiles = new ObservableCollection<HomeTile>();

        // Commands
        SetSegmentCommand = new RelayCommand<string>(OnSetSegment);
        NavigateTileCommand = new AsyncRelayCommand<string>(OnNavigateTile);
        GoVehiclePickerCommand = new AsyncRelayCommand(OnGoVehiclePicker);
        NavCommand = new AsyncRelayCommand<string>(OnNav);

        // Init
        _currentVehicleLabel = _vehicleContext.GetActiveVehicleLabel();
        SetSegment(HomeSegment.Browse);
    }

    private void OnSetSegment(string? segmentName)
    {
        if (Enum.TryParse<HomeSegment>(segmentName, true, out var seg))
        {
            SetSegment(seg);
        }
    }

    private void SetSegment(HomeSegment segment)
    {
        // Update booleans for UI triggers
        IsBrowse = segment == HomeSegment.Browse;
        IsParts = segment == HomeSegment.Parts;
        IsSpecs = segment == HomeSegment.Specs;
        IsTools = segment == HomeSegment.Tools;

        // Update Title and Tiles
        SegmentTiles.Clear();

        switch (segment)
        {
            case HomeSegment.Browse:
                SegmentTitle = "Browse Catalog";
                AddTile("Year/Make/Model", "Search by vehicle", "search.png", Routes.BrowseYmm);
                AddTile("By Engine", "Search by engine family", "engine.png", Routes.BrowseEngine);
                break;

            case HomeSegment.Parts:
                SegmentTitle = "Part Lookup";
                AddTile("Part Lookup", "Search by keyword", "part.png", $"//{Routes.PartLookup}");
                AddTile("Cross Reference", "Find interchange", "swap.png", Routes.PartsXref);
                AddTile("OEM Number", "Lookup by OEM #", "oem.png", Routes.PartsOem);
                break;

            case HomeSegment.Specs:
                SegmentTitle = "Specs Library";
                AddTile("Specs Library", "Full library", "library.png", $"//{Routes.SpecsLibrary}");
                AddTile("Fluids", "Oil, coolant, etc.", "drop.png", $"{Routes.SpecsCategory}?{RouteKeys.Category}=fluids");
                AddTile("Torque", "Torque specs", "wrench.png", $"{Routes.SpecsCategory}?{RouteKeys.Category}=torque");
                AddTile("Filters", "Filter lookup", "filter.png", $"{Routes.SpecsCategory}?{RouteKeys.Category}=filters");
                break;

            case HomeSegment.Tools:
                SegmentTitle = "Compatibility Tools";
                AddTile("Compat Tools", "All tools", "tools.png", $"//{Routes.CompatTools}");
                AddTile("ECU / Harness", "Wiring helpers", "ecu.png", Routes.EcuHarness);
                AddTile("Transmission", "Swap helper", "gear.png", $"{Routes.CompatTools}?tool=trans");
                AddTile("NA to Turbo", "Conversion guide", "turbo.png", $"{Routes.CompatTools}?tool=na2t");
                break;
        }
    }

    private void AddTile(string title, string subtitle, string icon, string route)
    {
        SegmentTiles.Add(new HomeTile
        {
            Title = title,
            Subtitle = subtitle,
            Icon = icon,
            Route = route
        });
    }

    private async Task OnNavigateTile(string? route)
    {
        if (!string.IsNullOrWhiteSpace(route))
        {
            await Shell.Current.GoToAsync(route);
        }
    }

    private async Task OnNav(string? route)
    {
         if (!string.IsNullOrWhiteSpace(route))
        {
            await Shell.Current.GoToAsync(route);
        }
    }

    private async Task OnGoVehiclePicker()
    {
        await Shell.Current.GoToAsync(Routes.VehiclePicker);
    }

    // Refresh vehicle label when returning to view
    public void RefreshVehicleLabel()
    {
        CurrentVehicleLabel = _vehicleContext.GetActiveVehicleLabel();
    }
}
