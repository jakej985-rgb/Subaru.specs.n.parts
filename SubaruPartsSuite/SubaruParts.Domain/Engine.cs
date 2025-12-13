
namespace SubaruParts.Domain
{
    public class Engine
    {
        public int Id { get; set; }
        public string Code { get; set; } // e.g., "EJ22"
        public string Phase { get; set; } // e.g., "1"
        public string YearRange { get; set; } // e.g., "1990-1998"
        public string Notes { get; set; }
    }
}
