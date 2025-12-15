using System;
using System.Collections.Generic;
using System.Linq;

namespace SubaruParts.Domain.Compatibility.Logic
{
    public class RuleEvaluator
    {
        public void Evaluate(CompatibilityRule rule, EngineProfile donor, EngineProfile target, CompatibilityResult result)
        {
            if (Matches(rule.When, donor, target))
            {
                ApplyEffect(rule.Effect, result);
            }
        }

        private bool Matches(RuleCondition condition, EngineProfile donor, EngineProfile target)
        {
            if (condition == null) return false;

            if (condition.Donor != null)
            {
                if (!MatchesProfile(condition.Donor, donor)) return false;
            }

            if (condition.Target != null)
            {
                if (!MatchesProfile(condition.Target, target)) return false;
            }

            return true;
        }

        private bool MatchesProfile(Dictionary<string, object> criteria, EngineProfile profile)
        {
            // Simple reflection-based matching or property dictionary
            // For robustness, we'll map property names manually or use reflection.
            // Reflection is flexible for JSON rules.

            foreach (var kvp in criteria)
            {
                var propName = kvp.Key;
                var expectedValue = kvp.Value?.ToString();

                var prop = typeof(EngineProfile).GetProperty(propName, System.Reflection.BindingFlags.IgnoreCase | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance);
                if (prop == null) continue; // Property not found, ignore or fail? Ignore for now.

                var actualValue = prop.GetValue(profile)?.ToString();

                // Basic equality check
                if (!string.Equals(actualValue, expectedValue, StringComparison.OrdinalIgnoreCase))
                {
                    // Check for "includes" if it's a flag? Not implemented yet.
                    // Check for "!=" logic?
                    // For now, strict equality of string representation.
                    return false;
                }
            }
            return true;
        }

        private void ApplyEffect(RuleEffect effect, CompatibilityResult result)
        {
            if (effect == null) return;

            result.Score += effect.ScoreDelta;

            if (!string.IsNullOrEmpty(effect.AddWarning))
            {
                result.Warnings.Add(effect.AddWarning);
            }

            if (effect.AddChange != null)
            {
                result.RequiredChanges.Add(effect.AddChange);
            }

            if (effect.Level.HasValue)
            {
                // Logic: "max severity wins".
                // We need to define an ordering.
                // PlugAndPlay < MinorMods < MajorMods < NotRecommended

                if (result.Level < effect.Level.Value)
                {
                    result.Level = effect.Level.Value;
                }
            }
        }
    }
}
