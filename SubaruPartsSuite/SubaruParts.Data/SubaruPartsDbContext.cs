
using System;
using System.IO;
using SQLite;
using SubaruParts.Domain;
using System.Threading.Tasks;

namespace SubaruParts.Data
{
    public class SubaruPartsDbContext
    {
        private SQLiteAsyncConnection _database;
        private readonly string _dbPath;

        public SubaruPartsDbContext(string dbPath)
        {
            _dbPath = dbPath;
        }

        private async Task InitAsync()
        {
            if (_database != null)
                return;

            _database = new SQLiteAsyncConnection(_dbPath);
            await _database.CreateTableAsync<Engine>();
            await _database.CreateTableAsync<Part>();
            await _database.CreateTableAsync<CrossRef>();
            await _database.CreateTableAsync<Spec>();
            await _database.CreateTableAsync<Supersession>();
            await _database.CreateTableAsync<Fitment>();
        }

        public async Task<SQLiteAsyncConnection> GetConnectionAsync()
        {
            await InitAsync();
            return _database;
        }
    }
}
