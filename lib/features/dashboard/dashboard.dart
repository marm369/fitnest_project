import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../common/widgets/buttons/round_button.dart';
import '../../common/widgets/buttons/round_gradient_button.dart';
import '../../utils/constants/colors.dart';
import 'activity_tracker/activity_tracker_screen.dart';

class DashboardScreen extends StatefulWidget {
  static String routeName = "/HomeScreen";

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<int> showingTooltipOnSpots = [21];

  List<FlSpot> get allSpots => const [
        FlSpot(0, 20),
        FlSpot(1, 25),
        FlSpot(2, 40),
        FlSpot(3, 50),
        FlSpot(4, 35),
        FlSpot(5, 40),
        FlSpot(6, 30),
        FlSpot(7, 20),
        FlSpot(8, 25),
        FlSpot(9, 40),
        FlSpot(10, 50),
        FlSpot(11, 35),
        FlSpot(12, 50),
        FlSpot(13, 60),
        FlSpot(14, 40),
        FlSpot(15, 50),
        FlSpot(16, 20),
        FlSpot(17, 25),
        FlSpot(18, 40),
        FlSpot(19, 50),
        FlSpot(20, 35),
        FlSpot(21, 80),
        FlSpot(22, 30),
        FlSpot(23, 20),
        FlSpot(24, 25),
        FlSpot(25, 40),
        FlSpot(26, 50),
        FlSpot(27, 35),
        FlSpot(28, 50),
        FlSpot(29, 60),
        FlSpot(30, 40),
      ];

