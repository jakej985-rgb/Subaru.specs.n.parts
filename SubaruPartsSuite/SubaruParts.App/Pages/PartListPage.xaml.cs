
using System;
using Microsoft.Maui.Controls;
using SubaruParts.App.ViewModels;

namespace SubaruParts.App.Pages
{
    public partial class PartListPage : ContentPage
    {
        private readonly PartListViewModel _viewModel;

        public PartListPage(PartListViewModel viewModel)
        {
            InitializeComponent();
            BindingContext = _viewModel = viewModel;
        }

        private void OnCategoryClicked(object sender, EventArgs e)
        {
            if (sender is Button btn && btn.Text != null)
            {
                _viewModel.SelectedCategory = btn.Text;
                // Command is already bound to PerformSearch, but we update property first
            }
        }
    }
}
