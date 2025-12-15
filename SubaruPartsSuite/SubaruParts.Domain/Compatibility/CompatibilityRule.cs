using System.Collections.Generic;

namespace SubaruParts.Domain.Compatibility
{
    public class CompatibilityRule
    {
        public string Id { get; set; }
        public RuleCondition When { get; set; }
        public RuleEffect Effect { get; set; }
    }

    public class RuleCondition
    {
        // Simple property matching for now.
        // In a real system this might be more dynamic, but we can deserialize structured JSON.
        // We will match properties of Donor (EngineProfile) and Target (EngineProfile/VehicleProfile)

        // These dictionaries map property names to expected values or conditions.
        // E.g. "ecuBus": "CanBus"
        public Dictionary<string, object> Donor { get; set; }
        public Dictionary<string, object> Target { get; set; }
    }

    public class RuleEffect
    {
        public CompatibilityLevel? Level { get; set; } // If set, forces this level (or caps it)
        public int ScoreDelta { get; set; }
        public string AddWarning { get; set; }
        public ChangeItem AddChange { get; set; }
    }
}
