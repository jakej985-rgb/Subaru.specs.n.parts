using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Maui.Controls;
using SubaruParts.Navigation;
using SubaruParts.App.Navigation;

namespace SubaruParts.App.Pages.Shared;

public partial class PlaceholderPage : ContentPage, IQueryAttributable
{
    private string _currentRoute;
    public string PageTitle { get; private set; }
    public string CurrentRoute => _currentRoute;
    public string Breadcrumb { get; private set; }
    public string QueryParamsDisplay { get; private set; }
    public List<NavLink> ChildLinks { get; private set; } = new();

    public PlaceholderPage()
    {
        InitializeComponent();
        BindingContext = this;
    }

    protected override void OnAppearing()
    {
        base.OnAppearing();

        // Get current route from Shell state
        var location = Shell.Current.CurrentState.Location;
        _currentRoute = location.ToString();

        // Find matching node
        // The location from Shell is a full URI (e.g., //home/browse), we need to match it to our routes.
        // However, our Routes constants are relative segments or full paths depending on registration.
        // For simplicity in this placeholder, we try to match the last segment or use the full string.

        // Better approach: use the registered route name if possible, but Shell gives paths.
        // We will do a best effort to find the node in NavGraph.

        // Let's try to match by suffix
        var node = NavGraph.Nodes.FirstOrDefault(n => _currentRoute.EndsWith(n.Route) || n.Route == _currentRoute.Trim('/'));

        if (node != null)
        {
            PageTitle = node.Title;
            ChildLinks = node.Children.ToList();
            Breadcrumb = _currentRoute; // Simple breadcrumb for now
        }
        else
        {
            PageTitle = "Unknown Page";
            Breadcrumb = _currentRoute;
        }

        OnPropertyChanged(nameof(PageTitle));
        OnPropertyChanged(nameof(CurrentRoute));
        OnPropertyChanged(nameof(Breadcrumb));
        OnPropertyChanged(nameof(ChildLinks));
        OnPropertyChanged(nameof(QueryParamsDisplay));
    }

    public void ApplyQueryAttributes(IDictionary<string, object> query)
    {
        var sb = new StringBuilder();
        foreach (var kvp in query)
        {
            sb.AppendLine($"{kvp.Key} = {kvp.Value}");
        }
        QueryParamsDisplay = sb.ToString();
        OnPropertyChanged(nameof(QueryParamsDisplay));
    }

    private async void OnChildLinkClicked(object sender, System.EventArgs e)
    {
        if (sender is Button btn && btn.BindingContext is NavLink link)
        {
            await Nav.Go(link.Route, link.DefaultParams?.ToDictionary(k => k.Key, v => v.Value));
        }
    }
}
