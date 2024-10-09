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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width / 4,
              child: GestureDetector(
                onTap: () => cubit.startDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: cubit.dateController1,
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width / 4,
              child: GestureDetector(
                onTap: () => cubit.endDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: cubit.dateController2,
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocBuilder<AdminHomeCubit, AdminHomeState>(
                  buildWhen: (previous, current) =>
                      current is GetGraphDataSuccessState,
                  builder: (context, state) {
                    return InfoBox(
                        label: 'Total Sale',
                        value: state is GetGraphDataSuccessState
                            ? state.graphModel.totalSale.toString()
                            : '0');
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                BlocBuilder<AdminHomeCubit, AdminHomeState>(
                  buildWhen: (previous, current) =>
                      current is GetGraphDataSuccessState,
                  builder: (context, state) {
                    return InfoBox(
                        label: 'Total Profit',
                        value: state is GetGraphDataSuccessState
                            ? state.graphModel.totalProfit.toString()
                            : '0');
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20), // Spacing between calendars and boxes

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

              if (state is GetGraphDataSuccessState) {
                final statistics = state.graphModel.statistics;
                final result = cubit.calculateSpotsAndMaxOrderValue(statistics);
                final spots = result[0];
                final minDate =
                    result[2]; // minDate will always have a fallback value now

                return SizedBox(
                  height: 600,
                  width: double.maxFinite,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: false,
                          barWidth: 2,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: false,
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                      ],
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        drawVerticalLine: true,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.withOpacity(0.5),
                          strokeWidth: 1,
                        ),
                        getDrawingVerticalLine: (value) => FlLine(
                          color: Colors.grey.withOpacity(0.5),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          bottom: BorderSide(color: Colors.black, width: 2),
                          left: BorderSide(color: Colors.black, width: 2),
                          right: BorderSide(color: Colors.transparent),
                          top: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          axisNameWidget: const Text(
                            'Dates',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          axisNameSize: 30,
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              // Ensure that minDate is always valid
                              DateTime date =
                                  minDate.add(Duration(days: value.toInt()));
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Transform.rotate(
                                  angle: 1.5708,
                                  child: Text(
                                    "${date.toLocal()}".split(' ')[0],
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          axisNameWidget: const Text(
                            'Order Values',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          axisNameSize: 30,
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SizedBox(
                                  width: 50,
                                  child: Text(
                                    value.toString(),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 10),
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((touchedSpot) {
                              final date = minDate
                                  .add(Duration(days: touchedSpot.x.toInt()));
                              return LineTooltipItem(
                                "Date: ${date.toLocal().toString().split(' ')[0]}\nOrder Value: ${touchedSpot.y}",
                                const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
                );
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

class InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
