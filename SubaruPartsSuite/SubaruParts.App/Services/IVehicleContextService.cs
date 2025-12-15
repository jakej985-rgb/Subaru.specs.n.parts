namespace SubaruParts.App.Services;

public interface IVehicleContextService
{
    string GetActiveVehicleLabel();
    void SetActiveVehicleLabel(string label);
}
