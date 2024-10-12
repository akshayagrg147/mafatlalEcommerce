import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/features/admin_home/bloc/admin_home_state.dart';
import 'package:mafatlal_ecommerce/features/admin_home/model/graph_model.dart';
import 'package:mafatlal_ecommerce/features/admin_home/repo/admin_home_repo.dart';

class AdminHomeCubit extends Cubit<AdminHomeState> {
  AdminHomeCubit() : super(AdminHomeInitial());
  TextEditingController dateController1 = TextEditingController();
  TextEditingController dateController2 = TextEditingController();
  final PageController homePageController =
      PageController(initialPage: 0, keepPage: false);

  void updatePageIndex(int page) {
    if (homePageController.page == page) {
      return;
    }
    homePageController.animateToPage(page,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);

    emit(UpdateDrawerPage(page: page));
  }

  getGraphdata() async {
    try {
      emit(GetGraphDataLoadingState());
      DateTimeRange dateRange = getTodayAndLastWeek();
      dateController1.text = dateRange.start.toString();
      dateController2.text = dateRange.end.toString();
      final result = await AdminHomeRepository.fetchOrderStats(
          dateController1.text.toString(), 15, dateController2.text.toString());
      emit(GetGraphDataSuccessState(graphModel: result.data!));
    } on Exception catch (e) {
      emit(GetGraphDataFailedState(message: e.toString()));
    }
  }

  fetchDataAccordingtoDate() async {
    try {
      emit(GetGraphDataLoadingState());
      final result = await AdminHomeRepository.fetchOrderStats(
          dateController1.text.toString(), 15, dateController2.text.toString());
      emit(GetGraphDataSuccessState(graphModel: result.data!));
    } on Exception catch (e) {
      emit(GetGraphDataFailedState(message: e.toString()));
    }
  }

  DateTimeRange getTodayAndLastWeek() {
    DateTime today = DateTime.now();
    DateTime lastWeek = today.subtract(Duration(days: 7));
    lastWeek = DateTime(lastWeek.year, lastWeek.month, lastWeek.day);
    return DateTimeRange(start: lastWeek, end: today);
  }

  List<dynamic> calculateSpotsAndMaxOrderValue(
      Map<String, List<Statistic>> statistics) {
    print("calculateSpotsAndMaxOrderValue called");

    List<FlSpot> spots = [];
    double maxOrderValue = double.negativeInfinity;
    double minOrderValue = double.infinity;

    // Parse the dates and ensure unique dates with summed order values
    final Map<DateTime, double> dateOrderMap = {};

    for (var dateString in statistics.keys) {
      DateTime currentDate = DateTime.parse(dateString);

      // Sum the daily order values for each date
      double dailyTotalOrderValue = statistics[dateString]!
          .map((stat) => double.tryParse(stat.orderValue) ?? 0.0)
          .reduce((a, b) => a + b);

      // Add or sum the total for each unique date in the map
      dateOrderMap[currentDate] =
          (dateOrderMap[currentDate] ?? 0.0) + dailyTotalOrderValue;

      // Update max and min order values
      maxOrderValue = max(maxOrderValue, dailyTotalOrderValue);
      minOrderValue = min(minOrderValue, dailyTotalOrderValue);
    }

    // Sort the dates
    final List<DateTime> sortedDates = dateOrderMap.keys.toList()..sort();

    if (sortedDates.isNotEmpty) {
      // Find the minimum date
      DateTime minDate = sortedDates.first;

      // Prepare spots for the graph based on summed values
      for (var date in sortedDates) {
        final orderValue = dateOrderMap[date]!;
        spots.add(FlSpot(
          date.difference(minDate).inDays.toDouble(),
          orderValue,
        ));
        print("Date: $date, Value: $orderValue"); // Debug print
      }

      return [spots, maxOrderValue, minOrderValue, minDate];
    }
    return [];
  }

  Future<void> startDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != DateTime.now()) {
      dateController1.text =
          "${picked.toLocal()}".split(' ')[0]; // Set the date to the TextField
    }
  }

  Future<void> endDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != DateTime.now()) {
      dateController2.text = "${picked.toLocal()}".split(' ')[0];
      fetchDataAccordingtoDate();
    }
  }
}
