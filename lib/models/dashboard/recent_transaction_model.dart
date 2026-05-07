import 'package:finance_tracker_app/models/user_model.dart';

import 'expenses_category_model.dart';


class RecentTransactionModel {
  RecentTransactionModel();

  num? id;
  String? name;
  String? category;
  String? icon;
  String? color;
  num? amount;
  String? type;
  String? date;


  RecentTransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    icon = json['icon'];
    color = json['color'];
    amount = json['amount'];
    type = json['type'];
    date = json['date'];

  }

  @override
  String toString() {
    return 'RecentTransactionModel{id: $id, name: $name, category: $category, icon: $icon, color: $color, amount: $amount, type: $type, date: $date}';
  }
}
