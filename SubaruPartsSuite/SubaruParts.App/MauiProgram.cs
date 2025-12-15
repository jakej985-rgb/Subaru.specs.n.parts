
using Microsoft.Maui;
using Microsoft.Maui.Controls;
using Microsoft.Maui.Controls.Hosting;
using Microsoft.Extensions.DependencyInjection;
using SubaruParts.Data;
using SubaruParts.Data.Services;
using SubaruParts.App.Services;
using SubaruParts.App.ViewModels;
using SubaruParts.App.Pages;
using System.IO;
using System;
using System.Threading.Tasks;

namespace SubaruParts.App
{
    public static class MauiProgram
    {
        public static MauiApp CreateMauiApp()
        {
            var builder = MauiApp.CreateBuilder();
            builder
                .UseMauiApp<App>()
                .ConfigureFonts(fonts =>
                {
                    fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
                    fonts.AddFont("OpenSans-Semibold.ttf", "OpenSansSemibold");
                });

            // Services
            string dbPath = Path.Combine(FileSystem.AppDataDirectory, "subaruparts.db3");
            builder.Services.AddSingleton(s => new SubaruPartsDbContext(dbPath));
            builder.Services.AddTransient<DatabaseInitializer>();
            builder.Services.AddSingleton<CatalogService>();
            builder.Services.AddSingleton<StoreLinkService>();
            builder.Services.AddSingleton<CompatibilityService>();
            builder.Services.AddSingleton<IVehicleContextService, VehicleContextService>();

            // ViewModels
            builder.Services.AddTransient<HomeViewModel>();
            builder.Services.AddTransient<EnginePickerViewModel>();
            builder.Services.AddTransient<PartListViewModel>();
            builder.Services.AddTransient<PartDetailViewModel>();
            builder.Services.AddTransient<CompatibilityViewModel>();

            // Pages
            builder.Services.AddTransient<HomePage>();
            builder.Services.AddTransient<EnginePickerPage>();
            builder.Services.AddTransient<PartListPage>();
            builder.Services.AddTransient<PartDetailPage>();
            builder.Services.AddTransient<CompatibilityPage>();

            return builder.Build();
        }
    }
}
