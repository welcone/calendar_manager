
/// PO 数据类，用于存储订单数据
class PoOrder {
   String phoneNumber;
  String name;
  String roomLable;
  /// 账号来源
  String channel_account;
  /// 平台来源
  String channel_cloud;
  ///
  DateTime dateTimeIn;
  DateTime dateTimeOut;
  /// 平台扣费
  double rate;
  /// 实际收入
  double income;
  String note;




   @override
   String toString() {
     return 'PoOrder{phoneNumber: $phoneNumber, name: $name, roomLable: $roomLable, channel_account: $channel_account, channel_cloud: $channel_cloud, dateTimeIn: $dateTimeIn, dateTimeOut: $dateTimeOut, rate: $rate, income: $income, note: $note}';
   }


}