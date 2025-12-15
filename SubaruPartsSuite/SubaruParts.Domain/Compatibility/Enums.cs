namespace SubaruParts.Domain.Compatibility
{
    public enum EnginePhase
    {
        Unknown,
        Phase1,
        Phase2,
        FB,
        FA
    }

    public enum ThrottleType
    {
        Unknown,
        Cable,
        DBW // Drive By Wire
    }

    public enum AirMetering
    {
        Unknown,
        MAF, // Mass Air Flow
        MAP, // Manifold Absolute Pressure
        SpeedDensity
    }

    public enum ValveControl
    {
        Unknown,
        None,
        AVCS, // Active Valve Control System
        AVLS, // Active Valve Lift System
        DualAVCS
    }

    public enum EcuBus
    {
        NonCan,
        CanBus
    }

    public enum CompatibilityLevel
    {
        PlugAndPlay,
        MinorMods,
        MajorMods,
        NotRecommended
    }

    public enum Severity
    {
        Info,
        Low,
        Medium,
        High,
        Critical
    }
}
