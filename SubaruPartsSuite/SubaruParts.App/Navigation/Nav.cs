using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Maui.Controls;

namespace SubaruParts.App.Navigation;

public static class Nav
{
    public static Task Go(string route, IDictionary<string, object>? p = null)
        => Shell.Current.GoToAsync(route, p ?? new Dictionary<string, object>());

    public static Task GoWithQuery(string routeWithQuery)
        => Shell.Current.GoToAsync(routeWithQuery);
}
