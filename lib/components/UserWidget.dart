import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:local_delivery_admin/main.dart';
import 'package:local_delivery_admin/models/UserModel.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';

class UserWidget extends StatefulWidget {
  @override
  UserWidgetState createState() => UserWidgetState();
}

class UserWidgetState extends State<UserWidget> {
  int currentPage = 1;
  int totalPage = 1;
  int currentIndex = 1;

  List<UserModel> userData = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
      getUserListApiCall();
    });
  }

  getUserListApiCall() async {
    appStore.setLoading(true);
    await getAllUserList(type: CLIENT, page: currentPage).then((value) {
      totalPage = value.pagination!.totalPages!;
      userData.clear();
      userData.addAll(value.data!);
      setState(() {});
    }).catchError((error) {
      log(error);
    });
    appStore.setLoading(false);
  }

  updateStatusApiCall(UserModel userData) async {
    Map req = {
      "id": userData.id,
      "status": userData.status == 1 ? 0 : 1,
    };
    appStore.setLoading(true);
    await updateUserStatus(req).then((value) {
      appStore.setLoading(false);
      getUserListApiCall();
      toast(value.message.toString());
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  deleteUserApiCall(int id) async {
    Map req = {"id": id};
    appStore.setLoading(true);
    await deleteUser(req).then((value) {
      appStore.setLoading(false);
      getUserListApiCall();
      toast(value.message.toString());
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  restoreUserApiCall({@required int? id, @required String? type}) async {
    Map req = {"id": id, "type": type};
    appStore.setLoading(true);
    await userAction(req).then((value) {
      appStore.setLoading(false);
      getUserListApiCall();
      toast(value.message.toString());
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            controller: ScrollController(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language.users, style: boldTextStyle(size: 20, color: primaryColor)),
                SizedBox(height: 16),
                userData.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(color: appStore.isDarkMode ? scaffoldColorDark : Colors.white, borderRadius: BorderRadius.circular(defaultRadius), boxShadow: commonBoxShadow()),
                            child: SingleChildScrollView(
                              controller: ScrollController(),
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minWidth: getBodyWidth(context) - 48),
                                child: DataTable(
                                  dataRowHeight: 45,
                                  headingRowHeight: 45,
                                  horizontalMargin: 16,
                                  headingRowColor: MaterialStateColor.resolveWith((states) => primaryColor.withOpacity(0.1)),
                                  showCheckboxColumn: false,
                                  dataTextStyle: primaryTextStyle(size: 14),
                                  headingTextStyle: boldTextStyle(),
                                  columns: [
                                    DataColumn(label: Text(language.id)),
                                    DataColumn(label: Text(language.name)),
                                    DataColumn(label: Text(language.email_id)),
                                    DataColumn(label: Text(language.city)),
                                    DataColumn(label: Text(language.country)),
                                    DataColumn(label: Text(language.register_date)),
                                    DataColumn(label: Text(language.status)),
                                    DataColumn(label: Text(language.actions)),
                                  ],
                                  rows: userData.map((e) {
                                    return DataRow(cells: [
                                      DataCell(Text('${e.id}')),
                                      DataCell(Text(e.name ?? "-")),
                                      DataCell(Text(e.email ?? "-")),
                                      DataCell(Text(e.cityName ?? "-")),
                                      DataCell(Text(e.countryName ?? "-")),
                                      DataCell(Text(printDate(e.createdAt ?? ""))),
                                      DataCell(
                                        TextButton(
                                          child: Text(e.status == 1 ? language.enable : language.disable, style: primaryTextStyle(color: e.status == 1 ? primaryColor : Colors.red)),
                                          onPressed: () {
                                            commonConfirmationDialog(context, e.status == 1 ? DIALOG_TYPE_DISABLE : DIALOG_TYPE_ENABLE, () {
                                              if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                toast(language.demo_admin_msg);
                                              } else {
                                                Navigator.pop(context);
                                                updateStatusApiCall(e);
                                              }
                                            }, title: e.status != 1 ? language.enable_user : language.disable_user, subtitle: e.status != 1 ? language.do_you_want_to_enable_this_user : language.do_you_want_to_disable_this_user);
                                          },
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            if (e.deletedAt != null)
                                              Row(
                                                children: [
                                                  OutlineActionIcon(Icons.restore, Colors.green, language.restore, () {
                                                    commonConfirmationDialog(context, DIALOG_TYPE_RESTORE, () {
                                                      if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                        toast(language.demo_admin_msg);
                                                      } else {
                                                        Navigator.pop(context);
                                                        restoreUserApiCall(id: e.id, type: RESTORE);
                                                      }
                                                    }, title: language.restore_user, subtitle: language.restore_user_msg);
                                                  }),
                                                  SizedBox(width: 8),
                                                ],
                                              ),
                                            OutlineActionIcon(e.deletedAt == null ? Icons.delete : Icons.delete_forever, Colors.red, '${e.deletedAt == null ? language.delete : language.force_delete}', () {
                                              commonConfirmationDialog(context, DIALOG_TYPE_DELETE, () {
                                                if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                  toast(language.demo_admin_msg);
                                                } else {
                                                  Navigator.pop(context);
                                                  e.deletedAt == null ? deleteUserApiCall(e.id!) : restoreUserApiCall(id: e.id, type: FORCE_DELETE);
                                                }
                                              }, isForceDelete: e.deletedAt != null, title: language.delete_user, subtitle: language.delete_user_msg);
                                            }),
                                          ],
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          paginationWidget(
                            currentPage: currentPage,
                            totalPage: totalPage,
                            onUpdate: (value) {
                              currentPage = value;
                              init();
                            },
                          ),
                        ],
                      )
                    : SizedBox(),
                SizedBox(height: 50),
              ],
            ),
          ),
          appStore.isLoading
              ? loaderWidget()
              : userData.isEmpty
                  ? emptyWidget()
                  : SizedBox()
        ],
      ),
    );
  }
}
