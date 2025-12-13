
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SubaruParts.Domain;

namespace SubaruParts.Data.Services
{
    public class CatalogService
    {
        private readonly SubaruPartsDbContext _context;

        public CatalogService(SubaruPartsDbContext context)
        {
            _context = context;
        }

        public async Task<List<Engine>> GetEnginesAsync()
        {
            var db = await _context.GetConnectionAsync();
            return await db.Table<Engine>().ToListAsync();
        }

        public async Task<List<string>> GetCategoriesForEngineAsync(int engineId)
        {
            var db = await _context.GetConnectionAsync();

            // Query parts associated with this engine via fitment
            var parts = await db.QueryAsync<Part>(
                "SELECT p.* FROM Part p " +
                "INNER JOIN Fitment f ON f.PartId = p.Id " +
                "WHERE f.EngineId = ?", engineId);

            return parts.Select(p => p.Category).Distinct().OrderBy(c => c).ToList();
        }

        public async Task<List<Part>> SearchPartsAsync(int engineId, string query = "", string category = "")
        {
            var db = await _context.GetConnectionAsync();

            // Base query linking Parts to Engine via Fitment
            var sql = "SELECT p.* FROM Part p " +
                      "INNER JOIN Fitment f ON f.PartId = p.Id " +
                      "WHERE f.EngineId = ?";

            var args = new List<object> { engineId };

            if (!string.IsNullOrWhiteSpace(category) && category != "All")
            {
                sql += " AND p.Category = ?";
                args.Add(category);
            }

            if (!string.IsNullOrWhiteSpace(query))
            {
                sql += " AND (p.Name LIKE ? OR p.OemNumber LIKE ?)";
                args.Add($"%{query}%");
                args.Add($"%{query}%");
            }

            return await db.QueryAsync<Part>(sql, args.ToArray());
        }

        public async Task<PartDetailDTO> GetPartDetailAsync(int partId)
        {
            var db = await _context.GetConnectionAsync();

            var part = await db.Table<Part>().FirstOrDefaultAsync(p => p.Id == partId);
            if (part == null) return null;

            var crossRefs = await db.Table<CrossRef>().Where(c => c.PartId == partId).ToListAsync();

            // Spec ScopeType "Part" and ScopeId = partId
            var specs = await db.Table<Spec>().Where(s => s.ScopeType == "Part" && s.ScopeId == partId).ToListAsync();

            // Supersessions
            var supersessions = await db.QueryAsync<Supersession>(
                "SELECT * FROM Supersession WHERE OldOemNumber = ? OR NewOemNumber = ?",
                part.OemNumber, part.OemNumber);

            return new PartDetailDTO
            {
                Part = part,
                CrossRefs = crossRefs,
                Specs = specs,
                Supersessions = supersessions
            };
        }
    }

    public class PartDetailDTO
    {
        public Part Part { get; set; }
        public List<CrossRef> CrossRefs { get; set; }
        public List<Spec> Specs { get; set; }
        public List<Supersession> Supersessions { get; set; }
    }
}
