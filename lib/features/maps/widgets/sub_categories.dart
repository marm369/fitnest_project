import 'package:fitnest/common/widgets/appbar/appbar.dart';
import 'package:fitnest/common/widgets/images/rounded_image.dart';
import 'package:fitnest/common/widgets/texts/section_heading.dart';
import 'package:fitnest/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/sizes.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: Text('Sports'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySizes.defaultSpace),
          child: Column(
            children: [
              /// Banner
              RoundedImage(
                  width: double.infinity,
                  imageUrl: MyImages.loadingIllustration,
                  applyImageRadius: true),
              const SizedBox(height: MySizes.spaceBtwSections),

              /// Sub-Categories
              Column(
                children: [
                  /// Heading
                  SectionHeading(title: 'Sports types', onPressed: () {}),
                  const SizedBox(height: MySizes.spaceBtwItems / 2),

                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: MySizes.spaceBtwItems),
                      itemBuilder: (context, index) =>
                          Container(color: Colors.yellow),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
