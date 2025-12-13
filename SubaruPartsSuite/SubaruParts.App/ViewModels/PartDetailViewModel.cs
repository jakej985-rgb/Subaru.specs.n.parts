
using System.Collections.ObjectModel;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using SubaruParts.Domain;
using SubaruParts.Data.Services;
using System.Threading.Tasks;
using Microsoft.Maui.ApplicationModel;

namespace SubaruParts.App.ViewModels
{
    [QueryProperty(nameof(PartId), "PartId")]
    public partial class PartDetailViewModel : ObservableObject
    {
        private readonly CatalogService _catalogService;
        private readonly StoreLinkService _storeLinkService;

        [ObservableProperty]
        private int _partId;

        [ObservableProperty]
        private Part _part;

        [ObservableProperty]
        private ObservableCollection<CrossRef> _crossRefs = new();

        [ObservableProperty]
        private ObservableCollection<Spec> _specs = new();

        [ObservableProperty]
        private ObservableCollection<Supersession> _supersessions = new();

        public PartDetailViewModel(CatalogService catalogService, StoreLinkService storeLinkService)
        {
            _catalogService = catalogService;
            _storeLinkService = storeLinkService;
        }

        partial void OnPartIdChanged(int value)
        {
            Task.Run(LoadDetailAsync);
        }

        private async Task LoadDetailAsync()
        {
            var detail = await _catalogService.GetPartDetailAsync(PartId);
            if (detail == null) return;

            MainThread.BeginInvokeOnMainThread(() =>
            {
                Part = detail.Part;

                CrossRefs.Clear();
                if (detail.CrossRefs != null) foreach(var x in detail.CrossRefs) CrossRefs.Add(x);

                Specs.Clear();
                if (detail.Specs != null) foreach(var s in detail.Specs) Specs.Add(s);

                Supersessions.Clear();
                if (detail.Supersessions != null) foreach(var su in detail.Supersessions) Supersessions.Add(su);
            });
        }

        [RelayCommand]
        private async Task OpenStore(string storeName)
        {
            if (Part == null) return;

            // Simple logic: Use first aftermarket number if available, else OEM
            string query = Part.OemNumber;
            if (CrossRefs.Count > 0)
            {
                query = CrossRefs[0].AftermarketNumber;
            }

            string url = "";
            switch (storeName)
            {
                case "AutoZone": url = _storeLinkService.GetAutoZoneUrl(query); break;
                case "OReilly": url = _storeLinkService.GetOReillyUrl(query); break;
                case "NAPA": url = _storeLinkService.GetNapaUrl(query); break;
            }

            if (!string.IsNullOrEmpty(url))
            {
                await Launcher.Default.OpenAsync(url);
            }
        }
    }
}
