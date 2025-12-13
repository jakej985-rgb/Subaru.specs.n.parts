
using Microsoft.Maui.Controls;
using SubaruParts.App.ViewModels;

namespace SubaruParts.App.Pages
{
    public partial class EnginePickerPage : ContentPage
    {
        private readonly EnginePickerViewModel _viewModel;

        public EnginePickerPage(EnginePickerViewModel viewModel)
        {
            InitializeComponent();
            BindingContext = _viewModel = viewModel;
        }

        protected override async void OnAppearing()
        {
            base.OnAppearing();
            await _viewModel.LoadEnginesAsync();
        }
    }
}
