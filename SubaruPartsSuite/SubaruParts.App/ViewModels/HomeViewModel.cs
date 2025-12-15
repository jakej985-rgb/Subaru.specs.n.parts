using System.Collections.ObjectModel;
using System.Windows.Input;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using SubaruParts.Navigation;
using SubaruParts.Navigation.Models;
using SubaruParts.App.Services;

namespace SubaruParts.App.ViewModels;

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
        SegmentTitle = HomeMenuRegistry.GetSegmentTitle(segment);
        SegmentTiles.Clear();

        var tiles = HomeMenuRegistry.GetTiles(segment);
        foreach (var tile in tiles)
        {
            SegmentTiles.Add(tile);
        }
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
        await Shell.Current.GoToAsync(AppRoutes.VehiclePicker);
    }

    // Refresh vehicle label when returning to view
    public void RefreshVehicleLabel()
    {
        CurrentVehicleLabel = _vehicleContext.GetActiveVehicleLabel();
    }
}
