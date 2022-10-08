import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:local_delivery_admin/components/DeliveryOrderAssignWidget.dart';
import 'package:local_delivery_admin/main.dart';
import 'package:local_delivery_admin/models/OrderModel.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/screens/OrderDetailScreen.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';

class OrderWidget extends StatefulWidget {
  @override
  OrderWidgetState createState() => OrderWidgetState();
}

class OrderWidgetState extends State<OrderWidget> {
  int currentPage = 1;
  int totalPage = 1;

  List<OrderModel> orderData = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    afterBuildCreated((){
      appStore.setLoading(true);
      getOrderListApi();
    });
  }

  getOrderListApi() async {
    appStore.setLoading(true);
    await getAllOrder(page: currentPage).then((value) {
      appStore.setLoading(false);

      totalPage = value.pagination!.totalPages!;
      currentPage = value.pagination!.currentPage!;

      orderData.clear();
      orderData.addAll(value.data!);

      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      log(error);
    });
  }

  restoreOrderApiCall({int? orderId, String? type}) async {
    appStore.setLoading(true);
    Map req = {'id': orderId, 'type': type};
    await getRestoreOrderApi(req).then((value) {
      appStore.setLoading(false);
      getOrderListApi();
      toast(value.message);
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  deleteOrderApiCall(int OrderId) async {
    appStore.setLoading(true);
    await deleteOrderApi(OrderId).then((value) {
      appStore.setLoading(false);
      getOrderListApi();
      toast(value.message);
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
            controller: ScrollController(),
            padding: EdgeInsets.all(16),
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language.orders, style: boldTextStyle(size: 20, color: primaryColor)),
                SizedBox(height: 16),
                orderData.isNotEmpty
                    ? Column(
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
                                  headingTextStyle: boldTextStyle(),
                                  dataTextStyle: primaryTextStyle(size: 15),
                                  headingRowColor: MaterialStateColor.resolveWith((states) => primaryColor.withOpacity(0.1)),
                                  showCheckboxColumn: false,
                                  dataRowHeight: 45,
                                  headingRowHeight: 45,
                                  horizontalMargin: 16,
                                  columns: [
                                    DataColumn(label: Text(language.order_id)),
                                    DataColumn(label: Text(language.customer_name)),
                                    DataColumn(label: Text(language.delivery_person)),
                                    DataColumn(label: Text(language.pickup_date)),
                                    DataColumn(label: Text(language.pickup_address)),
                                    DataColumn(label: Text(language.created_date)),
                                    DataColumn(label: Text(language.status)),
                                    DataColumn(label: Text(language.assign)),
                                    DataColumn(label: Text(language.actions)),
                                  ],
                                  rows: orderData.map((e) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text('#${e.id ?? '-'}')),
                                        DataCell(Text('${e.clientName ?? language.user_deleted}',style: primaryTextStyle(color: e.clientName==null ? Colors.red : null))),
                                        DataCell(Text('${e.deliveryManName!=null ? e.deliveryManName : e.status!=ORDER_CREATE ? language.delivery_person_deleted : '-'}',style: primaryTextStyle(color: e.deliveryManName==null&&e.status!=ORDER_CREATE ? Colors.red : null))),
                                        DataCell(e.pickupDatetime != null ? Text(printDate(e.pickupDatetime ?? '')) : Text('-')),
                                        DataCell(e.pickupPoint!.address != null
                                            ? SizedBox(
                                                width: 250,
                                                child: Text('${e.pickupPoint!.address ?? '-'}', overflow: TextOverflow.ellipsis, maxLines: 1),
                                              )
                                            : Text('-')),
                                        DataCell(Text(printDate(e.date ?? ''))),
                                        DataCell(
                                          Container(
                                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                            decoration: BoxDecoration(color: statusColor(e.status ?? "").withOpacity(0.15), borderRadius: BorderRadius.circular(defaultRadius)),
                                            child: Text(orderStatus(e.status ?? '-') ?? '', style: boldTextStyle(color: statusColor(e.status ?? ""), size: 14)),
                                          ),
                                        ),
                                        DataCell(
                                          e.deletedAt == null
                                              ? (e.status == ORDER_COMPLETED || e.status == ORDER_CANCELLED || e.status == ORDER_DRAFT)
                                                  ? Text('${language.order} ${orderStatus(e.status!)}', style: primaryTextStyle(color: primaryColor, size: 15))
                                                  : SizedBox(
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          await showDialog(
                                                            context: context,
                                                            builder: (_) {
                                                              return Dialog(
                                                                child: DeliveryOrderAssignWidget(
                                                                  orderModel: e,
                                                                  OrderId: e.id!,
                                                                  onUpdate: () {
                                                                    getOrderListApi();
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Text((e.status == ORDER_CREATE || e.deliveryManName==null) ? language.assign : language.transfer, style: primaryTextStyle(color: Colors.white,size: 14)),
                                                        style: ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                                                        ),
                                                      ),
                                                    )
                                              : Text(language.order_deleted, style: primaryTextStyle(color: Colors.red, size: 15)),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              if (e.status != ORDER_DRAFT)
                                                OutlineActionIcon(Icons.visibility, primaryColor, language.view, () {
                                                  launchScreen(
                                                    context,
                                                    OrderDetailScreen(orderId: e.id!),
                                                  );
                                                }),
                                              if (e.status != ORDER_DRAFT) SizedBox(width: 8),
                                              if (e.deletedAt != null && e.clientName!=null)
                                                OutlineActionIcon(Icons.restore, primaryColor, language.restore, () async {
                                                  await commonConfirmationDialog(context, DIALOG_TYPE_RESTORE, () {
                                                    if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                      toast(language.demo_admin_msg);
                                                    } else {
                                                      restoreOrderApiCall(orderId: e.id, type: RESTORE);
                                                      getOrderListApi();
                                                      Navigator.pop(context);
                                                    }
                                                  }, title: language.restore_order, subtitle: language.do_you_want_to_restore_this_order);
                                                }),
                                              if(e.deletedAt != null && e.clientName!=null) SizedBox(width: 8),
                                              OutlineActionIcon(e.deletedAt == null ? Icons.delete : Icons.delete_forever, Colors.red, '${e.deletedAt == null ? language.delete : language.force_delete}', () {
                                                commonConfirmationDialog(context, DIALOG_TYPE_DELETE, () {
                                                  if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
                                                    toast(language.demo_admin_msg);
                                                  } else {
                                                    e.deletedAt != null ? restoreOrderApiCall(orderId: e.id, type: FORCE_DELETE) : deleteOrderApiCall(e.id!);
                                                    getOrderListApi();
                                                    Navigator.pop(context);
                                                  }
                                                }, isForceDelete: e.deletedAt != null, title: language.delete_order, subtitle: language.do_you_want_to_delete_this_order);
                                              }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
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
                              getOrderListApi();
                            },
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
          appStore.isLoading
              ? loaderWidget()
              : orderData.isEmpty
                  ? emptyWidget()
                  : SizedBox()
        ],
      ),
    );
  }
}
