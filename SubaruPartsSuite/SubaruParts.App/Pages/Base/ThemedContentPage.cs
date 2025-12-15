using Microsoft.Maui.Controls;

namespace SubaruParts.App.Pages.Base;

public class ThemedContentPage : ContentPage
{
    public ThemedContentPage()
    {
        SetDynamicResource(BackgroundColorProperty, "OemBg");
    }
}
