import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/buttons/filter_button.dart';
import '../../../../common/widgets/buttons/icon_button.dart';
import '../../../../utils/constants/colors.dart';
import '../../../utils/constants/icons.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../events/controllers/category_controller.dart';
import '../../events/models/category.dart';
import '../controllers/filter_controller.dart';

// The model of filters
class EventFilters {
  final String? date;
  final String? time;
  final String? distance;
  final String? category;

  EventFilters({this.date, this.time, this.distance, this.category});
}

class Filters extends StatelessWidget {
  final ValueChanged<String?> onCategorySelected;
  final ValueChanged<EventFilters> onFiltersApplied;

  const Filters({
    super.key,
    required this.onCategorySelected,
    required this.onFiltersApplied,
  });

  @override
  Widget build(BuildContext context) {
    // Instantiate the controller
    final FiltersController filterController = Get.put(FiltersController());
    final CategoryController categoryController = Get.put(CategoryController());

    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          IconButtonW(
            iconColor: MyColors.darkerGrey,
            icon: Icons.filter_list,
            onPressed: () {
              _showFilterSheet(context, filterController);
            },
          ),
          SizedBox(width: 10),
          FilterButton(
            icon: Icons.calendar_today,
            label: 'By Date',
            onPressed: () {
              _showDateFilter(context, filterController);
            },
          ),
          SizedBox(width: 10),
          FilterButton(
            icon: Icons.access_time,
            label: 'Time of Day',
            onPressed: () {
              _showTimeFilter(context, filterController);
            },
          ),
          SizedBox(width: 10),
          FilterButton(
            icon: Icons.location_on,
            label: 'By Distance',
            onPressed: () {
              _showDistanceFilter(context, filterController);
            },
          ),
          SizedBox(width: 10),
          FilterButton(
            icon: Icons.category,
            label: 'By Category',
            onPressed: () {
              _showCategoryFilter(context, categoryController);
            },
          ),
        ],
      ),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...options.map((option) {
          return ListTile(
            title: Text(option),
            leading: Radio<String>(
              value: option,
              groupValue: selectedValue,
              onChanged: onChanged,
            ),
          );
        }).toList(),
        SizedBox(height: 20),
      ],
    );
  }

  // Function to display filter sheet
  void _showFilterSheet(BuildContext context, FiltersController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                controller: scrollController,
                children: [
                  _buildDateSection(controller),
                  _buildTimeSection(controller),
                  _buildDistanceSection(controller),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      controller.applyFilters();
                    },
                    child: Text('Apply'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Function to display date filter
  void _showDateFilter(BuildContext context, FiltersController controller) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildDateSection(controller),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to display time filter
  void _showTimeFilter(BuildContext context, FiltersController controller) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildTimeSection(controller),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to display distance filter
  void _showDistanceFilter(BuildContext context, FiltersController controller) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildDistanceSection(controller),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to display category filter
  void _showCategoryFilter(
      BuildContext context, CategoryController categoryController) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildCategorySection(categoryController),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySection(CategoryController categoryController) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: MySizes.sm,
            runSpacing: MySizes.xs / 2,
            children:
                List.generate(categoryController.categories.length, (index) {
              final category = categoryController
                  .categories[index]; // Get the category at the index
              final isSelected = categoryController.selectedCategory?.value ==
                  category; // Check if the category is selected

              return GestureDetector(
                onTap: () => categoryController
                    .setSelectedCategory(category), // Update selected category
                child: Container(
                  padding: EdgeInsets.all(MySizes.lg / 2),
                  margin: EdgeInsets.symmetric(vertical: MySizes.xs),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? const Color(0xFF90CAF9) : Colors.grey[50],
                    border: Border.all(
                      color: isSelected
                          ? MyColors.primaryBackground
                          : MyColors.borderPrimary,
                    ),
                    borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        iconMapping[category.iconName],
                        color: isSelected
                            ? MyColors.primaryBackground
                            : MyColors.borderPrimary,
                      ),
                      SizedBox(width: MySizes.xs),
                      Text(
                        category.name, // Use category name directly
                        style: TextStyle(
                          fontSize: MySizes.fontSizeSm,
                          color: isSelected
                              ? MyColors.primaryBackground
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(FiltersController controller) {
    return _buildRadioSection(
      title: 'By Date',
      options: ['Any day', 'Today', 'Tomorrow', 'This Week', 'After This Week'],
      selectedValue: controller.selectedDate?.value,
      onChanged: (value) {
        controller.updateDate(value);
      },
    );
  }

  Widget _buildTimeSection(FiltersController controller) {
    return _buildRadioSection(
      title: 'By Time of Day',
      options: ['Any Time', 'Morning', 'Afternoon', 'Evening'],
      selectedValue: controller.selectedTime?.value,
      onChanged: (value) {
        controller.updateTime(value);
      },
    );
  }

  Widget _buildDistanceSection(FiltersController controller) {
    return _buildRadioSection(
      title: 'By Distance',
      options: ['Any Distance', 'Less than 5 km', '5 - 10 km', '10+ km'],
      selectedValue: controller.selectedDistance?.value,
      onChanged: (value) {
        controller.updateDistance(value);
      },
    );
  }
}
