using System.Linq;
using Microsoft.Maui.Controls;
using SubaruParts.App.Navigation;

namespace SubaruParts.App.Pages;

public partial class RouteAuditPage : ContentPage
{
    public RouteAuditPage()
    {
        InitializeComponent();
        PopulateRoutes();
    }

    private void PopulateRoutes()
    {
        // Iterate all nodes from NavGraph
        foreach (var node in NavGraph.Nodes)
        {
            var frame = new Frame { Padding = 10, BorderColor = Colors.LightGray, BackgroundColor = Colors.White };
            var sl = new VerticalStackLayout { Spacing = 5 };

            sl.Children.Add(new Label { Text = node.Title, FontAttributes = FontAttributes.Bold, TextColor = Colors.Black });
            sl.Children.Add(new Label { Text = node.Route, TextColor = Colors.Gray, FontSize = 12 });

            var btn = new Button { Text = "Go", HeightRequest = 40 };
            var route = node.Route;
            var defaults = node.DefaultParams;

            btn.Clicked += async (s, e) =>
            {
                await Nav.Go(route, defaults?.ToDictionary(k => k.Key, v => v.Value));
            };

            sl.Children.Add(btn);

            // List child links if any exist
            if (node.Children != null && node.Children.Count > 0)
            {
                var childLabel = new Label
                {
                    Text = $"  {node.Children.Count} Child Links:",
                    TextColor = Colors.Blue,
                    FontSize = 12,
                    Margin = new Thickness(0, 5, 0, 0)
                };
                sl.Children.Add(childLabel);

                var childSl = new VerticalStackLayout { Padding = new Thickness(20, 0, 0, 0), Spacing = 5 };
                foreach (var child in node.Children)
                {
                    var childBtn = new Button { Text = $"Go: {child.Title}", FontSize = 12, HeightRequest = 35 };
                    var cRoute = child.Route;
                    var cDefaults = child.DefaultParams;
                    childBtn.Clicked += async (s, e) =>
                    {
                        await Nav.Go(cRoute, cDefaults?.ToDictionary(k => k.Key, v => v.Value));
                    };
                    childSl.Children.Add(childBtn);
                }
                sl.Children.Add(childSl);
            }

            frame.Content = sl;
            RoutesList.Children.Add(frame);
        }
    }
}
