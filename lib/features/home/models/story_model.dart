// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../../utils/constants/image_strings.dart';

class Story {
  String userImage;
  bool isViewed;
  Story({
    required this.userImage,
    required this.isViewed,
  });
}

List<Story> dummyStories = [
  Story(userImage: MyImages.kUser2, isViewed: false),
  Story(userImage: MyImages.kUser3, isViewed: true),
  Story(userImage: MyImages.kUser4, isViewed: true),
];
