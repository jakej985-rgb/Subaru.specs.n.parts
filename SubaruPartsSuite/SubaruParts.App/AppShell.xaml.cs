
using Microsoft.Maui.Controls;
using SubaruParts.App.Pages;

namespace SubaruParts.App
{
    public partial class AppShell : Shell
    {
        public AppShell()
        {
            InitializeComponent();

            Routing.RegisterRoute("partlist", typeof(PartListPage));
            Routing.RegisterRoute("partdetail", typeof(PartDetailPage));
        }
    }
}
