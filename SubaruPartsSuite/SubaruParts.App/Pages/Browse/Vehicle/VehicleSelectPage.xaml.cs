using System.Collections.Generic;
using Microsoft.Maui.Controls;
using SubaruParts.Navigation;

namespace SubaruParts.App.Pages.Browse.Vehicle;

public partial class VehicleSelectPage : ContentPage
{
    public VehicleSelectPage()
    {
        InitializeComponent();
    }

    private async void OnGoClicked(object sender, System.EventArgs e)
    {
        var year = YearPicker.SelectedItem?.ToString() ?? "2005";
        var make = MakePicker.SelectedItem?.ToString() ?? "Subaru";
        var model = ModelPicker.SelectedItem?.ToString() ?? "Impreza";
        var trim = TrimPicker.SelectedItem?.ToString() ?? "2.5RS";
        var engine = EnginePicker.SelectedItem?.ToString() ?? "EJ251";
        var trans = TransPicker.SelectedItem?.ToString() ?? "5MT";

        await Nav.Go(Routes.VehiclePage, new Dictionary<string, object>
        {
            [RouteKeys.Year] = year,
            [RouteKeys.Make] = make,
            [RouteKeys.Model] = model,
            [RouteKeys.Trim] = trim,
            [RouteKeys.EngineCode] = engine,
            [RouteKeys.Trans] = trans,
            [RouteKeys.Tab] = "specs"
        });
    }
}
