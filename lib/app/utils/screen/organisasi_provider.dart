import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tzens/app/controllers/content_controller.dart';
import 'package:tzens/app/data/models/organization_model_model.dart';
import 'package:tzens/app/modules/addOrganisasi/views/add_organisasi_view.dart';
import 'package:tzens/app/modules/detailPageOrganisasi/views/detail_page_organisasi_view.dart';
import 'package:tzens/app/modules/home_provider/controllers/home_provider_controller.dart';

class OrganisasiProvider extends StatelessWidget {
  const OrganisasiProvider(
      {super.key, required this.organisasi, required this.controller});
  final ContentController organisasi;
  final HomeProviderController controller;

  @override
  Widget build(BuildContext context) {
    // Call readDataOrganization and ensure data is fetched
    organisasi.readDataOrganization();
    print("PANJANG DATA: ${organisasi.contentListOrganizationProvider.length}");

    return SliverPadding(
      padding:
          EdgeInsets.only(bottom: kToolbarHeight + kFloatingActionButtonMargin),
      sliver: Obx(() => SliverList.builder(
          itemCount: organisasi.contentListOrganizationProvider.length,
          itemBuilder: (context, index) {
            OrganizationModel content =
                organisasi.contentListOrganizationProvider[index];
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () {
                  Get.to(() => DetailPageOrganisasiView(model: content));
                },
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                tileColor: Theme.of(context).colorScheme.secondaryContainer,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(content.photoUrl ?? ''),
                ),
                title: Text(content.title ?? ''),
                subtitle: Text(
                  content.description ?? '',
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  onPressed: () async {
                    controller.onInit();
                    controller.idContent.value = await "${content.id}";
                    print("id = " + "${controller.idContent.value}");
                    Get.bottomSheet(
                      backgroundColor: Colors.white,
                      Container(
                        height: 200,
                        child: ListView(
                          children: [
                            ListTile(
                              onTap: () {
                                organisasi.isEdit.value = true;
                                Get.to(() => AddOrganisasiView(model: content));
                              },
                              title: Text("Edit"),
                              leading: Icon(Icons.edit),
                            ),
                            ListTile(
                              onTap: () {
                                Get.dialog(AlertDialog(
                                  title: Text("Delete"),
                                  content: Text(
                                      "Are you sure you want to delete this item?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        controller.onInit();
                                        controller.update();
                                        print("documentId = " +
                                            "${controller.idContent.value}");

                                        if (controller.idContent.value != "" &&
                                            controller.idContent.isNotEmpty) {
                                          try {
                                            organisasi.deleteDataOrganization(
                                                controller.idContent.value);
                                            controller
                                                .onInit(); // Memperbarui UI setelah penghapusan
                                          } catch (e) {
                                            print("Error deleting data: $e");
                                          }
                                        } else {
                                          print(
                                              "Document ID is empty or null, cannot delete the document.");
                                        }
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        print(
                                            "Deleting document with ID: ${content.id}");
                                        String? documentId = content.id;
                                        if (documentId != null &&
                                            documentId.isNotEmpty) {
                                          try {
                                            await organisasi
                                                .deleteDataOrganization(
                                                    documentId);
                                            controller
                                                .onInit(); // Refresh UI after deletion
                                          } catch (e) {
                                            print("Error deleting data: $e");
                                          }
                                        } else {
                                          print(
                                              "Document ID is empty or null, cannot delete the document.");
                                        }
                                      },
                                      child: Text("Delete"),
                                    ),
                                  ],
                                ));
                              },
                              title: Text("Delete"),
                              leading: Icon(Icons.delete),
                            ),
                            ListTile(
                              title: Text("View"),
                              leading: Icon(Icons.remove_red_eye_rounded),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ),
            );
          })),
    );
  }
}
