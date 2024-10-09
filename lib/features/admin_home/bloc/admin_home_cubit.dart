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
    return DateTimeRange(start: lastWeek, end: today);
  }

  List<dynamic> calculateSpotsAndMaxOrderValue(
      Map<String, List<Statistic>> statistics) {
    print("calculateSpotsAndMaxOrderValue called");

    List<FlSpot> spots = [];
    double maxOrderValue = 0.0;
    double minOrderValue = double.infinity;

    // Parse the dates and ensure unique dates
    final List<DateTime> dates = statistics.keys
        .map((dateString) => DateTime.parse(dateString))
        .toSet()
        .toList();

    // Sort the dates to prevent duplicates and order them on the X-axis
    dates.sort();

    // Find the minimum date for X-axis reference. Fallback to DateTime.now() if no dates.
    DateTime minDate = dates.isNotEmpty
        ? dates.reduce((a, b) => a.isBefore(b) ? a : b)
        : DateTime.now();

    // Calculate the spots, max and min order values for y-axis adjustments
    for (var dateString in statistics.keys) {
      List<double> dailyOrderValues = statistics[dateString]!
          .map((stat) => double.tryParse(stat.orderValue) ?? 0.0)
          .toList();

      if (dailyOrderValues.isNotEmpty) {
        double dailyMax = dailyOrderValues.reduce((a, b) => a > b ? a : b);
        double dailyMin = dailyOrderValues.reduce((a, b) => a < b ? a : b);

        // Add to FlSpot for plotting
        DateTime currentDate = DateTime.parse(dateString);
        spots.add(FlSpot(
          currentDate.difference(minDate).inDays.toDouble(),
          dailyMax,
        ));

        // Update the overall max and min order values
        if (dailyMax > maxOrderValue) {
          maxOrderValue = dailyMax;
        }
        if (dailyMin < minOrderValue) {
          minOrderValue = dailyMin;
        }
      }
    }

    return [spots, maxOrderValue, minDate];
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
