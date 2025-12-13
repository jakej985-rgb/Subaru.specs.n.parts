
namespace SubaruParts.Domain
{
    public class Supersession
    {
        public int Id { get; set; }
        public string OldOemNumber { get; set; }
        public string NewOemNumber { get; set; }
        public string Notes { get; set; }
    }
}
