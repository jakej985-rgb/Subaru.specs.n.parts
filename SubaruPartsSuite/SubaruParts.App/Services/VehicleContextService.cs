using Microsoft.Maui.Storage;

namespace SubaruParts.App.Services;

public class VehicleContextService : IVehicleContextService
{
    private const string ActiveVehicleLabelKey = "active_vehicle_label";
    private const string DefaultVehicleLabel = "No vehicle selected";

    public string GetActiveVehicleLabel()
    {
        return Preferences.Get(ActiveVehicleLabelKey, DefaultVehicleLabel);
    }

    public void SetActiveVehicleLabel(string label)
    {
        Preferences.Set(ActiveVehicleLabelKey, label);
    }
}