  List waterArr = [
    {"title": "6am - 8am", "subtitle": "600ml"},
    {"title": "9am - 11am", "subtitle": "500ml"},
    {"title": "11am - 2pm", "subtitle": "1000ml"},
    {"title": "2pm - 4pm", "subtitle": "700ml"},
    {"title": "4pm - now", "subtitle": "900ml"}
  ];

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [
          MyColors.primaryColor2.withOpacity(0.5),
          MyColors.primaryColor1.withOpacity(0.5),
        ]),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 35),
          FlSpot(2, 70),
          FlSpot(3, 40),
          FlSpot(4, 80),
          FlSpot(5, 25),
          FlSpot(6, 70),
          FlSpot(7, 35),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [
          MyColors.secondaryColor2.withOpacity(0.5),
          MyColors.secondaryColor1.withOpacity(0.5),
        ]),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
        ),
        spots: const [
          FlSpot(1, 80),
          FlSpot(2, 50),
          FlSpot(3, 90),
          FlSpot(4, 40),
          FlSpot(5, 80),
          FlSpot(6, 35),
          FlSpot(7, 60),
        ],
      );

  List lastWorkoutArr = [
    {
      "name": "Full Body Workout",
      "image": "assets/images/Workout1.png",
      "kcal": "180",
      "time": "20",
      "progress": 0.3
    },
    {
      "name": "Lower Body Workout",
      "image": "assets/images/Workout2.png",
      "kcal": "200",
      "time": "30",
      "progress": 0.4
    },
    {
      "name": "Ab Workout",
      "image": "assets/images/Workout3.png",
      "kcal": "300",
      "time": "40",
      "progress": 0.7
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: allSpots,
        isCurved: false,
        barWidth: 3,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(colors: [
            MyColors.primaryColor2.withOpacity(0.4),
            MyColors.primaryColor1.withOpacity(0.1),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        dotData: FlDotData(show: false),
        gradient: LinearGradient(
          colors: MyColors.primaryG,
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return Scaffold(
      backgroundColor: MyColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back,",
                          style: TextStyle(
                            color: MyColors.softGrey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "User",
                          style: TextStyle(
                            color: MyColors.black,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          "assets/icons/notification_icon.png",
                          width: 25,
                          height: 25,
                          fit: BoxFit.fitHeight,
                        ))
                  ],
                ),
                SizedBox(height: media.width * 0.05),
                Container(
                  height: media.width * 0.4,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: MyColors.primaryG),
                      borderRadius: BorderRadius.circular(media.width * 0.065)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/bg_dots.png",
                        height: media.width * 0.4,
                        width: double.maxFinite,
                        fit: BoxFit.fitHeight,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "BMI (Body Mass Index)",
                                  style: TextStyle(
                                      color: MyColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "You have a normal weight",
                                  style: TextStyle(
                                    color: MyColors.white.withOpacity(0.7),
                                    fontSize: 12,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: media.width * 0.05),
                                Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: SizedBox(
                                    height: 35,
                                    width: 100,
                                    child: RoundButton(
                                        title: "View More", onPressed: () {}),
                                  ),
                                )
                              ],
                            ),
                            AspectRatio(
                              aspectRatio: 1,
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback: (FlTouchEvent event,
                                        pieTouchResponse) {},
                                  ),
                                  startDegreeOffset: 250,
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 1,
                                  centerSpaceRadius: 0,
                                  sections: showingSections(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: media.width * 0.05),
                Text(
                  "Activity Status",
                  style: TextStyle(
                    color: MyColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: media.width * 0.02),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: media.width * 0.4,
                    width: media.width,
                    decoration: BoxDecoration(
                        color: MyColors.primaryColor2.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25)),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Heart Rate",
                                style: TextStyle(
                                    color: MyColors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: media.width * 0.01),
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                          colors: MyColors.primaryG,
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight)
                                      .createShader(Rect.fromLTRB(
                                          0, 0, bounds.width, bounds.height));
                                },
                                child: Text(
                                  "78 BPM",
                                  style: TextStyle(
                                    color: MyColors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        LineChart(
                          LineChartData(
                            showingTooltipIndicators:
                                showingTooltipOnSpots.map((index) {
                              return ShowingTooltipIndicators([
                                LineBarSpot(
                                  tooltipsOnBar,
                                  lineBarsData.indexOf(tooltipsOnBar),
                                  tooltipsOnBar.spots[index],
                                ),
                              ]);
                            }).toList(),
                            lineTouchData: LineTouchData(
                              enabled: true,
                              handleBuiltInTouches: false,
                              touchCallback: (FlTouchEvent event,
                                  LineTouchResponse? response) {
                                if (response == null ||
                                    response.lineBarSpots == null) {
                                  return;
                                }
                                if (event is FlTapUpEvent) {
                                  final spotIndex =
                                      response.lineBarSpots!.first.spotIndex;
                                  showingTooltipOnSpots.clear();
                                  setState(() {
                                    showingTooltipOnSpots.add(spotIndex);

                                    // if (showingTooltipOnSpots
                                    //     .contains(spotIndex)) {
                                    //   showingTooltipOnSpots.remove(spotIndex);
                                    // } else {
                                    //   showingTooltipOnSpots.add(spotIndex);
                                    // }
                                  });
                                }
                              },
                              mouseCursorResolver: (FlTouchEvent event,
                                  LineTouchResponse? response) {
                                if (response == null ||
                                    response.lineBarSpots == null) {
                                  return SystemMouseCursors.basic;
                                }
                                return SystemMouseCursors.click;
                              },
                              getTouchedSpotIndicator:
                                  (LineChartBarData barData,
                                      List<int> spotIndexes) {
                                return spotIndexes.map((index) {
                                  return TouchedSpotIndicatorData(
                                    FlLine(
                                      color: Colors.transparent,
                                    ),
                                    FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) =>
                                              FlDotCirclePainter(
                                        radius: 3,
                                        color: Colors.white,
                                        strokeWidth: 2,
                                        strokeColor: MyColors.secondaryColor2,
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor: MyColors.secondaryColor1,
                                tooltipRoundedRadius: 20,
                                getTooltipItems:
                                    (List<LineBarSpot> lineBarsSpot) {
                                  return lineBarsSpot.map((lineBarSpot) {
                                    return LineTooltipItem(
                                      //lineBarSpot.y.toString(),
                                      "${lineBarSpot.x.toInt()} mins ago",
                                      const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                            lineBarsData: lineBarsData,
                            minY: 0,
                            maxY: 130,
                            titlesData: FlTitlesData(show: false),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: media.width * 0.05),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: media.width * 0.95,
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 10),
                      decoration: BoxDecoration(
                          color: MyColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 2)
                          ]),
                      child: Row(children: [
                        SimpleAnimationProgressBar(
                          height: media.width * 0.9,
                          width: media.width * 0.07,
                          backgroundColor: Colors.grey.shade100,
                          foregrondColor: Colors.purple,
                          ratio: 0.5,
                          direction: Axis.vertical,
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: const Duration(seconds: 3),
                          borderRadius: BorderRadius.circular(30),
                          gradientColor: LinearGradient(
                              colors: MyColors.primaryG,
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Water Intake",
                              style: TextStyle(
                                  color: MyColors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: media.width * 0.01),
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                        colors: MyColors.primaryG,
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight)
                                    .createShader(Rect.fromLTRB(
                                        0, 0, bounds.width, bounds.height));
                              },
                              child: Text(
                                "4 Liters",
                                style: TextStyle(
                                  color: MyColors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: media.width * 0.03),
                            Text(
                              "Real time updates",
                              style: TextStyle(
                                  color: MyColors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: media.width * 0.01),
                            Column(
                              children: waterArr.map((obj) {
                                var isLast = obj == waterArr.last;
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 6),
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                color: MyColors.secondaryColor1
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                          if (!isLast)
                                            DottedDashedLine(
                                              width: 0,
                                              height: media.width * 0.078,
                                              axis: Axis.vertical,
                                              dashColor: MyColors
                                                  .secondaryColor1
                                                  .withOpacity(0.5),
                                            )
                                        ]),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: media.width * 0.01),
                                        Text(
                                          obj["title"].toString(),
                                          style: TextStyle(
                                              color: MyColors.black,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(height: 1),
                                        ShaderMask(
                                          blendMode: BlendMode.srcIn,
                                          shaderCallback: (bounds) {
                                            return LinearGradient(
                                                    colors: MyColors.secondaryG,
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight)
                                                .createShader(Rect.fromLTRB(
                                                    0,
                                                    0,
                                                    bounds.width,
                                                    bounds.height));
                                          },
                                          child: Text(
                                            obj["subtitle"].toString(),
                                            style: TextStyle(
                                              color: MyColors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }).toList(),
                            )
                          ],
                        ))
                      ]),
                    )),
                    SizedBox(width: media.width * 0.05),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.maxFinite,
                          height: media.width * 0.45,
                          padding: EdgeInsets.symmetric(
                              vertical: 25, horizontal: 20),
                          decoration: BoxDecoration(
                              color: MyColors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 2)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sleep",
                                style: TextStyle(
                                    color: MyColors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: media.width * 0.01),
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                          colors: MyColors.primaryG,
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight)
                                      .createShader(Rect.fromLTRB(
                                          0, 0, bounds.width, bounds.height));
                                },
                                child: Text(
                                  "8h 20m",
                                  style: TextStyle(
                                    color: MyColors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Image.asset(
                                "assets/images/sleep_graph.png",
                                width: double.maxFinite,
                                fit: BoxFit.fitWidth,
                              ))
                            ],
                          ),
                        ),
                        SizedBox(height: media.width * 0.05),
                        Container(
                          width: double.maxFinite,
                          height: media.width * 0.45,
                          padding: EdgeInsets.symmetric(
                              vertical: 25, horizontal: 20),
                          decoration: BoxDecoration(
                              color: MyColors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 2)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Calories",
                                style: TextStyle(
                                    color: MyColors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: media.width * 0.01),
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                          colors: MyColors.primaryG,
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight)
                                      .createShader(Rect.fromLTRB(
                                          0, 0, bounds.width, bounds.height));
                                },
                                child: Text(
                                  "760 kCal",
                                  style: TextStyle(
                                    color: MyColors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: media.width * 0.2,
                                  height: media.width * 0.2,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: media.width * 0.16,
                                        height: media.width * 0.16,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: MyColors.primaryG),
                                            borderRadius: BorderRadius.circular(
                                                media.width * 0.075)),
                                        child: Text("230kCal\nleft",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: MyColors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ),
                                      SimpleCircularProgressBar(
                                        startAngle: -180,
                                        progressStrokeWidth: 10,
                                        backStrokeWidth: 10,
                                        progressColors: MyColors.primaryG,
                                        backColor: Colors.grey.shade100,
                                        valueNotifier: ValueNotifier(60),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
                  ],
                ),
                SizedBox(height: media.width * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Workout Progress",
                      style: TextStyle(
                        color: MyColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      height: 35,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: MyColors.primaryG),
                          borderRadius: BorderRadius.circular(15)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: ["Weekly", "Monthly"]
                              .map((name) => DropdownMenuItem(
                                  value: name,
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                        color: MyColors.black, fontSize: 14),
                                  )))
                              .toList(),
                          onChanged: (value) {},
                          icon: Icon(Icons.expand_more, color: MyColors.white),
                          hint: Text("Weekly",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: MyColors.white, fontSize: 12)),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: media.width * 0.05),
                Container(
                    padding: const EdgeInsets.only(left: 15),
                    height: media.width * 0.5,
                    width: double.maxFinite,
                    child: LineChart(
                      LineChartData(
                        showingTooltipIndicators:
                            showingTooltipOnSpots.map((index) {
                          return ShowingTooltipIndicators([
                            LineBarSpot(
                              tooltipsOnBar,
                              lineBarsData.indexOf(tooltipsOnBar),
                              tooltipsOnBar.spots[index],
                            ),
                          ]);
                        }).toList(),
                        lineTouchData: LineTouchData(
                          enabled: true,
                          handleBuiltInTouches: false,
                          touchCallback: (FlTouchEvent event,
                              LineTouchResponse? response) {
                            if (response == null ||
                                response.lineBarSpots == null) {
                              return;
                            }
                            if (event is FlTapUpEvent) {
                              final spotIndex =
                                  response.lineBarSpots!.first.spotIndex;
                              showingTooltipOnSpots.clear();
                              setState(() {
                                showingTooltipOnSpots.add(spotIndex);
                              });
                            }
                          },
                          mouseCursorResolver: (FlTouchEvent event,
                              LineTouchResponse? response) {
                            if (response == null ||
                                response.lineBarSpots == null) {
                              return SystemMouseCursors.basic;
                            }
                            return SystemMouseCursors.click;
                          },
                          getTouchedSpotIndicator: (LineChartBarData barData,
                              List<int> spotIndexes) {
                            return spotIndexes.map((index) {
                              return TouchedSpotIndicatorData(
                                FlLine(
                                  color: Colors.transparent,
                                ),
                                FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) =>
                                          FlDotCirclePainter(
                                    radius: 3,
                                    color: Colors.white,
                                    strokeWidth: 3,
                                    strokeColor: MyColors.secondaryColor1,
                                  ),
                                ),
                              );
                            }).toList();
                          },
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: MyColors.secondaryColor1,
                            tooltipRoundedRadius: 20,
                            getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                              return lineBarsSpot.map((lineBarSpot) {
                                return LineTooltipItem(
                                  "${lineBarSpot.x.toInt()} mins ago",
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        lineBarsData: lineBarsData1,
                        minY: -0.5,
                        maxY: 110,
                        titlesData: FlTitlesData(
                            show: true,
                            leftTitles: AxisTitles(),
                            topTitles: AxisTitles(),
                            bottomTitles: AxisTitles(
                              sideTitles: bottomTitles,
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: rightTitles,
                            )),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          horizontalInterval: 25,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: MyColors.darkGrey.withOpacity(0.15),
                              strokeWidth: 2,
                            );
                          },
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: media.width * 0.05,
                ),

                /*
                ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: lastWorkoutArr.length,
                    itemBuilder: (context, index) {
                      var wObj = lastWorkoutArr[index] as Map? ?? {};
                      return InkWell();
                    }),*/
                SizedBox(
                  height: media.width * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
      (i) {
        const color0 = MyColors.secondaryColor2;
        const color1 = MyColors.white;

        switch (i) {
          case 0:
            return PieChartSectionData(
                color: color0,
                value: 33,
                title: '',
                radius: 55,
                titlePositionPercentageOffset: 0.55,
                badgeWidget: Text(
                  "20.1",
                  style: TextStyle(
                      color: MyColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12),
                ));
          case 1:
            return PieChartSectionData(
              color: color1,
              value: 75,
              title: '',
              radius: 42,
              titlePositionPercentageOffset: 0.55,
            );
          default:
            throw Error();
        }
      },
    );
  }

  SideTitles get rightTitles => SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: 20,
        reservedSize: 40,
      );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 20:
        text = '20%';
        break;
      case 40:
        text = '40%';
        break;
      case 60:
        text = '60%';
        break;
      case 80:
        text = '80%';
        break;
      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: TextStyle(
          color: MyColors.darkGrey,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: MyColors.darkGrey,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Sun', style: style);
        break;
      case 2:
        text = Text('Mon', style: style);
        break;
      case 3:
        text = Text('Tue', style: style);
        break;
      case 4:
        text = Text('Wed', style: style);
        break;
      case 5:
        text = Text('Thu', style: style);
        break;
      case 6:
        text = Text('Fri', style: style);
        break;
      case 7:
        text = Text('Sat', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }
}
