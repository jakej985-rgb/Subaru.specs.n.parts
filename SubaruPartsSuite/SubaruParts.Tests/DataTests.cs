
using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SubaruParts.Data;
using SubaruParts.Data.Services;
using SubaruParts.Domain;
using Xunit;

namespace SubaruParts.Tests
{
    public class DataTests
    {
        private const string SeedJson = @"
{
  ""Engines"": [
    { ""Id"": 1, ""Code"": ""EJ22"", ""Phase"": ""1"" }
  ],
  ""Parts"": [
    { ""Id"": 1, ""Name"": ""Test Part"", ""Category"": ""Test"", ""OemNumber"": ""123"" }
  ],
  ""Fitments"": [
    { ""Id"": 1, ""EngineId"": 1, ""PartId"": 1 }
  ]
}
";

        [Fact]
        public async Task DatabaseInitializer_SeedsData()
        {
            var dbPath = Path.Combine(Path.GetTempPath(), $"testdb_{Guid.NewGuid()}.db3");
            var context = new SubaruPartsDbContext(dbPath);
            var initializer = new DatabaseInitializer(context);
            var seedStream = new MemoryStream(Encoding.UTF8.GetBytes(SeedJson));

            await initializer.InitializeAsync(seedStream);

            var db = await context.GetConnectionAsync();
            var count = await db.Table<Engine>().CountAsync();
            Assert.Equal(1, count);
        }

        [Fact]
        public async Task CatalogService_SearchParts_FiltersCorrectly()
        {
            var dbPath = Path.Combine(Path.GetTempPath(), $"testdb_{Guid.NewGuid()}.db3");
            var context = new SubaruPartsDbContext(dbPath);
            var initializer = new DatabaseInitializer(context);
            var seedStream = new MemoryStream(Encoding.UTF8.GetBytes(SeedJson));
            await initializer.InitializeAsync(seedStream);

            var service = new CatalogService(context);
            var parts = await service.SearchPartsAsync(1, "Test");

            Assert.Single(parts);
            Assert.Equal("Test Part", parts[0].Name);
        }

        [Fact]
        public void StoreLinkService_GeneratesUrls()
        {
            var service = new StoreLinkService();
            var url = service.GetAutoZoneUrl("123");
            Assert.Contains("123", url);
            Assert.StartsWith("https://", url);
        }
    }
}
