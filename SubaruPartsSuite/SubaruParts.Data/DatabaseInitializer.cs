
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;
using SubaruParts.Domain;

namespace SubaruParts.Data
{
    public class DatabaseInitializer
    {
        private readonly SubaruPartsDbContext _context;

        public DatabaseInitializer(SubaruPartsDbContext context)
        {
            _context = context;
        }

        public async Task InitializeAsync(Stream seedDataStream)
        {
            var db = await _context.GetConnectionAsync();

            // Check if data exists
            if (await db.Table<Engine>().CountAsync() > 0)
            {
                return;
            }

            if (seedDataStream == null)
            {
                throw new ArgumentNullException(nameof(seedDataStream));
            }

            using var reader = new StreamReader(seedDataStream);
            var json = await reader.ReadToEndAsync();
            var seedData = JsonSerializer.Deserialize<SeedDataRoot>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

            if (seedData != null)
            {
                // Bulk insert is faster
                if (seedData.Engines != null) await db.InsertAllAsync(seedData.Engines);
                if (seedData.Parts != null) await db.InsertAllAsync(seedData.Parts);
                if (seedData.CrossRefs != null) await db.InsertAllAsync(seedData.CrossRefs);
                if (seedData.Specs != null) await db.InsertAllAsync(seedData.Specs);
                if (seedData.Supersessions != null) await db.InsertAllAsync(seedData.Supersessions);
                if (seedData.Fitments != null) await db.InsertAllAsync(seedData.Fitments);
            }
        }

        private class SeedDataRoot
        {
            public List<Engine> Engines { get; set; }
            public List<Part> Parts { get; set; }
            public List<CrossRef> CrossRefs { get; set; }
            public List<Spec> Specs { get; set; }
            public List<Supersession> Supersessions { get; set; }
            public List<Fitment> Fitments { get; set; }
        }
    }
}
