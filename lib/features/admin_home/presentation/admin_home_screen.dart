import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/features/admin_home/bloc/admin_home_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_home/bloc/admin_home_state.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

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
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: BlocBuilder<AdminHomeCubit, AdminHomeState>(
            buildWhen: (previous, current) =>
                current is GetGraphDataSuccessState ||
                current is GetGraphDataFailedState ||
                current is GetGraphDataLoadingState,
            builder: (context, state) {
              if (state is GetGraphDataLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is GetGraphDataFailedState) {
                return const Center(
                  child: Text('Graph Failed State'),
                );
              }

              if (state is GetGraphDataSuccessState) {
                final statistics = state.graphModel.statistics;

// Create a list of FlSpot to hold our data points
                List<FlSpot> spots = [];

// Extract all keys (dates) and find the minimum date
                final List<DateTime> dates = statistics.keys
                    .map((dateString) => DateTime.parse(dateString))
                    .toList();
                DateTime? minDate = dates.isNotEmpty
                    ? dates.reduce((a, b) => a.isBefore(b) ? a : b)
                    : null;

                if (minDate != null) {
                  statistics.forEach((dateString, values) {
                    // Parse the date string into a DateTime object
                    DateTime date = DateTime.parse(dateString);
                    // Calculate yValue based on the number of days from the minimum date
                    double yValue = date.difference(minDate).inDays.toDouble();

                    for (var stat in values) {
                      // Convert orderValue to double for the xValue
                      double xValue = double.tryParse(stat.orderValue) ?? 0.0;
                      // Add the FlSpot to the list
                      spots.add(FlSpot(xValue, yValue));
                    }
                  });
                }
                return SizedBox(
                    height: 800,
                    width: double.maxFinite,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            barWidth: 2,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blue.withOpacity(0.3),
                            ),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                // Convert the xValue back to a date using the minDate
                                DateTime date =
                                    minDate!.add(Duration(days: value.toInt()));
                                return Transform.rotate(
                                  angle: 1.5708,
                                  child: Text(
                                    "${date.toLocal()}".split(' ')[0],
                                    // Show date in "YYYY-MM-DD" format
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                        ),
                      ),
                    ));
              }

              return const Center(
                child: Text('default state'),
              );
            },
          ),
        ),
      ],
    );
  }
}
