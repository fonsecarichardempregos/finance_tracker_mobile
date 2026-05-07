import 'package:finance_tracker_app/models/user_model.dart';



class ExpenseByCategoryModel {
  ExpenseByCategoryModel();

  num? categoryId;
  String? name;
  String? icon;
  String? color;
  num? amount;
  num? percent;


  ExpenseByCategoryModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    name = json['name'];
    icon = json['icon'];
    color = json['color'];
    amount = json['amount'];
    percent = json['percent'];

  }

  @override
  String toString() {
    return 'ExpenseByCategoryModel{categoryId: $categoryId, name: $name, icon: $icon, color: $color, amount: $amount, percent: $percent}';
  }
}
