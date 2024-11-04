import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateOfBirthGenderController extends GetxController {
  final TextEditingController dateController = TextEditingController();
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxString selectedGender = ''.obs;

  // Méthode pour sélectionner la date
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDate.value = picked;
      dateController.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  // Méthode pour mettre à jour le genre sélectionné
  void setGender(String gender) {
    selectedGender.value = gender;
  }

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }
}
