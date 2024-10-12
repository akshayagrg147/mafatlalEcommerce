import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_home/bloc/admin_home_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_home/bloc/admin_home_state.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late AdminHomeCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<AdminHomeCubit>(context);
    cubit.getGraphdata();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildDateRangePicker(),
            const SizedBox(height: 20),
            _buildInfoBoxes(),
            const SizedBox(height: 20),
            _buildSalesChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return Row(
      children: [
        Expanded(
          child: _buildDateField(
            label: 'Start Date',
            controller: cubit.dateController1,
            onTap: () => cubit.startDate(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDateField(
            label: 'End Date',
            controller: cubit.dateController2,
            onTap: () => cubit.endDate(context),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBoxes() {
    return BlocBuilder<AdminHomeCubit, AdminHomeState>(
      buildWhen: (previous, current) => current is GetGraphDataSuccessState,
      builder: (context, state) {
        if (state is GetGraphDataSuccessState) {
          return Row(
            children: [
              Expanded(
                child: InfoBox(
                  label: 'Total Sale',
                  value: state.graphModel.totalSale.toString(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InfoBox(
                  label: 'Total Profit',
                  value: state.graphModel.totalProfit.toString(),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSalesChart() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: BlocBuilder<AdminHomeCubit, AdminHomeState>(
        buildWhen: (previous, current) => current is GetGraphDataSuccessState,
        builder: (context, state) {
          if (state is GetGraphDataLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetGraphDataSuccessState) {
            final statistics = state.graphModel.statistics;
            final result = cubit.calculateSpotsAndMaxOrderValue(statistics);
            if (result.isEmpty) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                height: 300,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400)),
                child: Center(
                  child: Text(
                    "No Data",
                    style: AppTextStyle.f18PoppinsBlackw400,
                  ),
                ),
              );
            }
            final spots = result[0] as List<FlSpot>;
            final maxOrderValue = result[1] as double;
            final minOrderValue = result[2] as double;
            final minDate = result[3] as DateTime;

            // Ensure we have at least two data points
            // if (spots.length < 2) {
            //   return const Center(child: Text('Not enough data to display chart'));
            // }

            // Calculate the range of x and y values
            final xRange = spots.last.x - spots.first.x;
            final yRange = maxOrderValue - minOrderValue;

            // Ensure intervals are not zero
            final xInterval =
                xRange > 0 ? (xRange / 5).clamp(0.1, double.infinity) : 1.0;
            final yInterval =
                yRange > 0 ? (yRange / 5).clamp(0.1, double.infinity) : 1.0;
            final yAxisInterval =
                calculateYAxisInterval(minOrderValue, maxOrderValue);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: LineChart(
                LineChartData(
                  minY: minOrderValue,
                  maxY: maxOrderValue,
                  minX: spots.first.x,
                  maxX: spots.last.x,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: false,
                      barWidth: 2,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text('Dates'),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          final date =
                              minDate.add(Duration(days: value.toInt()));
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "${date.day}/${date.month}",
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                        interval: xInterval,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: const Text('Order Values'),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        getTitlesWidget: (value, meta) {
                          return Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              meta.formattedValue,
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                        interval: yAxisInterval,
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      // tooltipBgColor: Colors.blueAccent,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          final date = minDate
                              .add(Duration(days: touchedSpot.x.toInt()));
                          return LineTooltipItem(
                            "${date.day}/${date.month}: ${touchedSpot.y.toStringAsFixed(2)}",
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                  ),
                ),
              ),
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  double calculateYAxisInterval(double min, double max) {
    final range = max - min;
    if (range <= 0)
      return 1.0; // Return a default value if range is zero or negative

    final roughInterval = range / 5; // We want about 5 intervals

    // Round to a nice number
    final magnitude =
        math.pow(10, (math.log(roughInterval) / math.ln10).floor());
    final niceInterval = (roughInterval / magnitude).round() * magnitude;

    return (niceInterval as double).clamp(0.1, double.infinity);
  }
}

class InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const InfoBox({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
