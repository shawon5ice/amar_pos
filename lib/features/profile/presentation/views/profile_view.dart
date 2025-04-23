import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_btn.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/profile/presentation/profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/methods/helper_methods.dart';

class PersonalInfoView extends StatefulWidget {
  const PersonalInfoView({super.key});

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  final ProfileController controller = Get.find();

  late TextEditingController fullName;
  late TextEditingController phoneNumber;
  late TextEditingController email;
  late TextEditingController address;

  @override
  void initState() {
    fullName = TextEditingController();
    phoneNumber = TextEditingController();
    email = TextEditingController();
    address = TextEditingController();
    controller.getProfileDetails().then((value){
      initializeData();
    });
    super.initState();
  }

  void initializeData(){
    fullName.text = controller.profileDetailsResponseModel!.data.name;
    phoneNumber.text = controller.profileDetailsResponseModel!.data.phone;
    address.text = controller.profileDetailsResponseModel!.data.address;
    email.text = controller.profileDetailsResponseModel!.data.email;
    controller.update(['profile_details',]);
  }

  Future<bool> validate() async {
    if (fullName.text.isEmpty) {
      Methods.showSnackbar(msg: "Please enter your name");
      return false;
    } else if (address.text.isEmpty) {
      Methods.showSnackbar(msg: "Please enter your business address");
      return false;
    }else if (phoneNumber.text.isEmpty) {
      Methods.showSnackbar(msg: "Please enter your phone number");
      return false;
    }
    return true;
  }

  Future<dio.FormData> prepareData() async {
    final Map<String, dynamic> fields = {
      "address": address.text,
      "email": email.text,
      "name": fullName.text,
      "phone": phoneNumber.text,
    };


    return dio.FormData.fromMap({
      ...fields,
    });
  }

  Future<dio.FormData> prepareProfileData() async {
    final Map<String, dio.MultipartFile> fileMap = {};

    fileMap['photo'] = await dio.MultipartFile.fromFile(
      controller.photo!,
    );
    return dio.FormData.fromMap({
      ...fileMap,
    });
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
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addH(20),
                Center(
                  child: Stack(
                    children: [
                      ClipOval(
                        child: GetBuilder<ProfileController>(
                          id: 'profile_picture',
                          builder: (controller) {
                            if (controller.photo != null) {
                              return Image.file(
                                File(controller.photo!),
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              );
                            } else {
                              return CachedNetworkImage(
                                imageUrl: controller
                                    .profileDetailsResponseModel!.data.photo!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: CircleAvatar(
                            radius: 24,
                            child: Icon(
                              Icons.edit,
                              size: 32,
                            ),
                          ),
                          onPressed: ()async {
                            await controller.selectFile();
                            var req = await prepareData();

                            controller.updateProfilePhoto(req);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                addH(20),
                RichFieldTitle(text: "Full Name"),
                addH(4),
                CustomTextField(
                  textCon: fullName,
                  hintText: "Enter your full name",
                ),
                addH(8),
                RichFieldTitle(text: "Email"),
                addH(4),
                CustomTextField(
                  textCon: email,
                  hintText: "Enter your email",
                ),
                addH(8),
                RichFieldTitle(text: "Phone Number"),
                addH(4),
                CustomTextField(
                  textCon: phoneNumber,
                  hintText: "Enter your phone number",
                ),
                addH(8),
                RichFieldTitle(text: "Address"),
                addH(4),
                CustomTextField(
                  textCon: address,
                  hintText: "Enter your address",
                  maxLine: 3,
                ),
                addH(20),
                CustomBtn(
                  btnTxt: "Save Changes",
                  onPressedFn: ()async{
                    FocusScope.of(context).unfocus();
                    bool check = await validate();
                    if (check) {
                      var req = await prepareData();
                      controller.saveProfileChanges(req);
                    }
                  },
                )
              ],
            ),
          );
        }
      },
    );
  }
}
