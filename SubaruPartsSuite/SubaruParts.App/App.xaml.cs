
using Microsoft.Maui.Controls;
using SubaruParts.Data;
using System.IO;
using System.Reflection;
using System.Threading.Tasks;

namespace SubaruParts.App
{
    public partial class App : Application
    {
        private readonly DatabaseInitializer _dbInitializer;

        public App(DatabaseInitializer dbInitializer)
        {
            InitializeComponent();
            _dbInitializer = dbInitializer;

            MainPage = new AppShell();
        }

        protected override async void OnStart()
        {
            base.OnStart();
            await InitDb();
        }

        private async Task InitDb()
        {
            // Load seed data from raw asset
            using var stream = await FileSystem.OpenAppPackageFileAsync("seeddata.json");
            await _dbInitializer.InitializeAsync(stream);
        }
    }
}
