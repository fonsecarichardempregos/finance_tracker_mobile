import 'package:finance_tracker_app/models/dashboard/recent_transaction_model.dart';
import 'package:finance_tracker_app/models/user_model.dart';

import 'expenses_category_model.dart';



class DashboardModel {
  DashboardModel();

  String? month;
  num? balance;
  num? monthIncome;
  num? monthExpense;
  num? goalTarget;
  num? goalProgressPercent;
  List<RecentTransactionModel?>? recentTransactions;
  List<ExpenseByCategoryModel?>? expensesByCategory;

  DashboardModel.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    balance = json['balance'];
    monthIncome = json['monthIncome'];
    monthExpense = json['monthExpense'];
    goalTarget = json['goalTarget'];
    goalProgressPercent = json['goalProgressPercent'];
    expensesByCategory = json['expensesByCategory'] != null
        ? (json['expensesByCategory'] as List)
        .map((item) => ExpenseByCategoryModel.fromJson(item))
        .toList()
        : null;

    recentTransactions = json['recentTransactions'] != null
        ? (json['recentTransactions'] as List)
        .map((item) => RecentTransactionModel.fromJson(item))
        .toList()
        : null;

  }

  @override
  String toString() {
    return 'DashboardModel{month: $month, balance: $balance, monthIncome: $monthIncome, monthExpense: $monthExpense, goalTarget: $goalTarget, goalProgressPercent: $goalProgressPercent, recentTransactions: $recentTransactions, expensesByCategory: $expensesByCategory}';
  }
}
