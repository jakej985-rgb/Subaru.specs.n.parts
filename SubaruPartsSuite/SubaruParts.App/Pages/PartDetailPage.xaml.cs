
using Microsoft.Maui.Controls;
using SubaruParts.App.ViewModels;

namespace SubaruParts.App.Pages
{
    public partial class PartDetailPage : ContentPage
    {
        private readonly PartDetailViewModel _viewModel;

        public PartDetailPage(PartDetailViewModel viewModel)
        {
            InitializeComponent();
            BindingContext = _viewModel = viewModel;
        }
    }
}
