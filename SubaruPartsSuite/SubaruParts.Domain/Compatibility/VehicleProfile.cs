namespace SubaruParts.Domain.Compatibility
{
    public class VehicleProfile
    {
        public string Model { get; set; } // Impreza, Forester, etc.
        public int Year { get; set; }
        public string Region { get; set; } // US, JDM, EU
        public bool HasImmobilizer { get; set; }

        // Derived properties that act as a "target engine profile" context
        public EnginePhase ChassisPhase { get; set; }
        public EcuBus ExpectedBus { get; set; }
    }
}
