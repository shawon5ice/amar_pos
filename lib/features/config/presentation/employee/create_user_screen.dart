import 'dart:io';

import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/constants/app_strings.dart';
import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/config/data/model/employee/employee_list_response_model.dart';
import 'package:amar_pos/features/config/data/model/employee/outlet_list_dd_response_model.dart';
import 'package:amar_pos/features/config/data/model/outlet/outlet_list_model_response.dart';
import 'package:amar_pos/features/config/presentation/employee/employee_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:get/get.dart';
import 'package:amar_pos/core/core.dart';
import 'package:hive/hive.dart';
import '../../../../core/data/model/outlet_model.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/dotted_border_painter.dart';
import '../../../../core/widgets/field_title.dart';

class CreateUserScreen extends StatefulWidget {
  final Employee? user;

  const CreateUserScreen({super.key, this.user});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final EmployeeController controller = Get.find();
  String? fileName;
  late TextEditingController name;
  late TextEditingController phoneNo;
  late TextEditingController address;
  late TextEditingController designation;
  late TextEditingController email;
  late TextEditingController pass;
  late TextEditingController confirmPass;
  late TextEditingController dob;
  late TextEditingController gender;
  late TextEditingController maritalStatus;
  bool allowLogin = false;

  final formKey = GlobalKey<FormState>();

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        fileName = result.files.single.path;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    phoneNo = TextEditingController();
    address = TextEditingController();
    designation = TextEditingController();
    email = TextEditingController();
    pass = TextEditingController();
    confirmPass = TextEditingController();
    dob = TextEditingController();
    gender = TextEditingController();
    maritalStatus = TextEditingController();
    controller.getAllOutletForDD(employee: widget.user);


