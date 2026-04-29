using Core.Others;

namespace REST_API.ResponseObjects
{
    public class VehicleResponse
    {
        public int Id { get; set; }
        public VehicleMake Make { get; set; }
        public string Model { get; set; }
        public int Year { get; set; }
        public int MaxCapacity { get; set; }
        public int OwnerId { get; set; }
        public string OwnerName { get; set; }
    }
}
