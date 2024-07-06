class BidEntity {
  String technicianName; // auto
  String technicianId; // auto
  double price; // technician
  double rating; // auto

  BidEntity({required this.technicianId, required this.technicianName, required this.price, required this.rating});

  factory BidEntity.fromMap(Map<String, dynamic> map) {
    return BidEntity(technicianId: map["technicianId"], technicianName: map["technicianName"], price: map["price"], rating: map["rating"]);
  }

  Map<String, dynamic> toMap() {
    return {'technicianId': technicianId, 'technicianName': technicianName, 'price': price, 'rating': rating};
  }
}
