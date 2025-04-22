import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/profile/presentation/profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInfoView extends StatefulWidget {
  const PersonalInfoView({super.key});

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  final ProfileController controller = Get.find();

  @override
  void initState() {
    controller.getProfileDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      id: 'profile_details',
      builder: (controller) {
        if (controller.isProfileDetailsLoading) {
          return Center(
            child: RandomLottieLoader.lottieLoader(),
          );
        } else if (controller.profileDetailsResponseModel == null) {
          return Center(
            child: Text("Something went wrong"),
          );
        } else {
          return Column(
            children: [
              Stack(
                children: [
                  Image.network(
                    controller.profileDetailsResponseModel!.data.photo!,
                    width: 250,
                    height: 250,
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: IconButton(
                      icon: CircleAvatar(
                        radius: 24,
                        child: Icon(
                          Icons.edit,
                          size: 32,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
              CachedNetworkImage(
                imageUrl: controller.profileDetailsResponseModel!.data.photo!,
                height: 100,
              )
            ],
          );
        }
      },
    );
  }
}
