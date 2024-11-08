// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../../utils/constants/image_strings.dart';
import '../enums/post_type.dart';

class PostModel {
  String id;
  String userName;
  String userImage;
  String location;
  String postTime;
  String description;
  PostType postType;
  String image;
  double likes;
  double comments;
  PostModel({
    required this.id,
    required this.userImage,
    required this.userName,
    required this.location,
    required this.postTime,
    required this.description,
    required this.postType,
    required this.image,
    required this.likes,
    required this.comments,
  });
}

List<PostModel> dummyPosts = [
  PostModel(
      id: '1',
      userName: 'John Milke',
      location: 'Berlin,Germany',
      postTime: '5m ago',
      userImage: MyImages.kUser2,
      description:
          'At vero eos et accusamus et iusto odio dignissimos ducimus qui dolores et quas molestias excepturi sint occaecati cupiditate non provident',
      postType: PostType.Run,
      image: MyImages.kPost1,
      likes: 5.3,
      comments: 10.4),
  PostModel(
      id: '2',
      userName: 'Steve Douglas',
      location: 'New york,USA',
      postTime: '44m ago',
      userImage: MyImages.kUser4,
      description:
          "Blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident",
      postType: PostType.BasketBall,
      image: MyImages.kPost2,
      likes: 5.3,
      comments: 10.4),
];
