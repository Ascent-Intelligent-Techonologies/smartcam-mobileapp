import 'package:smartcam_dashboard/data/models/filter_data.dart';
import 'package:smartcam_dashboard/data/models/filter_option.dart';

class AppiliedFilters {
  final List<FilterOptionSelectedValues> selectedFilters;
  AppiliedFilters._internal({required this.selectedFilters});
  factory AppiliedFilters.empty() {
    return AppiliedFilters._internal(selectedFilters: []);
  }
  factory AppiliedFilters.emptyFromFilterData(FilterData filterData) {
    return AppiliedFilters._internal(
        selectedFilters: filterData.availableFilters
            .map((e) => FilterOptionSelectedValues(
                name: e.name, selectedFilters: [], value: e.value))
            .toList());
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'AppiliedFilters{selectedFilters: $selectedFilters}';
  }
}
