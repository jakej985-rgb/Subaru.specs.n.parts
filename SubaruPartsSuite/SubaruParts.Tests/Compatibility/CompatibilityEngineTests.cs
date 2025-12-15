using System.Collections.Generic;
using SubaruParts.Domain.Compatibility;
using SubaruParts.Domain.Compatibility.Logic;
using Xunit;

namespace SubaruParts.Tests.Compatibility
{
    public class CompatibilityEngineTests
    {
        private List<CompatibilityRule> GetTestRules()
        {
            return new List<CompatibilityRule>
            {
                new CompatibilityRule
                {
                    Id = "test_phase_mismatch",
                    When = new RuleCondition
                    {
                        Donor = new Dictionary<string, object> { { "Phase", "Phase2" } },
                        Target = new Dictionary<string, object> { { "Phase", "Phase1" } }
                    },
                    Effect = new RuleEffect
                    {
                        Level = CompatibilityLevel.MajorMods,
                        ScoreDelta = -50,
                        AddWarning = "Phase mismatch"
                    }
                }
            };
        }

        [Fact]
        public void Evaluate_PhaseMismatch_ReturnsMajorMods()
        {
            var rules = GetTestRules();
            var engine = new CompatibilityEngine(rules);

            var donor = new EngineProfile { Code = "EJ251", Phase = EnginePhase.Phase2 };
            var target = new EngineProfile { Code = "EJ22E", Phase = EnginePhase.Phase1 };

            var result = engine.Evaluate(donor, target);

            Assert.Equal(CompatibilityLevel.MajorMods, result.Level);
            Assert.Equal(50, result.Score); // 100 - 50
            Assert.Contains("Phase mismatch", result.Warnings);
        }

        [Fact]
        public void Evaluate_NoRulesTriggered_ReturnsPlugAndPlay()
        {
            var rules = GetTestRules();
            var engine = new CompatibilityEngine(rules);

            var donor = new EngineProfile { Code = "EJ251", Phase = EnginePhase.Phase2 };
            var target = new EngineProfile { Code = "EJ253", Phase = EnginePhase.Phase2 };

            var result = engine.Evaluate(donor, target);

            Assert.Equal(CompatibilityLevel.PlugAndPlay, result.Level);
            Assert.Equal(100, result.Score);
        }
    }
}
