namespace REST_API.Objects
{
    public class VehicleCreateRequest
    {
        public string Make { get; set; }
        public string Model { get; set; }
        public int Year { get; set; }
        public int MaxCapacity { get; set; }
        public int OwnerId { get; set; }
        public IFormFile? VehiclePicture { get; set; }
    }
}
