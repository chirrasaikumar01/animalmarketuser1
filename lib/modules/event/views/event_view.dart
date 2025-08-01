import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/core/util.dart';
import 'package:animal_market/modules/account/widgets/delete_account_bottom_sheet.dart';
import 'package:animal_market/modules/event/providers/event_provider.dart';
import 'package:animal_market/modules/event/wigtes/add_event_bottom_sheet.dart';
import 'package:animal_market/modules/event/wigtes/delete_event_bottom_sheet.dart';
import 'package:animal_market/modules/event/wigtes/event_details_bottom_sheet.dart';
import 'package:table_calendar/table_calendar.dart';

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late EventProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<EventProvider>();
      provider.isEvent = false;
      provider.formatDate(context, _focusedDay);
      provider.allEventGet(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 70.h),
              child: CommonAppBar(
                title: "eventCalendar",
                action: GestureDetector(
                  onTap: () {
                    state.reset();
                    AddEventBottomSheet.show(
                      context,
                      () {
                        if (state.title.text == "") {
                          errorToast(context, pleaseEnterTitle);
                          return;
                        } else if (state.description.text == "") {
                          errorToast(context, pleaseEnterDescription);
                          return;
                        } else if (state.eventDate.text == "") {
                          errorToast(context, pleaseEnterEventDate);
                          return;
                        } else if (state.startTime.text == "") {
                          errorToast(context, pleaseEnterStartTime);
                          return;
                        } else {
                          state.addEvent(context);
                        }
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(4.dm),
                      border: Border.all(color: ColorConstant.appCl, width: 1.w),
                    ),
                    child: TText(keyName:
                      "addEvent",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorConstant.appCl,
                        fontFamily: FontsStyle.regular,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(3000, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                      state.formatDate(context, focusedDay);
                      state.eventListGet(context);
                    },
                    calendarFormat: CalendarFormat.month,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: Icon(Icons.chevron_left, color: Colors.green),
                      rightChevronIcon: Icon(Icons.chevron_right, color: Colors.green),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.grey),
                      weekendStyle: TextStyle(color: Colors.grey),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.green[700],
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.green[400],
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(color: Colors.transparent),
                    ),
                    eventLoader: (day) {
                      DateTime dateKey = DateTime(day.year, day.month, day.day);
                      return state.allEventList.where((event) {
                        if (event.date == null || event.date!.isEmpty) return false;
                        try {
                          DateTime eventDate = DateTime.parse(event.date!);
                          return eventDate.year == dateKey.year &&
                              eventDate.month == dateKey.month &&
                              eventDate.day == dateKey.day;
                        } catch (e) {
                          Log.console("Invalid date format: ${event.date}");
                        }
                        return false;
                      }).toList();
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        state.eventDate.text = state.formatDate(context, selectedDay);
                        state.eventListGet(context);
                      });
                    },
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        bool hasEvent = state.allEventList.any((event) {
                          if (event.date == null || event.date!.isEmpty) return false;
                          try {
                            DateTime eventDate = DateTime.parse(event.date!);
                            return eventDate.year == day.year &&
                                eventDate.month == day.month &&
                                eventDate.day == day.day;
                          } catch (e) {
                            return false;
                          }
                        });

                        if (hasEvent) {
                          return Container(
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.green, width: 1),
                            ),
                            alignment: Alignment.center,
                            child: TText(keyName:
                              '${day.day}',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),


                  SizedBox(height: 20),
                  Divider(color: Colors.green[100]),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TText(keyName:
                          "eventCalendar",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.black,
                            fontFamily: FontsStyle.regular,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Builder(
                          builder: (context) {
                            if (state.isLoading) {
                              return LoaderClass(height: 400);
                            }
                            if (state.eventList.isEmpty) {
                              return Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      ImageConstant.noEventImg,
                                      height: 127.h,
                                      width: 127.w,
                                    ),
                                  ),
                                  SizedBox(height: 17.h),
                                  Align(
                                    alignment: Alignment.center,
                                    child: TText(keyName:
                                     "noDataFound",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant.black,
                                        fontFamily: FontsStyle.regular,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView.builder(
                                itemCount: state.eventList.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) {
                                  var item = state.eventList[index];
                                  return Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.endToStart,
                                    confirmDismiss: (direction) async {
                                      bool shouldDelete = false;
                                      await DeleteAccountBottomSheet.show(context, () {
                                        shouldDelete = true;
                                        state.deleteEvent(context, item.id.toString());
                                      });
                                      return shouldDelete;
                                    },
                                    background: Container(
                                        alignment: AlignmentDirectional.centerEnd,
                                        color: Color(0xFFFFE8E8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    await DeleteEventBottomSheet.show(context, () {
                                                      state.deleteEvent(context, item.id.toString());
                                                    });
                                                  },
                                                  child: Image.asset(
                                                    ImageConstant.deleteOutlineIc,
                                                    height: 24.h,
                                                    width: 24.w,
                                                  ),
                                                ),
                                                SizedBox(height: 4.h),
                                                TText(keyName:
                                                  remove,
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: ColorConstant.redLightCl,
                                                    fontFamily: FontsStyle.medium,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 16.w)
                                          ],
                                        )),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            EventDetailsBottomSheet.show(context, item);
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 14.h),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: ColorConstant.appCl, width: 1.w),
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(8.dm),
                                                    bottomLeft: Radius.circular(8.dm),
                                                  ),
                                                ),
                                                child: TText(keyName:
                                                  state.formatDate1(item.date ?? ""),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: ColorConstant.appCl,
                                                    fontFamily: FontsStyle.semiBold,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 3.w),
                                              Expanded(
                                                child: Container(
                                                  height: 77.h,
                                                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 9.h),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: ColorConstant.borderCl, width: 1.w),
                                                    borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(8.dm),
                                                      bottomRight: Radius.circular(8.dm),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TText(keyName:
                                                        item.title ?? "",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w400,
                                                          color: ColorConstant.textDarkCl,
                                                          fontFamily: FontsStyle.medium,
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      TText(keyName:
                                                        item.description ?? "",
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontSize: 10.sp,
                                                          fontWeight: FontWeight.w400,
                                                          color: ColorConstant.textDarkCl,
                                                          fontFamily: FontsStyle.regular,
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 14.h)
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
