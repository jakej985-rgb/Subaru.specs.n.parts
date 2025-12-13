
namespace SubaruParts.Domain
{
    public class Spec
    {
        public int Id { get; set; }
        public string ScopeType { get; set; } // "Engine" or "Part"
        public int ScopeId { get; set; }
        public string Key { get; set; } // e.g., "Torque", "Gap"
        public string Value { get; set; }
        public string Unit { get; set; }
        public string Notes { get; set; }
    }
}
