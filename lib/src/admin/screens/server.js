const { mkdir, writeFile, } = require('node:fs/promises');



const createController = (name) => {
    if (name.includes('_')) {
        name = name.split('_').map((word) => `${word[0]}`.toUpperCase() + word.slice(1)).join('');
    } else {
        name = `${name[0]}`.toUpperCase() + name.slice(1);
    }
    let data = `
import 'package:get/get.dart';
class ${name}Controller extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
`;
    return {
        name: `${name}Controller.dart`,
        data,
    };
}


const createView = (appname, name) => {
    if (name.includes('_')) {
        name = name.split('_').map((word) => `${word[0]}`.toUpperCase() + word.slice(1)).join('');
    } else {
        name = `${name[0]}`.toUpperCase() + name.slice(1);
    }
    let data = `
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/${name}Controller.dart';
class ${name}Views extends GetView<${name}Controller> {
  const ${name}Views({super.key});
  static String routeName = '/admin/${`${name}`.toLowerCase()}';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          '${name}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

`;
    return {
        name: `${name}View.dart`,
        data,
    }
}
const main = async () => {

    let routes = process.argv.slice(2)
    if (routes.length > 2) {
        console.log('Please enter only one route')
        return
    } else {
        let appname = routes[0];
        let route = routes[1];
        let meta = createController(route);
        await mkdir(`${route}/controller`, {
            recursive: true,
        });
        console.log('Folder created with name: ', `${route}/controller`)
        await writeFile(`${route}/controller/${meta.name}`, meta.data, {
            encoding: 'utf-8',
        });
        console.log('File created with name: ', `${route}/controller/${meta.name}`)
        meta = createView(appname, route);
        await mkdir(`${route}/views`, {
            recursive: true,
        });
        console.log('Folder created with name: ', `${route}/views`)
        await writeFile(`${route}/views/${meta.name}`, meta.data, {
            encoding: 'utf-8',
        });
        console.log('File created with name: ', `${route}/views/${meta.name}`)

    }

};


main();






