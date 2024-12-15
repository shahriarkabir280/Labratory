import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math';

class Event {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String? location;
  final String? url;
  final String? description;

  Event({
    required this.name,
    required this.startDate,
    required this.endDate,
    this.location,
    this.url,
    this.description,
  });
}

class eventPlannerPage extends StatefulWidget {
  @override
  _EventPlannerPageState createState() => _EventPlannerPageState();
}

class _EventPlannerPageState extends State<eventPlannerPage> {
  final List<Event> _events = [];
  final CalendarController _calendarController = CalendarController();
  final Map<DateTime, Color> _eventColors = {};

  void _addEvent(Event event) {
    setState(() {
      _events.add(event);
      _eventColors[event.startDate] = _generateRandomColor();
    });
  }

  Color _generateRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Planner'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _showDatePicker();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SfCalendar(
              view: CalendarView.month,
              controller: _calendarController,
              dataSource: EventDataSource(_events),
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.calendarCell) {
                  DateTime selectedDate = details.date ?? DateTime.now();
                  _showAddEventDialog(selectedDate);
                }
              },
              monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                agendaItemHeight: 50,
              ),
              monthCellBuilder: (BuildContext context, MonthCellDetails details) {
                final DateTime cellDate = details.date;
                final List<Event> cellEvents = _events.where((event) =>
                event.startDate.year == cellDate.year &&
                    event.startDate.month == cellDate.month &&
                    event.startDate.day == cellDate.day
                ).toList();

                if (cellEvents.isNotEmpty) {
                  return Container(
                    decoration: BoxDecoration(
                      color: _eventColors[cellDate] ?? Colors.blueAccent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${cellDate.day}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (cellEvents.isNotEmpty)
                            Text(
                              cellEvents.first.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Text(
                      '${cellDate.day}',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog(DateTime selectedDate) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController urlController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Event'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Event Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter event name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(labelText: 'Location'),
                  ),
                  TextFormField(
                    controller: urlController,
                    decoration: InputDecoration(labelText: 'URL (optional)'),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addEvent(Event(
                    name: nameController.text,
                    startDate: selectedDate,
                    endDate: selectedDate,
                    location: locationController.text.isNotEmpty
                        ? locationController.text
                        : null,
                    url: urlController.text.isNotEmpty
                        ? urlController.text
                        : null,
                    description: descriptionController.text,
                  ));
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add Event'),
            ),
          ],
        );
      },
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((selectedDate) {
      if (selectedDate != null) {
        _calendarController.displayDate = selectedDate;
      }
    });
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> events) {
    appointments = events;
  }

  @override
  DateTime getStartTime(int index) {
    return (appointments![index] as Event).startDate;
  }

  @override
  DateTime getEndTime(int index) {
    return (appointments![index] as Event).endDate;
  }

  @override
  String getSubject(int index) {
    return (appointments![index] as Event).name;
  }

  @override
  String? getLocation(int index) {
    return (appointments![index] as Event).location;
  }

  @override
  String? getNotes(int index) {
    return (appointments![index] as Event).description;
  }
}
