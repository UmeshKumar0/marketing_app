// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/settings_controller.dart';
import 'package:marketing/src/user/controller/shop_controller.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/widgets/connection_status.dart';
import 'package:marketing/src/user/widgets/shop_item.dart';

class ShopPage extends StatefulWidget {
  ShopController shopController;
  ShopPage({
    Key? key,
    required this.shopController,
  }) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  static const _pageSize = 15;
  late PagingController<int, Shops> _pagingController;
  late SettingController _settingController;
  @override
  void initState() {
    super.initState();

    _settingController = Get.find<SettingController>();

    _pagingController = PagingController(firstPageKey: 0);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchData(pageKey: pageKey);
    });
  }

  _fetchData({required int pageKey}) async {
    try {
      List shops = await widget.shopController.getShops(
        name: '',
        skip: (pageKey / _pageSize).toString(),
        limit: _pageSize.toString(),
      );
      if (shops.length < _pageSize) {
        _pagingController.appendLastPage(shops as List<Shops>);
      } else {
        _pagingController.appendPage(
          shops as List<Shops>,
          pageKey + shops.length,
        );
      }
    } on HttpException catch (e) {
      _pagingController.error = e.message;
      if (e.message == 'TOKEN_EXPIRE') {
        _settingController.messageDialogue(
          context: context,
          errorMessage: e.message,
          callback: () {
            _fetchData(pageKey: pageKey);
          },
        );
      }
    } catch (e) {
      _pagingController.error = e.toString();
      _settingController.messageDialogue(
        context: context,
        errorMessage: e.toString(),
        callback: () {
          _fetchData(pageKey: pageKey);
        },
      );
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ConnectionStatus(),
        Expanded(
          child: Container(
            color: AppConfig.lightBG,
            child: RefreshIndicator(
              child: PagedListView(
                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Shops>(
                  itemBuilder: (context, item, index) {
                    return ShopItem(item: item);
                  },
                ),
              ),
              onRefresh: () => Future.sync(
                () => _pagingController.refresh(),
              ),
            ),
          ),
        ),
        GetX<StorageController>(
          builder: (storage) {
            return storage.userModel.value.user!.role == 'ADMIN'
                ? Container()
                : Container(
                    color: AppConfig.lightBG,
                    height: 75,
                    // color: AppConfig.lightBG,
                  );
          },
        )
      ],
    );
  }
}
