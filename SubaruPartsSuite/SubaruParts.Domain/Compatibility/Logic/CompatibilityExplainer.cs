using System.Collections.Generic;
using System.Text;

namespace SubaruParts.Domain.Compatibility.Logic
{
    public class CompatibilityExplainer
    {
        public string Explain(EngineProfile donor, EngineProfile target, CompatibilityResult result)
        {
            var sb = new StringBuilder();
            sb.AppendLine($"Evaluating swap: {donor.Code} ({donor.Phase}) -> Target mimicking {target.Code} ({target.Phase}).");
            sb.AppendLine();

            sb.AppendLine($"Compatibility Level: {result.Level}");
            sb.AppendLine($"Score: {result.Score}/100");

            if (result.RequiredChanges.Count > 0)
            {
                sb.AppendLine("\nRequired Changes:");
                foreach (var change in result.RequiredChanges)
                {
                    sb.AppendLine($"- [{change.Severity}] {change.Title}: {change.Details}");
                }
            }

            if (result.Warnings.Count > 0)
            {
                sb.AppendLine("\nWarnings:");
                foreach (var warn in result.Warnings)
                {
                    sb.AppendLine($"- {warn}");
                }
            }

            if (!string.IsNullOrEmpty(result.RecommendedApproach))
            {
                sb.AppendLine($"\nRecommended Approach: {result.RecommendedApproach}");
            }

            return sb.ToString();
        }
    }
}
