using System.Collections.Generic;

namespace SubaruParts.Domain.Compatibility
{
    public class ChangeItem
    {
        public string Title { get; set; }
        public string Details { get; set; }
        public Severity Severity { get; set; }
    }

    public class CompatibilityResult
    {
        public int Score { get; set; }
        public CompatibilityLevel Level { get; set; }
        public List<ChangeItem> RequiredChanges { get; set; } = new List<ChangeItem>();
        public List<string> Warnings { get; set; } = new List<string>();
        public string RecommendedApproach { get; set; }
        public string Explanation { get; set; }
    }
}
