import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tzens/app/controllers/auth_controller.dart';
import 'package:tzens/app/controllers/content_controller.dart';
import 'package:tzens/app/data/models/organization_model_model.dart';
import 'package:tzens/app/modules/home_provider/views/home_provider_view.dart';
import 'package:tzens/app/utils/constant/color.dart';
import 'package:tzens/app/utils/function/SnackBar.dart';
import 'package:tzens/app/utils/widget/Form_Widget.dart';
import 'package:tzens/app/utils/widget/dynamic_form_one_field.dart';
import 'package:tzens/app/utils/widget/dynamic_form_two_field.dart';
import 'package:tzens/app/utils/widget/large_button.dart';
import 'package:tzens/app/utils/widget/pick_image.dart';
import '../controllers/add_organisasi_controller.dart';

class AddOrganisasiView extends StatelessWidget {
  final OrganizationModel model;

  const AddOrganisasiView({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddOrganisasiController());
    final content = Get.find<ContentController>();
    final authC = Get.find<AuthController>();

    if (model.id != null) {
      controller.titleController.value.text = model.title ?? "";
      controller.descriptionController.value.text = model.description ?? "";
      controller.startDate.value.text = model.openRecruitment!.startDate ?? "";
      controller.endDate.value.text = model.openRecruitment!.endDate ?? "";
      controller.linkController.value.text = model.link ?? "";
      controller.listDivisionController.assignAll(
        model.division != null
            ? model.division!.map((e) => TextEditingController(text: e))
            : [],
      );
      controller.listContactNameController.assignAll(
        model.contact != null
            ? model.contact!.map((e) => TextEditingController(text: e.name))
            : [],
      );
      controller.listContactPhoneController.assignAll(
        model.contact != null
            ? model.contact!.map((e) => TextEditingController(text: e.phone))
            : [],
      );
    }

    return Hero(
      tag: 'add_organisasi',
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
          title: const Text("Add Organisasi"),
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

                // Mengupload Gambar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Gambar
                      Text(
                        'Upload Image',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //Mengambil Gambar
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
                        image: Obx(
                          () => controller.imageFile.value != null &&
                                  controller.imageFile.value!.path != ""
                              ? Image.file(
                                  File(controller.imageFile.value!.path),
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.image),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      // Title
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
                        hintText: "Title",
                        controller: controller.titleController.value,
                      ),

                      SizedBox(height: 20),

                      //Description
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

                      // Divisi
                      Text(
                        "Divisi (Optional)",
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
                          name: "Divisi",
                          controller: controller,
                          itemCount: controller.totalDivision.value,
                          nameController: controller.listDivisionController,
                          onPressedTrue: () {
                            controller.listDivisionController
                                .add(TextEditingController());
                            controller.benefitIncrement();
                            controller.update();
                            print(controller.totalDivision.value);
                          },
                        ),
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
                      FormText(
                        icon: Icon(Icons.link),
                        hintText: "Link",
                        controller: controller.linkController.value,
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      // Date
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
                      Row(
                        children: [
                          Expanded(
                            child: FormText(
                              keyboardType: TextInputType.none,
                              hintText: "Start Date",
                              controller: controller.startDate.value,
                              icon: Icon(Icons.calendar_today),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2090),
                                  initialDate: controller.selectedDate,
                                );

                                if (pickedDate != null) {
                                  controller.startDate.value.text =
                                      DateFormat.yMd().format(pickedDate);
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

                          // End Date
                          Expanded(
                            child: // End Date
                                FormText(
                              keyboardType: TextInputType.none,
                              hintText: "End Date",
                              controller: controller.endDate.value,
                              icon: Icon(Icons.calendar_today),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2090),
                                  initialDate: controller.selectedDate,
                                );

                                if (pickedDate != null) {
                                  controller.endDate.value.text =
                                      DateFormat.yMd().format(pickedDate);
                                }
                              },
                            ),
                          )
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
                      SizedBox(
                        height: 10,
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
              // Add Date
              Map<String, dynamic> addDate() {
                Map<String, dynamic> date = {
                  "startDate": controller.startDate.value.text,
                  "endDate": controller.endDate.value.text,
                };

                return date;
              }

              // Add Contact
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

              if (controller.pickedFile == null ||
                  controller.pickedFile?.path == "" ||
                  controller.titleController.value.text.isEmpty ||
                  controller.descriptionController.value.text.isEmpty ||
                  controller.startDate.value.text.isEmpty ||
                  controller.endDate.value.text.isEmpty ||
                  controller.listContactNameController[0].text.isEmpty) {
                CustomSnackBar(
                  "Empty Data",
                  "You must fill all of the datas except the optional data",
                  Icons.warning,
                  Colors.red,
                );
                return;
              }

              try {
                // Upload Image
                await content.uploadImage(controller.imageFile.value!,
                    controller.titleController.value.text, "organization");

                if (content.isEdit.value == true) {
                  content.updateOrganization(
                    model.id!,
                    authC.user.toJson(),
                    controller.listDivisionController.isNotEmpty
                        ? controller.listDivisionController
                            .map((e) => e.text)
                            .toList()
                        : [],
                    DateTime.now().toString(),
                    addContact(),
                    controller.descriptionController.value.text,
                    controller.linkController.value.text,
                    addDate(),
                    content.picLink.value,
                    controller.titleController.value.text,
                  );

                  content.isEdit.value = false;
                } else {
                  // Add Data
                  print(
                      'TitleController: ${controller.titleController.value.text}');
                  print(
                      'DescriptionController: ${controller.descriptionController.value.text}');
                  print(
                      'LinkController: ${controller.linkController.value.text}');
                  print(
                      'DateController: ${controller.dateController.value.text}');
                  print(
                      'StartDateController: ${controller.startDateController.value.text}');
                  print(
                      'EndDateController: ${controller.endDateController.value.text}');
                  print(
                      'ListDivisionController: ${controller.listDivisionController.map((e) => e.value.text)}');
                  print(
                      'ListContactNameController: ${controller.listContactNameController.map((e) => e.value.text)}');
                  print(
                      'ListContactPhoneController: ${controller.listContactPhoneController.map((e) => e.value.text)}');

                  // Kemudian panggil fungsi
                  content.addOrganization(
                    authC.user.toJson(),
                    controller.listDivisionController.isNotEmpty
                        ? controller.listDivisionController
                            .map((e) => e.value.text)
                            .toList()
                        : [],
                    DateTime.now().toString(),
                    addContact(),
                    controller.descriptionController.value.text,
                    controller.linkController.value.text,
                    addDate(),
                    content.picLink.value,
                    controller.titleController.value.text,
                  );
                }

                CustomSnackBar(
                  "Success",
                  "Data has been added",
                  Icons.check,
                  Colors.green,
                );

                Get.to(() => HomeProviderView());
              } catch (e) {
                print("ERROR ADD ORGANISASI: $e");
              }
            },
          ),
        ),
      ),
    );
  }
}
