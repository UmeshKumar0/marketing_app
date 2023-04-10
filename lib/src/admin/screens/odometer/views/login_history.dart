import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginHistory extends StatelessWidget {
  const LoginHistory({super.key});
  static String routeName = '/admin/odometer/login-history';
  @override
  Widget build(BuildContext context) {
    // List<Login> login = Get.arguments as List<Login>;
    var login = Get.arguments;
    
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Login History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: login == null || login.isEmpty
          ? Container(
              alignment: Alignment.center,
              child: const Text('No login history found'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: login.length,
                    itemBuilder: (context, index) {
                      print(login[index].toJson());
                      return ListTile(
                        tileColor: login[index].actionType == 'login'
                            ? Colors.green[100]
                            : Colors.red[100],
                        title: Text(login[index].device as String),
                        subtitle: Text(
                          DateTime.fromMillisecondsSinceEpoch(login[index].time)
                              .toString()
                              .split('.')
                              .first,
                        ),
                        leading: const Icon(Icons.device_hub),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
