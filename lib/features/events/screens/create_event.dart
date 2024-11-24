import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../common/widgets/buttons/square_button.dart';
import '../../../utils/constants/icons.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../controllers/category_controller.dart';
import '../controllers/event_controller.dart';

class EventScreen extends StatelessWidget {
  final EventController eventController = Get.put(EventController());
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Let’s Bring Your Event to Life!"),
        backgroundColor: dark ? Colors.black : Colors.white,
        titleTextStyle: TextStyle(
          color: dark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView(
          children: [
            const SizedBox(height: MySizes.spaceBtwItems),
            // Champ de nom
            TextFormField(
              controller: eventController.nameController,
              decoration: const InputDecoration(
                labelText: "Event Name",
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            // Champ de description
            TextFormField(
              controller: eventController.descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            // Sélection de dates
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => eventController.selectDate(true),
                    child: AbsorbPointer(
                      child: Obx(() => TextFormField(
                            decoration: InputDecoration(
                              labelText: eventController.startDate.value != null
                                  ? "Start: ${eventController.startDate.value!.toLocal().toString().split(' ')[0]}"
                                  : "Start Date",
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                          )),
                    ),
                  ),
                ),
                const SizedBox(width: MySizes.spaceBtwItems),
                Expanded(
                  child: GestureDetector(
                    onTap: () => eventController.selectDate(false),
                    child: AbsorbPointer(
                      child: Obx(() => TextFormField(
                            decoration: InputDecoration(
                              labelText: eventController.endDate.value != null
                                  ? "End: ${eventController.endDate.value!.toLocal().toString().split(' ')[0]}"
                                  : "End Date",
                              prefixIcon: Icon(Icons.date_range),
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            // Sélection de l'heure de début
            GestureDetector(
              onTap: () => eventController.selectStartTime(),
              child: AbsorbPointer(
                child: Obx(() => TextFormField(
                      decoration: InputDecoration(
                        labelText: eventController.startTime.value != null
                            ? "Start time : ${eventController.formatTimeOfDay(eventController.startTime.value!)}"
                            : "Start time",
                        prefixIcon: Icon(Icons.access_time),
                      ),
                    )),
              ),
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            Obx(() {
              return SquareButton(
                text: 'Event Image',
                icon: Iconsax.camera,
                onPressed: () {
                  eventController
                      .chooseImage(); // Make sure to call the method, not just refer to it
                },
                image: eventController.eventImage.value != null
                    ? eventController.eventImage.value
                    : null,
              );
            }),
            const SizedBox(height: MySizes.spaceBtwItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(() {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.lightBlue[50],
                      ),
                      child: DropdownButton<String>(
                        value: categoryController.selectedCategory.value?.name,
                        hint: const Text(
                          "Choose Category",
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        isExpanded: true,
                        underline: Container(),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.blueAccent),
                        style: const TextStyle(
                            color: Colors.blueAccent, fontSize: 16.0),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            final selectedCategory =
                                categoryController.categories.firstWhere(
                                    (category) => category.name == newValue);
                            categoryController
                                .setSelectedCategory(selectedCategory);
                          }
                        },
                        items: categoryController.categories
                            .map<DropdownMenuItem<String>>(
                          (category) {
                            return DropdownMenuItem<String>(
                              value: category.name,
                              child: Row(
                                children: [
                                  if (category.iconName.isNotEmpty)
                                    Icon(iconMapping[category.iconName]),
                                  const SizedBox(width: 8.0),
                                  Text(category.name,
                                      style: const TextStyle(
                                          color: Colors.blueAccent)),
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    );
                  }),
                ),
                const SizedBox(
                    width: 8.0), // Espacement entre le Dropdown et le bouton
                Obx(() {
                  return OutlinedButton(
                    onPressed: categoryController.requiresRoute.value
                        ? eventController.createRouteInMap
                        : eventController.viewMap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blueAccent, // Text and icon color
                      side: BorderSide(
                          color: Colors.blueAccent,
                          width: 2.0), // Border color and width
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 24.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      textStyle: const TextStyle(fontSize: 16.0),
                    ),
                    child: Text(categoryController.requiresRoute.value
                        ? "Create the itinerary"
                        : "Choose location"),
                  );
                }),
              ],
            ),
            const SizedBox(width: MySizes.spaceBtwItems),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centrer les éléments
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.blueAccent, // Changer la couleur de l'icône
                    size: 30.0, // Changer la taille de l'icône
                  ),
                  onPressed: eventController.decrementParticipantCount,
                  tooltip: "Decrement participant", // Ajouter un tooltip
                ),
                const SizedBox(
                    width: 16.0), // Espacement entre les icônes et le texte
                Obx(() {
                  return Text(
                    "Participants: ${eventController.participantCount}",
                    style: const TextStyle(
                      fontSize: 18.0, // Changer la taille du texte
                      color: Colors.blueAccent, // Couleur du texte
                      fontWeight: FontWeight.w600, // Gras pour le texte
                    ),
                  );
                }),
                const SizedBox(
                    width: 16.0), // Espacement entre le texte et l'icône
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.blueAccent, // Changer la couleur de l'icône
                    size: 30.0, // Changer la taille de l'icône
                  ),
                  onPressed: () => eventController.incrementParticipantCount(),
                  tooltip: "Increment participant", // Ajouter un tooltip
                ),
              ],
            ),
            const SizedBox(width: MySizes.spaceBtwItems),
            OutlinedButton(
              onPressed: () => eventController
                  .submitForm(categoryController.selectedCategory.value!.id),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0), // Espacement autour du texte
                side: const BorderSide(
                  color: Colors.blueAccent, // Bordure bleue
                  width: 2.0, // Épaisseur de la bordure
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Coins arrondis
                ),
                foregroundColor: Colors.blueAccent, // Couleur du texte
                textStyle: const TextStyle(
                  fontSize: 16.0, // Taille du texte
                  fontWeight: FontWeight.bold, // Texte en gras
                ),
              ),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
