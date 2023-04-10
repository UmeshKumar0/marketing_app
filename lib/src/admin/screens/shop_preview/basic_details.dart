import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/controller/spreview_controller.dart';
import 'package:marketing/src/admin/models/Ashop_model.dart';

class SBasicDetails extends StatelessWidget {
  SBasicDetails({
    super.key,
    required this.shops,
    required this.aShopController,
  });
  AShop shops;
  SpreviewController aShopController;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConfig.lightBG,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: shops.profile == null
                      ? const Icon(Icons.factory_rounded)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            '${AppConfig.SERVER_IP}/${shops.profile!.thumbnail}',
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Obx(() {
                  return aShopController.editingMode.isTrue
                      ? Expanded(
                          child: TextField(
                            controller: aShopController.shopNameController,
                            decoration: const InputDecoration(
                              hintText: 'Shop Name',
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        )
                      : Flexible(
                          child: Text(
                            '${shops.name}',
                            style: const TextStyle(
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                })
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Obx(() {
            return aShopController.editingMode.isTrue
                ? Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.key,
                          color: Colors.green,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: aShopController.cpCodeController,
                            decoration: const InputDecoration(
                              hintText: 'Create Shop Cp Code',
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container();
          }),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 10,
                ),
                Obx(() {
                  return aShopController.editingMode.isTrue
                      ? Expanded(
                          child: TextField(
                            controller: aShopController.addressController,
                            decoration: const InputDecoration(
                              hintText: 'Shop Address',
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        )
                      : Flexible(
                          child: Text(
                            '${shops.address}',
                            style: const TextStyle(
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                })
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  Icons.production_quantity_limits,
                  color: AppConfig.primaryColor8,
                ),
                const SizedBox(
                  width: 10,
                ),
                Obx(() {
                  return aShopController.editingMode.isTrue
                      ? Expanded(
                          child: TextField(
                            controller: aShopController.productController,
                            decoration: const InputDecoration(
                              hintText: 'Shop Products',
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        )
                      : Text(
                          shops.products!.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        );
                })
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(
                  Icons.phone,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 10,
                ),
                Obx(() {
                  return aShopController.editingMode.isTrue
                      ? Expanded(
                          child: TextField(
                            controller: aShopController.phoneController,
                            decoration: const InputDecoration(
                              hintText: 'Shop Phone',
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        )
                      : Flexible(
                          child: Text(
                            '${shops.phone}',
                            style: const TextStyle(
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                })
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(
                  Icons.email,
                  color: Colors.blue,
                ),
                const SizedBox(
                  width: 10,
                ),
                Obx(() {
                  return aShopController.editingMode.isTrue
                      ? Expanded(
                          child: TextField(
                            controller: aShopController.emailController,
                            decoration: const InputDecoration(
                              hintText: 'Shop Email',
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        )
                      : Flexible(
                          child: Text(
                            '${shops.email}',
                            style: const TextStyle(
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                })
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.purple,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '${shops.ownerName}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(
                  Icons.star_outline_sharp,
                  color: Colors.purple,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '${shops.status}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(
                  Icons.date_range,
                  color: Colors.purple,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  shops.createdAt == null
                      ? 'Not Found'
                      : shops.createdAt!.split('T').first,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: AppConfig.primaryColor5,
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    shops.createdBy == null
                        ? 'Not Found'
                        : '${shops.createdBy!.name} -> ${shops.createdBy!.role}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
