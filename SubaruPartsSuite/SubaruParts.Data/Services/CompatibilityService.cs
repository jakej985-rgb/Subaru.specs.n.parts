using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using SubaruParts.Domain.Compatibility;

namespace SubaruParts.Data.Services
{
    public class CompatibilityService
    {
        private List<EngineProfile> _engines = new List<EngineProfile>();
        private List<CompatibilityRule> _rules = new List<CompatibilityRule>();
        private bool _initialized = false;

        public async Task InitializeAsync()
        {
            if (_initialized) return;

            var engines = await LoadDataAsync<List<EngineProfile>>("engines.json");
            if (engines != null) _engines = engines;

            var rules = await LoadDataAsync<List<CompatibilityRule>>("rules.json");
            if (rules != null) _rules = rules;

            _initialized = true;
        }

        public async Task<List<EngineProfile>> GetEnginesAsync()
        {
            await InitializeAsync();
            return _engines;
        }

        public async Task<List<CompatibilityRule>> GetRulesAsync()
        {
            await InitializeAsync();
            return _rules;
        }

        private async Task<T> LoadDataAsync<T>(string fileName)
        {
            // Try to find the resource in the assembly
            var assembly = typeof(CompatibilityService).Assembly;
            var resourceName = assembly.GetManifestResourceNames()
                .FirstOrDefault(n => n.EndsWith(fileName));

            if (resourceName != null)
            {
                using var stream = assembly.GetManifestResourceStream(resourceName);
                if (stream != null)
                {
                    var options = new JsonSerializerOptions
                    {
                        PropertyNameCaseInsensitive = true,
                        ReadCommentHandling = JsonCommentHandling.Skip
                    };
                    options.Converters.Add(new JsonStringEnumConverter());

                    return await JsonSerializer.DeserializeAsync<T>(stream, options);
                }
            }

            return default;
        }
    }
}
