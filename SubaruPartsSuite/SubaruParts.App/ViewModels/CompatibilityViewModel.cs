using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using System.Windows.Input;
using SubaruParts.Data.Services;
using SubaruParts.Domain.Compatibility;
using SubaruParts.Domain.Compatibility.Logic;
using Microsoft.Maui.Controls;

namespace SubaruParts.App.ViewModels
{
    public class CompatibilityViewModel : INotifyPropertyChanged
    {
        private readonly CompatibilityService _service;
        private CompatibilityEngine _engine;

        private EngineProfile _selectedDonor;
        private EngineProfile _selectedTarget; // For v1, using engine-to-engine
        private CompatibilityResult _result;

        public ObservableCollection<EngineProfile> Engines { get; } = new ObservableCollection<EngineProfile>();

        public EngineProfile SelectedDonor
        {
            get => _selectedDonor;
            set
            {
                if (_selectedDonor != value)
                {
                    _selectedDonor = value;
                    OnPropertyChanged();
                    // Clear result when selection changes
                    Result = null;
                }
            }
        }

        public EngineProfile SelectedTarget
        {
            get => _selectedTarget;
            set
            {
                if (_selectedTarget != value)
                {
                    _selectedTarget = value;
                    OnPropertyChanged();
                    Result = null;
                }
            }
        }

        public CompatibilityResult Result
        {
            get => _result;
            set
            {
                _result = value;
                OnPropertyChanged();
                OnPropertyChanged(nameof(IsResultVisible));
                OnPropertyChanged(nameof(ResultColor));
            }
        }

        public bool IsResultVisible => Result != null;

        public Color ResultColor
        {
            get
            {
                if (Result == null) return Colors.Transparent;
                return Result.Level switch
                {
                    CompatibilityLevel.PlugAndPlay => Colors.Green,
                    CompatibilityLevel.MinorMods => Colors.YellowGreen,
                    CompatibilityLevel.MajorMods => Colors.Orange,
                    CompatibilityLevel.NotRecommended => Colors.Red,
                    _ => Colors.Gray
                };
            }
        }

        public ICommand CheckCompatibilityCommand { get; }

        public CompatibilityViewModel(CompatibilityService service)
        {
            _service = service;
            CheckCompatibilityCommand = new Command(async () => await CheckCompatibility());

            // Load data
            Task.Run(LoadData);
        }

        private async Task LoadData()
        {
            var engines = await _service.GetEnginesAsync();
            var rules = await _service.GetRulesAsync();

            // Ensure we don't crash if service returns null (though we fixed service to return empty lists)
            if (engines == null) engines = new System.Collections.Generic.List<EngineProfile>();
            if (rules == null) rules = new System.Collections.Generic.List<CompatibilityRule>();

            _engine = new CompatibilityEngine(rules);

            MainThread.BeginInvokeOnMainThread(() =>
            {
                Engines.Clear();
                foreach (var e in engines)
                {
                    Engines.Add(e);
                }
            });
        }

        private async Task CheckCompatibility()
        {
            if (SelectedDonor == null || SelectedTarget == null)
            {
                // Show alert?
                return;
            }

            if (_engine == null) return;

            // Offload logic if heavy? It's fast enough.
            var res = _engine.Evaluate(SelectedDonor, SelectedTarget);

            MainThread.BeginInvokeOnMainThread(() =>
            {
                Result = res;
            });
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
