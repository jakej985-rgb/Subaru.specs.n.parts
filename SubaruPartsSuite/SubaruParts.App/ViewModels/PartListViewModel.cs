
using System.Collections.ObjectModel;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using SubaruParts.Domain;
using SubaruParts.Data.Services;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;

namespace SubaruParts.App.ViewModels
{
    [QueryProperty(nameof(Engine), "Engine")]
    public partial class PartListViewModel : ObservableObject
    {
        private readonly CatalogService _catalogService;

        [ObservableProperty]
        private Engine _engine;

        [ObservableProperty]
        private string _searchQuery;

        [ObservableProperty]
        private string _selectedCategory = "All";

        [ObservableProperty]
        private ObservableCollection<string> _categories = new();

        [ObservableProperty]
        private ObservableCollection<Part> _parts = new();

        public PartListViewModel(CatalogService catalogService)
        {
            _catalogService = catalogService;
        }

        partial void OnEngineChanged(Engine value)
        {
            if (value != null)
            {
                // Trigger load
                Task.Run(LoadDataAsync);
            }
        }

        private async Task LoadDataAsync()
        {
            if (Engine == null) return;

            var cats = await _catalogService.GetCategoriesForEngineAsync(Engine.Id);

            MainThread.BeginInvokeOnMainThread(() =>
            {
                Categories.Clear();
                Categories.Add("All");
                foreach(var c in cats) Categories.Add(c);
            });

            await PerformSearch();
        }

        [RelayCommand]
        private async Task PerformSearch()
        {
            if (Engine == null) return;

            var results = await _catalogService.SearchPartsAsync(Engine.Id, SearchQuery, SelectedCategory);

            MainThread.BeginInvokeOnMainThread(() =>
            {
                Parts.Clear();
                foreach(var p in results) Parts.Add(p);
            });
        }

        [RelayCommand]
        private async Task PartSelected(Part part)
        {
             if (part == null) return;

             var navigationParameter = new Dictionary<string, object>
             {
                 { "PartId", part.Id }
             };

             await Shell.Current.GoToAsync("partdetail", navigationParameter);
        }
    }
}
