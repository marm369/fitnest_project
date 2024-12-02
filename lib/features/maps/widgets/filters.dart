import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/buttons/filter_button.dart';
import '../../../../common/widgets/buttons/icon_button.dart';
import '../../../../utils/constants/colors.dart';
import '../../events/controllers/category_controller.dart';
import '../../events/models/category.dart';
import '../../events/models/event_filters.dart';
import '../controllers/filter_controller.dart';

class Filters extends StatelessWidget {
  final ValueChanged<EventFilters> onFiltersApplied;
  final ValueChanged<Category?> onCategorySelected;
  final ValueChanged<String> onPartDaySelected;

  const Filters({
    super.key,
    required this.onFiltersApplied,
    required this.onCategorySelected,
    required this.onPartDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final filterController = Get.put(FiltersController());
    final categoryController = Get.put(CategoryController());

    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          IconButtonW(
            iconColor: MyColors.darkerGrey,
            icon: Icons.filter_list,
            onPressed: () => _showFilterSheet(context, filterController),
          ),
          const SizedBox(width: 10),
          _buildFilterButton(
            context,
            filterController,
            'By Date',
            Icons.calendar_today,
            _buildDateSection,
          ),
          _buildFilterButton(
            context,
            filterController,
            'Time of Day',
            Icons.access_time,
            _buildTimeSection,
          ),
          _buildFilterButton(
            context,
            filterController,
            'By Distance',
            Icons.location_on,
            _buildDistanceSection,
          ),
          FilterButton(
            icon: Icons.category,
            label: 'By Category',
            onPressed: () => _showCategoryFilter(context, categoryController),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context, FiltersController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            controller: scrollController,
            children: [
              _buildDateSection(controller),
              _buildTimeSection(controller),
              _buildDistanceSection(controller),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyFilters(controller);
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryFilter(
      BuildContext context,
      CategoryController categoryController,
      ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Obx(() {
        final categories = categoryController.categories;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...categories.map(
                  (category) => ListTile(
                title: Text(category.name),
                leading: Radio<Category?>(
                  value: category,
                  groupValue: categoryController.selectedCategory.value,
                  onChanged: (value) {
                    categoryController.setSelectedCategory(value!);
                    onCategorySelected(value);
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _applyFilters(Get.find<FiltersController>());
              },
              child: const Text('Apply'),
            ),
          ],
        );
      }),
    );
  }

  void _applyFilters(FiltersController controller) {
    final filters = EventFilters(
      date: controller.selectedDate.value,
      time: controller.selectedTime.value,
      distance: controller.selectedDistance.value,
      category: controller.selectedCategory.value?.name,
    );
    onFiltersApplied(filters);
  }

  Widget _buildFilterButton(
      BuildContext context,
      FiltersController controller,
      String label,
      IconData icon,
      Widget Function(FiltersController) sectionBuilder,
      ) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FilterButton(
        icon: icon,
        label: label,
        onPressed: () =>
            _showFilterModal(context, controller, sectionBuilder),
      ),
    );
  }

  Widget _buildDateSection(FiltersController controller) {
    return _buildRadioSection(
      title: 'By Date',
      options: ['Any day', 'Today', 'Tomorrow', 'This Week', 'After This Week'],
      selectedValue: controller.selectedDate.value,
      onChanged: (value) => controller.updateDate(value!),
    );
  }

  Widget _buildTimeSection(FiltersController controller) {
    return _buildRadioSection(
      title: 'By Time',
      options: ['Any Time', 'Morning', 'Afternoon', 'Evening', 'Night'],
      selectedValue: controller.selectedTime.value,
      onChanged: (value) => controller.updateTime(value!),
    );
  }

  Widget _buildDistanceSection(FiltersController controller) {
    return _buildRadioSection(
      title: 'By Distance',
      options: ['Any Distance', '< 5 km', '5 - 10 km', '10+ km'],
      selectedValue: controller.selectedDistance.value,
      onChanged: (value) => controller.updateDistance(value!),
    );
  }

  Widget _buildRadioSection({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...options.map((option) => RadioListTile<String?>(
          title: Text(option),
          value: option,
          groupValue: selectedValue,
          onChanged: onChanged,
        )),
      ],
    );
  }

  void _showFilterModal(
      BuildContext context,
      FiltersController controller,
      Widget Function(FiltersController) sectionBuilder,
      ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            sectionBuilder(controller),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _applyFilters(controller);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
