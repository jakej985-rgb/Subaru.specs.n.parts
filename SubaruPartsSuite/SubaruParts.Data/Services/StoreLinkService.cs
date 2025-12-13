
using System.Net;

namespace SubaruParts.Data.Services
{
    public class StoreLinkService
    {
        // Simple helper to encode
        private string Enc(string text) => WebUtility.UrlEncode(text);

        public string GetAutoZoneUrl(string query)
        {
            return $"https://www.autozone.com/searchresult?searchText={Enc(query)}";
        }

        public string GetOReillyUrl(string query)
        {
            return $"https://www.oreillyauto.com/search?q={Enc(query)}";
        }

        public string GetNapaUrl(string query)
        {
            return $"https://www.napaonline.com/en/search?text={Enc(query)}";
        }
    }
}
