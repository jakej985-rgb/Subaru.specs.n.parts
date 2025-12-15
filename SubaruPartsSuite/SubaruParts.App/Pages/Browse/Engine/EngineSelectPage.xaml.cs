using System.Collections.Generic;
using Microsoft.Maui.Controls;
using SubaruParts.Navigation;
using SubaruParts.App.Navigation;

namespace SubaruParts.App.Pages.Browse.Engine;

public partial class EngineSelectPage : ContentPage
{
    public EngineSelectPage()
    {
        InitializeComponent();
    }

    private async void OnGoClicked(object sender, System.EventArgs e)
    {
        var family = FamilyPicker.SelectedItem?.ToString() ?? "EJ";
        var phase = PhasePicker.SelectedItem?.ToString() ?? "2";
        var code = EngineCodePicker.SelectedItem?.ToString() ?? "EJ251";

        await Nav.Go(Routes.EnginePage, new Dictionary<string, object>
        {
            [RouteKeys.EngineFamily] = family,
            [RouteKeys.Phase] = phase,
            [RouteKeys.EngineCode] = code,
            [RouteKeys.Tab] = "specs"
        });
    }
}
