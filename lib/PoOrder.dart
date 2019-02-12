/// PO 数据类，用于存储订单数据
class PoOrder {

  // todo-wk 1.2>
  static const roomLabels = [
    '华阳605',
    '文殊院3218',
    '紫金乐章1403',
    '金山花园711',
    '时代天城1504',
    '馨怡家园1303',
    '金巴黎915',
    '怡和新城2409',
    '金巴黎807',
    '馨怡家园2503'
  ];

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