    if (widget.user != null) {
      name.text = widget.user!.name;
      phoneNo.text = widget.user!.phone;
      email.text = widget.user!.email ?? '';
      address.text = widget.user!.address;
      fileName = widget.user!.photo;
      allowLogin = widget.user!.allowLogin == 0 ? false : true;
      if(widget.user?.permissions != null){
        processPermissions();
      }

    }


  }

  Map<String, Map<String, bool>>  permissionStatus = {};
  Map<String, bool> expandedGroups = {};

  void toggleGroup(String groupKey) {
    final current = expandedGroups[groupKey] ?? false;
    expandedGroups[groupKey] = !current;
    controller.update(['employee_permissions']);
  }


  Future<void> processPermissions() async{
    await controller.preparePermissions();

    logger.i(controller.permissionStatus.length);
    for (final user in widget.user!.permissions!.entries) {
      final userKey = user.key;
      logger.i(userKey);
      final perms = user.value;

      // permissionStatus[userKey] = {};

      for (final perm in perms.entries) {
        final permKey = perm.key;
        logger.i(permKey);
        final permValue = perm.value;

        controller.permissionStatus[userKey]?[permKey] = true;
      }
    }

    // widget.user?.permissions!.entries.forEach((outer){
    //   logger.i(outer.key);
    //   outer.value.entries.forEach((inner){
    //     logger.e(inner.key);
    //     controller.permissionStatus[outer.key]?[inner.key] = true;
    //   });
    // });
    controller.update(['employee_permissions']);
  }

  @override
  dispose() {
    super.dispose();
    name.dispose();
    phoneNo.dispose();
    address.dispose();
    designation.dispose();
    email.dispose();
    pass.dispose();
    confirmPass.dispose();
    dob.dispose();
    gender.dispose();
    maritalStatus.dispose();
  }

  final TextEditingController textEditingController = TextEditingController();

  void togglePermissionGroup(String outerKey) {
    final innerMap = controller.permissionStatus[outerKey];
    if (innerMap == null) return;

    final shouldSelectAll = innerMap.values.any((v) => v == false);

    innerMap.updateAll((key, value) => shouldSelectAll);
    controller.update(['employee_permissions']); // Update just this widget
  }

  bool isUpperCase(String char) {
    return char == char.toUpperCase() && char != char.toLowerCase();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user != null ? "Update Employee": "Create Employee"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      // Ensures content adjusts with the keyboard
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldTitle("Name"),
                      addH(8.h),
                      CustomTextField(
                        textCon: name,
                        hintText: "Type name here...",
                        validator: (value) =>
                            FieldValidator.nonNullableFieldValidator(
                                value, "Employee name"),
                      ),
                      addH(16.h),
                      const FieldTitle("Phone No."),
                      addH(8.h),
                      CustomTextField(
                        textCon: phoneNo,
                        hintText: "Type number here...",
                        inputType: TextInputType.phone,
                        validator: (value) =>
                            FieldValidator.phoneNumberFieldValidator(
                                value, "Employee phone number", false),
                      ),
                      addH(16.h),
                      const FieldTitle("Email"),
                      addH(8.h),
                      CustomTextField(
                        textCon: email,
                        hintText: "Type email here...",
                        inputType: TextInputType.emailAddress,
                      ),
                      addH(16.h),
                      const FieldTitle("Address"),
                      addH(8.h),
                      CustomTextField(
                        textCon: address,
                        hintText: "Type address here...",
                        validator: (value) =>
                            FieldValidator.nonNullableFieldValidator(
                                value, "Employee address"),
                      ),
                      addH(16.h),
                      Row(
                        children: [
                          RepaintBoundary(
                            child: Checkbox(
                                visualDensity: VisualDensity.compact,
                                value: allowLogin,
                                onChanged: (value) {
                                  setState(() {
                                    allowLogin = !allowLogin;
                                  });
                                }),
                          ),
                          addW(16.w),
                          const FieldTitle("Allow Login"),
                        ],
                      ),
                      addH(16.h),
                      if (allowLogin && widget.user == null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldTitle("Password"),
                            addH(8.h),
                            CustomTextField(
                              textCon: pass,
                              isPassField: true,
                              hintText: "Type password here...",
                              validator: (value) => allowLogin
                                  ? FieldValidator.nonNullableFieldValidator(
                                      value, "Password")
                                  : null,
                            ),
                            addH(16.h),
                            const FieldTitle("Confirm password"),
                            addH(8.h),
                            CustomTextField(
                              textCon: confirmPass,
                              hintText: "Retype password here...",
                              isPassField: true,
                              validator: (value) => allowLogin
                                  ? FieldValidator.nonNullableFieldValidator(
                                      value, "Confirm password")
                                  : null,
                            ),
                          ],
                        ),
                      addH(20.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FieldTitle(
                            "Upload Photo",
                          ),
                          addH(8.h),
                          InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            onTap: selectFile,
                            child: CustomPaint(
                              painter: DottedBorderPainter(
                                color: const Color(0xffD8E0EC),
                              ),
                              child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Center(
                                  child: fileName == null
                                      ? const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.image_outlined,
                                                size: 40, color: Colors.grey),
                                            SizedBox(height: 8),
                                            Text(
                                              "Select employee picture",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              fileName!.contains('https://') &&
                                                      widget.user != null
                                                  ? Image.network(
                                                      widget.user!.photo)
                                                  : Image.file(
                                                      fit: BoxFit.cover,
                                                      File(fileName!),
                                                    ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              addH(20.h),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldTitle("Select Outlet"),
                    addH(8),
                    GetBuilder<EmployeeController>(
                      id: 'outlet_dd',
                      builder: (controller) => DropdownButtonHideUnderline(
                        child: DropdownButton2<OutletModel>(
                          isExpanded: true,
                          hint: Text(
                            controller.outlets.isEmpty
                                ? 'Loading...'
                                : controller.outletListDDResponseModel == null
                                ? AppStrings.kWentWrong
                                : 'Select an outlet...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: controller.outlets
                              .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                              .toList(),
                          value: controller.selectedOutlet,
                          onChanged: (value) {
                            setState(() {
                              controller.selectedOutlet = value;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 58,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.inputBorderColor),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                            // width: 200,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: textEditingController,
                            searchInnerWidgetHeight: 58,
                            searchInnerWidget: Container(
                              height: 58,
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 4,
                                right: 8,
                                left: 8,
                              ),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: textEditingController,
                                validator: (value) {
                                  if (controller.selectedOutlet == null) {
                                    return "Please select an outlet";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: 'Search for an item...',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return item.value!.name
                                  .toString()
                                  .contains(searchValue);
                            },
                          ),
                          //This to clear the search value when you close the menu
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              textEditingController.clear();
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              addH(20.h),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: GetBuilder<EmployeeController>(
                  id: 'employee_permissions',
                  builder: (controller) {
                    if (controller.permissionLoading) {
                      return CircularProgressIndicator();
                    } else if (controller.permissionApiResponse == null) {
                      return Container();
                    } else {
                      bool isAllGroupPermissionSelected = controller.permissionStatus.keys.every((outerEntry) =>  controller.permissionStatus[outerEntry]?.values.every((v) => v) ?? false);
                      return Column(
                        children: [
                          Row(
                            children: [
                              const FieldTitle("Select Permission"),
                              Spacer(),
                              TextButton(
                                onPressed: ()  {
                                  if(isAllGroupPermissionSelected){
                                    controller.preparePermissions(value: false);
                                    isAllGroupPermissionSelected = false;
                                  }else{
                                    controller.preparePermissions(value: true);
                                    isAllGroupPermissionSelected = true;
                                  }
                                  controller.update(['employee_permissions']);
                                  setState(() {

                                  });
                                },
                                child: Text(isAllGroupPermissionSelected ? "Deselect All" : "Select All"),
                              ),
                            ],
                          ),
                          addH(8),
                          ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: controller
                                .permissionApiResponse!.data.entries
                                .map((outerEntry) {
                              final isAllSelected = controller.permissionStatus[outerEntry.key]?.values.every((v) => v) ?? false;
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: context.width * .5,
                                          child: Row(children: [
                                            Expanded(
                                              child: Text(
                                                outerEntry.key,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(expandedGroups[outerEntry.key] == true
                                                  ? Icons.expand_less
                                                  : Icons.expand_more),
                                              onPressed: () => toggleGroup(outerEntry.key),
                                            ),
                                          ],),
                                        ),
                                        Spacer(),
                                        TextButton(
                                          onPressed: () => togglePermissionGroup(outerEntry.key),
                                          child: Text(isAllSelected ? "Deselect All" : "Select All"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (expandedGroups[outerEntry.key] == true) Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    elevation: 4,
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(4.0),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final itemWidth =
                                              (constraints.maxWidth - 12) / 2;
                                          return Wrap(
                                            spacing: 12,
                                            runSpacing: 12,
                                            children: outerEntry.value.entries
                                                .map((innerEntry) {
                                              return SizedBox(
                                                width: itemWidth,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Checkbox(
                                                      value: controller.permissionStatus[outerEntry.key]?[innerEntry.key] ?? false,
                                                      onChanged: (value) {
                                                        controller.permissionStatus[outerEntry.key]?[innerEntry.key] = value ?? false;
                                                        controller.update(['employee_permissions']);
                                                      },
                                                      visualDensity: VisualDensity.comfortable,
                                                    ),

                                                    Expanded(child: Text(innerEntry.value)),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        },
                                      ),


                                      // Wrap(
                                      //   spacing: 4,
                                      //   runSpacing: 4,
                                      //   children: outerEntry.value.entries.map((innerEntry) {
                                      //     return SizedBox(
                                      //       width: (MediaQuery.of(context).size.width - 48) / 2,
                                      //       child: Row(
                                      //         mainAxisSize: MainAxisSize.min,
                                      //         children: [
                                      //           Checkbox(value: true, onChanged: (value){}),
                                      //           Expanded(child: Text(innerEntry.value)),
                                      //         ],
                                      //       ),
                                      //     );
                                      //   }).toList(),
                                      // ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomButton(
        text: widget.user != null ? "Update" : "Add Now",
        marginHorizontal: 20,
        marginVertical: 10,
        onTap: () {
          if (formKey.currentState!.validate()) {
            if (widget.user != null) {
              controller.editEmployee(
                employee: widget.user!,
                name: name.text,
                phoneNo: phoneNo.text,
                address: address.text,
                allowLogin: allowLogin ? 1 : 0,
                email: email.text,
                photo: fileName,
                password: pass.text,
                confirmPassword: confirmPass.text,
              );
            } else {
              controller.addNewEmployee(
                name: name.text,
                phoneNo: phoneNo.text,
                address: address.text,
                allowLogin: allowLogin ? 1 : 0,
                email: email.text,
                photo: fileName,
                password: pass.text,
                confirmPassword: confirmPass.text,
              );
            }
          }
        },
      ),
    );
  }
}
