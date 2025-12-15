using System.Collections.Generic;
using System.Linq;

namespace SubaruParts.Domain.Compatibility.Logic
{
    public class CompatibilityEngine
    {
        private readonly RuleEvaluator _evaluator;
        private readonly CompatibilityExplainer _explainer;
        private readonly List<CompatibilityRule> _rules;

        public CompatibilityEngine(List<CompatibilityRule> rules)
        {
            _rules = rules;
            _evaluator = new RuleEvaluator();
            _explainer = new CompatibilityExplainer();
        }

        public CompatibilityResult Evaluate(EngineProfile donor, EngineProfile target)
        {
            var result = new CompatibilityResult
            {
                Score = 100,
                Level = CompatibilityLevel.PlugAndPlay
            };

            // 1. Run rules
            foreach (var rule in _rules)
            {
                _evaluator.Evaluate(rule, donor, target, result);
            }

            // 2. Cap score
            if (result.Score < 0) result.Score = 0;
            if (result.Score > 100) result.Score = 100;

            // 3. Generate explanation
            result.Explanation = _explainer.Explain(donor, target, result);

            return result;
        }

        // Overload for VehicleProfile as target
        public CompatibilityResult Evaluate(EngineProfile donor, VehicleProfile targetVehicle)
        {
            // Convert VehicleProfile to a "Target Engine Profile" representation
            // This is a simplification. Ideally we'd have rules against VehicleProfile directly,
            // or infer the "original engine" of the vehicle.

            var targetEngine = new EngineProfile
            {
                Phase = targetVehicle.ChassisPhase,
                EcuBus = targetVehicle.ExpectedBus,
                // Defaults/Unknowns for others if not specified in vehicle
                Throttle = ThrottleType.Unknown,
                ValveControl = ValveControl.Unknown,
                AirMetering = AirMetering.Unknown,
                Code = $"Chassis {targetVehicle.Model} {targetVehicle.Year}"
            };

            // If we had a database of "Vehicle -> Original Engine", we would look that up here.
            // For now, we rely on the VehicleProfile having been enriched with ChassisPhase/Bus.

            return Evaluate(donor, targetEngine);
        }
    }
}
