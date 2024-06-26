import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tzens/app/controllers/auth_controller.dart';
import 'package:tzens/app/controllers/content_controller.dart';
import 'package:tzens/app/data/models/webinar_model_model.dart';
import 'package:tzens/app/modules/home_provider/controllers/home_provider_controller.dart';
import 'package:tzens/app/modules/home_provider/views/home_provider_view.dart';
import 'package:tzens/app/utils/constant/color.dart';
import 'package:tzens/app/utils/widget/Form_Widget.dart';
import 'package:tzens/app/utils/widget/dynamic_form_one_field.dart';
import 'package:tzens/app/utils/widget/dynamic_form_two_field.dart';
import 'package:tzens/app/utils/widget/large_button.dart';
import 'package:tzens/app/utils/widget/pick_image.dart';

import '../controllers/add_controller.dart';

class AddView extends StatelessWidget {
  final AddController controller = Get.put(AddController());
  final WebinarModel model;

  AddView({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final contentC = Get.put(ContentController());
    final homeController = Get.put(HomeProviderController());

    if (model.id != null) {
      controller.titleController.value.text = model.title ?? "";
      controller.descriptionController.value.text = model.description ?? "";
      controller.locationController.value.text = model.location ?? "";
      controller.linkController.value.text = model.link ?? "";
      controller.date.text = model.date ?? "";
      controller.startTime.text = model.time!.startTime ?? "";
      controller.endTime.text = model.time!.endTime ?? "";
      controller.listBenefitController.assignAll(
        model.benefits != null
            ? model.benefits!
                .map((e) => TextEditingController(text: e))
                .toList()
            : [],
      );
      controller.listPrasyaratController.assignAll(
        model.prerequisite != null
            ? model.prerequisite!
                .map((e) => TextEditingController(text: e))
                .toList()
            : [],
      );
      controller.listContactNameController.assignAll(
        model.contact != null
            ? model.contact!
                .map((e) => TextEditingController(text: e.name))
                .toList()
            : [],
      );
    }

    RxString type = controller.eventType[0].obs;

    print(controller.date.text);
    print("PHOTO URL = ${model.photoUrl}");

    if (model.photoUrl != null && model.photoUrl != "") {
      controller.pickedFile = XFile(model.photoUrl!);
    }

    return Hero(
      tag: 'add_event',
      child: Scaffold(
        backgroundColor: customWhite,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text('Add Seminar'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: kBottomNavigationBarHeight,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),

                // Upload Image
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Foto
                      Text(
                        'Upload Image',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      PickImage(
                        controller: controller,
                        height: 300,
                        width: 200,
                        radius: 20,
                        pickImageButton: IconButton(
                          onPressed: () async {
                            await controller.pickImage();
                            print(controller.imageFile.value);
                            print(controller.imageFile.value?.path);
                          },
                          icon: Icon(Icons.add_photo_alternate_outlined),
                        ),
                        image: model.photoUrl == null || model.photoUrl == ""
                            ? Obx(
                                () => controller.imageFile.value != null &&
                                        controller.imageFile.value!.path != ""
                                    ? Image.file(
                                        File(controller.imageFile.value!.path),
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(Icons.image),
                              )
                            : Image.network(
                                model.photoUrl!,
                                fit: BoxFit.cover,
                              ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      /* Title */
                      Text(
                        "Title",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormText(
                        icon: Icon(Icons.title),
                        hintText:
                            model.title == null ? "Title" : "${model.title}",
                        controller: controller.titleController.value,
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      /** DESCRIPTION */
                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormText(
                        hintText: "Description",
                        controller: controller.descriptionController.value,
                        minLines: 5,
                        maxLines: 20,
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      /** LOCATION */
                      Text(
                        "Location",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormText(
                        icon: Icon(Icons.location_on),
                        hintText: "Location",
                        controller: controller.locationController.value,
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      /** EVENT TYPE */
                      Text(
                        "Event Type",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile(
                                      title: Text("Online"),
                                      value: controller.eventType[0],
                                      groupValue: type.value,
                                      onChanged: (value) {
                                        type.value = value.toString();
                                        controller.update();
                                        print(type);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile(
                                      title: Text("Offline"),
                                      value: controller.eventType[1],
                                      groupValue: type.value,
                                      onChanged: (value) {
                                        type.value = value.toString();
                                        controller.update();
                                        print(type);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      /** LINK */
                      Text(
                        "Group Link",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => FormText(
                          icon: Icon(Icons.link),
                          hintText: "Link",
                          controller: controller.linkController.value,
                          enabled: type.value == "Online" ? true : false,
                          onChange: (value) {
                            print(value);
                            controller.linkController.value.text = value;
                            print("LINKNYA" +
                                controller.linkController.value.text);
                          },
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      /** DATE */
                      Text(
                        "Date",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormText(
                        keyboardType: TextInputType.none,
                        hintText: "Date",
                        controller: controller.date,
                        icon: Icon(Icons.calendar_today),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2090),
                          );

                          if (pickedDate != null) {
                            controller.date.text =
                                DateFormat.yMd().format(pickedDate);
                          }
                        },
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      /** TIME */
                      Text(
                        "Time",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          /** START TIME */
                          Expanded(
                            child: FormText(
                              icon: Icon(Icons.access_time),
                              keyboardType: TextInputType.none,
                              hintText: "Start Time",
                              controller: controller.startTime,
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );

                                if (pickedTime != null) {
                                  controller.startTime.text =
                                      pickedTime.format(context);
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("-"),
                          SizedBox(
                            width: 5,
                          ),

                          /** END TIME */
                          Expanded(
                            child: FormText(
                              icon: Icon(Icons.access_time),
                              keyboardType: TextInputType.none,
                              hintText: "End Time",
                              controller: controller.endTime,
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );

                                if (pickedTime != null) {
                                  controller.endTime.text =
                                      pickedTime.format(context);
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                // Benefit
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Benefits (Optional)",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => DynamicFormOneField(
                          icon: Icon(Icons.star_rounded),
                          name: "Benefit",
                          controller: controller,
                          itemCount: controller.totalBenefit.value,
                          nameController: controller.listBenefitController,
                          onPressedTrue: () {
                            controller.listBenefitController
                                .add(TextEditingController());
                            controller.benefitIncrement();
                            controller.update();
                            print(controller.totalBenefit.value);
                          },
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      // Prasyarat
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Prerequisite (Optional)",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Obx(
                            () => DynamicFormOneField(
                              icon: Icon(Icons.source_rounded),
                              name: "Prasyarat",
                              controller: controller,
                              itemCount: controller.totalPrasyarat.value,
                              nameController:
                                  controller.listPrasyaratController,
                              onPressedTrue: () {
                                controller.listPrasyaratController
                                    .add(TextEditingController());
                                controller.prasyaratIncrement();
                                controller.update();
                                print(controller.totalPrasyarat.value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                //  Contact
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Obx(
                        () => DynamicFormTwoField(
                          iconField1: Icon(Icons.contacts_rounded),
                          iconField2: Icon(Icons.phone),
                          controller: controller,
                          itemCount: controller.totalContact.value,
                          textEditingController1:
                              controller.listContactNameController,
                          textEditingController2:
                              controller.listContactPhoneController,
                          increment: controller.contactIncrement,
                          decrement: controller.contactDecrement,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: LargeButton(
            color: WidgetStateColor.resolveWith((states) => primaryColor),
            text: "Confirm",
            onPressed: () async {
              // await contentC.setCollection(Get.currentRoute);

              Map<String, dynamic> addTime() {
                Map<String, dynamic> time = {};

                time.addAll({
                  "endTime": controller.endTime.text,
                  "startTime": controller.startTime.text
                });

                return time;
              }

              List<Map<String, dynamic>> addContact() {
                List<Map<String, dynamic>> contact = [];
                int i = 0;
                while (i < controller.totalContact.value) {
                  contact.add({
                    "name": controller.listContactNameController[i].text,
                    "phone": controller.listContactPhoneController[i].text
                  });
                  i++;
                }
                return contact;
              }

              if (type.value == "Offline") {
                if (controller.pickedFile == null ||
                    controller.pickedFile!.path.isEmpty ||
                    controller.titleController.value.text.isEmpty ||
                    controller.descriptionController.value.text.isEmpty ||
                    controller.locationController.value.text.isEmpty ||
                    controller.date.text.isEmpty ||
                    controller.startTime.text.isEmpty ||
                    controller.endTime.text.isEmpty) {
                  Get.snackbar("Error", "Please fill all the form",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                  return;
                }
              } else {
                if (controller.pickedFile == null ||
                    controller.pickedFile!.path.isEmpty ||
                    controller.titleController.value.text.isEmpty ||
                    controller.descriptionController.value.text.isEmpty ||
                    controller.locationController.value.text.isEmpty ||
                    controller.date.text.isEmpty ||
                    controller.startTime.text.isEmpty ||
                    controller.endTime.text.isEmpty ||
                    controller.linkController.value.text.isEmpty) {
                  Get.snackbar("Error", "Please fill all the form",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                  return;
                }
              }

              try {
                await contentC.uploadImage(File(controller.pickedFile!.path),
                    controller.pickedFile!.name, "webinar");
                print("LINK" + contentC.picLink.value);

                print(controller.pickedFile!.path);
                print(controller.pickedFile!.name);

                print("UserModel: ${auth.user}");
                print("UserModel toJson: ${auth.user.toJson()}");

                if (contentC.isEdit.value == true) {
                  contentC.updateData(
                    model.id!,
                    auth.user.toJson(),
                    controller.listBenefitController.isNotEmpty
                        ? controller.listBenefitController
                            .map((e) => e.text)
                            .toList()
                        : [],
                    DateTime.now().toString(),
                    addContact(),
                    controller.date.text,
                    controller.descriptionController.value.text,
                    controller.linkController.value.text,
                    controller.locationController.value.text,
                    contentC.picLink.value,
                    controller.listPrasyaratController.isNotEmpty
                        ? controller.listPrasyaratController
                            .map((e) => e.text)
                            .toList()
                        : [],
                    type.value,
                    addTime(),
                    controller.titleController.value.text,
                  );

                  contentC.isEdit.value = false;
                } else {
                  contentC.addData(
                    auth.user.toJson(),
                    controller.listBenefitController.isNotEmpty
                        ? controller.listBenefitController
                            .map((e) => e.text)
                            .toList()
                        : [],
                    DateTime.now().toString(),
                    addContact(),
                    controller.date.text,
                    controller.descriptionController.value.text,
                    controller.linkController.value.text,
                    controller.locationController.value.text,
                    contentC.picLink.value,
                    controller.listPrasyaratController.isNotEmpty
                        ? controller.listPrasyaratController
                            .map((e) => e.text)
                            .toList()
                        : [],
                    type.value,
                    addTime(),
                    controller.titleController.value.text,
                  );
                }

                print(addTime());

                Get.to(() => HomeProviderView());
                homeController.onInit();
                homeController.update();

                Get.snackbar("Success", "Data added successfully",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white);
              } catch (e) {
                print("ERROR DISINI" + e.toString());
              }
            },
          ),
        ),
      ),
    );
  }
}
