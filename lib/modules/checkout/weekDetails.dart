import 'package:flutter/material.dart';
import 'package:flutter_demo/utils.dart';

class WeekDetailsWidget extends StatefulWidget {
  final Map<String, dynamic> weekDetails;

  const WeekDetailsWidget({super.key, required this.weekDetails});

  @override
  _WeekDetailsWidgetState createState() => _WeekDetailsWidgetState();
}

class _WeekDetailsWidgetState extends State<WeekDetailsWidget> {
  late String selectedDay;

  @override
  void initState() {
    super.initState();
    // Set the default selected day to the first day with "status": true
    selectedDay = widget.weekDetails.entries
        .firstWhere(
          (entry) => entry.value['status'] == true,
          orElse: () => MapEntry(
            widget.weekDetails.keys.first,
            widget.weekDetails[widget.weekDetails.keys.first],
          ),
        )
        .key;
  }

  Widget buildDayButton(String day, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedDay = day;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: day == selectedDay
            ? const Color(0xffAF6CDA)
            : const Color(0xff1c2731).withOpacity(.16),
      ),
      child: Text(
        '$index: $day',
        style: SafeGoogleFont(
          "Poppins",
          color: day == selectedDay ? Colors.white : const Color(0xff1c2731),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text('Delivery Date',
              style: SafeGoogleFont("Poppins",
                  color: const Color(0xff868889),
                  fontWeight: FontWeight.w600,
                  fontSize: 18)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              widget.weekDetails.entries.length,
              (index) {
                String day = widget.weekDetails.keys.elementAt(index);
                Map<String, dynamic> dayDetails = widget.weekDetails[day]!;

                if (dayDetails['status'] == false) {
                  // If day is not available or status is false, return an empty container
                  return const SizedBox.shrink();
                }

                print('Day Index: $index');
                return buildDayButton(day, index);
              },
            ),
          ),
        ),
        if (selectedDay.isNotEmpty)
          const SizedBox(
            height: 20,
          ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Time',
            style: SafeGoogleFont("Poppins",
                color: const Color(0xff868889),
                fontWeight: FontWeight.w600,
                fontSize: 18),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              widget.weekDetails[selectedDay]['slots'].length,
              (index) {
                Map<String, dynamic>? slot =
                    widget.weekDetails[selectedDay]['slots'][index];
                if (slot == null || slot['status'] == false) {
                  // If slot is not available or status is false, return an empty container
                  return const SizedBox.shrink();
                }

                String slotTime = slot['slot_time'];
                print('Time Slot Index: $index');
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle onPressed for time slots if needed
                      },
                      child: Text('$index: $slotTime'),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
