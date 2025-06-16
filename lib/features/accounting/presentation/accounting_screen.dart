import 'package:amar_pos/core/widgets/reusable/forbidden_access_full_screen_widget.dart';
import 'package:amar_pos/features/accounting/presentation/accounting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../drawer/drawer_menu_controller.dart';

class AccountingScreen extends StatefulWidget {
  const AccountingScreen({super.key});

  @override
  State<AccountingScreen> createState() => _AccountingScreenState();
}

class _AccountingScreenState extends State<AccountingScreen> {

  late final AccountingController _controller;


  @override
  void initState() {
    _controller = Get.put(AccountingController());
    super.initState();
  }
  @override
  void dispose() {
    Get.delete<AccountingController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DrawerMenuController drawerMenuController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: AppBar(
          title: const Text('Accounting'),
          centerTitle: true,
          leading: DrawerButton(
            onPressed: () async {
              drawerMenuController.openDrawer();
            },
          ),
        ),
      ),
      body: GetBuilder<AccountingController>(
          id: 'permission_handler_builder',
          builder: (controller) {
            if(controller.accounting.isEmpty){
              return const ForbiddenAccessFullScreenWidget();
            }
          return GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 166/53,
            children: <Widget>[
              ...controller.accounting.map((e) => GestureDetector(
                onTap: e.onPress,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: const Color(0xffFF9000), width: .5)
                    ),
                    child: Center(child: Text(e.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),))),
              ),)
            ],
          );
        }
      )
    );
  }
}
