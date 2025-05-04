import 'package:flutter/material.dart';
import 'package:littlesteps/widgets/custombutton.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:littlesteps/widgets/appBackground.dart';

class JadwalHarianPage extends StatefulWidget {
  const JadwalHarianPage({super.key});

  @override
  State<JadwalHarianPage> createState() => _JadwalHarianPageState();
}

class _JadwalHarianPageState extends State<JadwalHarianPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 20),
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, size: 36),
        ),
        title: Text(
          "Jadwal Harian",
          style: TextStyle(
            fontSize: 28,
            fontVariations: [FontVariation('wght', 800)],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: ListView(
          children: [
            CustomCalendar(),
            agenda("10.00 - 13.00", "Rapat Wali Murid", "Senin, 11-12-2024"),
            agenda("10.00 - 13.00", "Rapat Wali Murid", "Senin, 11-12-2024"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openBottomDrawer(context),
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        shape: CircleBorder(),
        backgroundColor: Color(0xff4285F4),
      ),
    );
  }

  void openBottomDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(top: 30, bottom: 45, left: 30, right: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Buat jadwal harian',
                    style: TextStyle(
                      fontSize: 30,
                      fontVariations: [FontVariation('wght', 800)],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Tulis catatan anda disini...',
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffC0C0C0), width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff4285F4),
                          width: 1.5), // Warna border saat focused
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xffC0C0C0),
                          width: 0.5), // Warna border saat tidak focused
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Tanggal',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020, 1, 1),
                          lastDate: DateTime(2050, 12, 31),
                        );
                        if (pickedDate != null) {
                          // lakukan sesuatu dengan pickedDate, misalnya isi ke TextField
                        }
                      },
                      icon: ImageIcon(
                        AssetImage('assets/icons/calender.png'),
                        color: Color(0xffC0C0C0),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffC0C0C0), width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff4285F4),
                          width: 1.5), // Warna border saat focused
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xffC0C0C0),
                          width: 0.5), // Warna border saat tidak focused
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Keterangan waktu',
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffC0C0C0), width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff4285F4),
                          width: 1.5), // Warna border saat focused
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xffC0C0C0),
                          width: 0.5), // Warna border saat tidak focused
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // ini supaya isi rata kiri
                          children: [
                            ImageIcon(
                              AssetImage('assets/icons/Tugas_lingkaran.png'),
                              color: Color(0xff4285F4),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Tugas',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // ini juga supaya isi rata kiri
                          children: [
                            ImageIcon(
                              AssetImage('assets/icons/Kegiatan_lingkaran.png'),
                              color: Color(0xff00B383),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Kegiatan',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CustomButton(
                  label: "Buat Jadwal",
                  onPressed: () {},
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget agenda(String time, String title, String date) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.radio_button_checked, color: Colors.green, size: 16),
                SizedBox(width: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontVariations: [FontVariation('wght', 700)],
                  ),
                ),
                Spacer(),
                Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontVariations: [FontVariation('wght', 700)],
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              date,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontVariations: [FontVariation('wght', 500)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomCalendar() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(_focusedDay),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      iconSize: 32,
                      icon: Icon(Icons.chevron_left),
                      onPressed: () => setState(() {
                        _focusedDay =
                            DateTime(_focusedDay.year, _focusedDay.month - 1);
                      }),
                    ),
                    IconButton(
                      iconSize: 32,
                      icon: Icon(Icons.chevron_right),
                      onPressed: () => setState(() {
                        _focusedDay =
                            DateTime(_focusedDay.year, _focusedDay.month + 1);
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TableCalendar(
            focusedDay: _focusedDay,
            daysOfWeekHeight: 50,
            calendarStyle: CalendarStyle(
                tablePadding:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
                todayDecoration: ShapeDecoration(
                    shape: CircleBorder(), color: Color(0xff4285F4)),
                selectedDecoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: Color(0xff4285F4).withOpacity(0.5))),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            firstDay: DateTime.utc(2015, 1, 1),
            lastDay: DateTime.utc(2045, 12, 31),
            calendarFormat: _calendarFormat,
            headerVisible: false,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                return Center(
                  child: Text(
                    DateFormat('E').format(day).substring(0, 3),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
