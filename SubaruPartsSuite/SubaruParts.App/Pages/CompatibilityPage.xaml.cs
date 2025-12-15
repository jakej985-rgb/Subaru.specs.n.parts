using SubaruParts.App.ViewModels;

namespace SubaruParts.App.Pages
{
    public partial class CompatibilityPage : ContentPage
    {
        public CompatibilityPage(CompatibilityViewModel viewModel)
        {
            InitializeComponent();
            BindingContext = viewModel;
        }
    }
}
