import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/admin_home/bloc/admin_home_state.dart';
import 'package:mafatlal_ecommerce/features/admin_home/model/graph_model.dart';
import 'package:mafatlal_ecommerce/features/admin_home/repo/admin_home_repo.dart';

class AdminHomeCubit extends Cubit<AdminHomeState> {
  AdminHomeCubit() : super(AdminHomeInitial());
  TextEditingController dateController1 = TextEditingController();
  TextEditingController dateController2 = TextEditingController();
  final PageController homePageController =
      PageController(initialPage: 0, keepPage: false);

  DateTime? todate;
  DateTime? fromDate;

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
      fromDate = dateRange.start;
      todate = dateRange.end;
      dateController1.text = DateFormat("dd MMM, yyyy").format(fromDate!);
      dateController2.text = DateFormat("dd MMM, yyyy").format(todate!);
      final fromDateString = DateFormat("yyyy-MM-dd").format(fromDate!);
      final endDate = todate!.add(const Duration(days: 1));
      final toDateString = DateFormat("yyyy-MM-dd")
          .format(DateTime(endDate.year, endDate.month, endDate.day));
      final result = await AdminHomeRepository.fetchOrderStats(fromDateString,
          CubitsInjector.authCubit.currentUser!.id, toDateString);
      emit(GetGraphDataSuccessState(graphModel: result.data!));
    } on Exception catch (e) {
      emit(GetGraphDataFailedState(message: e.toString()));
    }
  }

  fetchDataAccordingtoDate() async {
    try {
      emit(GetGraphDataLoadingState());
      final fromDateString = DateFormat("yyyy-MM-dd").format(fromDate!);
      final endDate = todate!.add(const Duration(days: 1));
      final toDateString = DateFormat("yyyy-MM-dd")
          .format(DateTime(endDate.year, endDate.month, endDate.day));
      final result = await AdminHomeRepository.fetchOrderStats(fromDateString,
          CubitsInjector.authCubit.currentUser!.id, toDateString);
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
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      fromDate = picked;
      dateController1.text = DateFormat("dd MMM, yyyy")
          .format(fromDate!); // Set the date to the TextField
      if (fromDate != null && todate != null) {
        fetchDataAccordingtoDate();
      }
    }
  }

  Future<void> endDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: todate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      todate = picked;

      dateController2.text = DateFormat("dd MMM, yyyy").format(todate!);
      if (fromDate != null && todate != null) {
        fetchDataAccordingtoDate();
      }
    }
  }
}
