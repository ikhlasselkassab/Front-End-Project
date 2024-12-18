class Filters {
  bool filterHotels5Star = false;
  bool filterHotels4Star = false;
  bool filterHotels3Star = false;
  bool filterHotels2Star = false;

  bool filterRestaurantsItalien = false;
  bool filterRestaurantsFastFood = false;
  bool filterRestaurantsMarocain = false;
  bool filterRestaurantsOriental = false;
  bool filterRestaurantsAsiatique = false;

  bool filterBusLine101 = false;
  bool filterBusLine102 = false;
  bool filterBusLine104 = false;
  bool filterBusLine106 = false;
  bool filterBusLine107 = false;

  bool filterLine1 = false;
  bool filterLine2 = false;

  void updateFilters(Map<String, bool> newFilters) {
    filterHotels5Star = newFilters['hotel_5_star'] ?? false;
    filterHotels4Star = newFilters['hotel_4_star'] ?? false;
    filterHotels3Star = newFilters['hotel_3_star'] ?? false;
    filterHotels2Star = newFilters['hotel_2_star'] ?? false;

    filterRestaurantsItalien = newFilters['restaurant_italien'] ?? false;
    filterRestaurantsFastFood = newFilters['restaurant_fastfood'] ?? false;
    filterRestaurantsMarocain = newFilters['restaurant_marocain'] ?? false;
    filterRestaurantsOriental = newFilters['restaurant_oriental'] ?? false;
    filterRestaurantsAsiatique = newFilters['restaurant_asiatique'] ?? false;

    filterBusLine101 = newFilters['bus_line_101'] ?? false;
    filterBusLine102 = newFilters['bus_line_102'] ?? false;
    filterBusLine104 = newFilters['bus_line_104'] ?? false;
    filterBusLine106 = newFilters['bus_line_106'] ?? false;
    filterBusLine107 = newFilters['bus_line_107'] ?? false;

    filterLine1 = newFilters['line_1'] ?? false;
    filterLine2 = newFilters['line_2'] ?? false;
  }
}
