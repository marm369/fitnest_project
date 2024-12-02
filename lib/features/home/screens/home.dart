import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'event_scroll_widget.dart';
import '../../../common/widgets/tabbutton/tab_item.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/home_controller.dart';
import '../enums/post_type.dart';
import '../models/post_model.dart';
import 'widgets/components/custom_icons.dart';
import 'widgets/components/post_card.dart';
import 'widgets/components/post_type_chips.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Instantiate controllers
    final HomeController homeController = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Obx(() => Text(
              'Hi ${homeController.userName.value},',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            )),
      ),
      body: Column(
        children: [
          SizedBox(height: MySizes.defaultSpace / 2),
          // Interests Horizontal Scrollable List
          Obx(
            () => Flexible(
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: homeController.categories.length,
                  itemBuilder: (context, index) {
                    final interest = homeController.categories[index]['name'];
                    return Obx(() => GestureDetector(
                          onTap: () => homeController.toggleCategory(interest),
                          child: Row(
                            children: [
                              TabItem(
                                text: interest,
                                icon: Icon(
                                  homeController.categories[index]['icon'],
                                  color: homeController
                                              .selectedCategories[interest] ==
                                          true
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              ),
                              SizedBox(width: MySizes.spaceBtwItems),
                            ],
                          ),
                        ));
                  },
                ),
              ),
            ),
          ),
          EventScrollWidget(),
        ],
      ),
    );
  }
}
