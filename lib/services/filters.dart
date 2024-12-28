class Filters {
  Map<String, bool> activeFilters = {
    'hotel_5_star': false,
    'hotel_4_star': false,
    'hotel_3_star': false,
    'hotel_2_star': false,
    'restaurant_italien': false,
    'restaurant_fastfood': false,
    'restaurant_marocain': false,
    'restaurant_oriental': false,
    'restaurant_asiatique': false,
    'bus_line_101': false,
    'bus_line_102': false,
    'bus_line_104': false,
    'bus_line_106': false,
    'bus_line_107': false,
    'line_1': false,
    'line_2': false,
  };

  void updateFilters(Map<String, bool> newFilters) {
    newFilters.forEach((key, value) {
      activeFilters[key] = value;
    });
  }
}
