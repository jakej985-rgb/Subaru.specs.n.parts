
using System.Collections.ObjectModel;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using SubaruParts.Domain;
using SubaruParts.Data.Services;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace SubaruParts.App.ViewModels
{
    public partial class EnginePickerViewModel : ObservableObject
    {
        private readonly CatalogService _catalogService;

        [ObservableProperty]
        private ObservableCollection<Engine> _engines = new();

        [ObservableProperty]
        private Engine _selectedEngine;

        public EnginePickerViewModel(CatalogService catalogService)
        {
            _catalogService = catalogService;
        }

        public async Task LoadEnginesAsync()
        {
            var engines = await _catalogService.GetEnginesAsync();
            Engines.Clear();
            foreach (var e in engines)
            {
                Engines.Add(e);
            }
        }

        [RelayCommand]
        private async Task EngineSelected(Engine engine)
        {
            if (engine == null) return;

            var navigationParameter = new Dictionary<string, object>
            {
                { "Engine", engine }
            };

            // Note: Route name will be defined in AppShell
            await Shell.Current.GoToAsync("partlist", navigationParameter);
        }
    }
}
