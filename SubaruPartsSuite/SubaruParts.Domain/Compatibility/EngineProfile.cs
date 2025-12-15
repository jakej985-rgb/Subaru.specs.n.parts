using System.Collections.Generic;

namespace SubaruParts.Domain.Compatibility
{
    public class EngineProfile
    {
        public string Code { get; set; } // e.g., "EJ251"
        public EnginePhase Phase { get; set; }
        public string YearRange { get; set; } // e.g. "1999-2004"
        public ThrottleType Throttle { get; set; }
        public AirMetering AirMetering { get; set; }
        public ValveControl ValveControl { get; set; }
        public EcuBus EcuBus { get; set; }
        public string Notes { get; set; }
    }
}
