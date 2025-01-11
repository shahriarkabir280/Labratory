import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:testapp/Models/UserState.dart'; // Import UserState
import 'package:testapp/backend_connections/api services/features/eventServices.dart';
import 'package:url_launcher/url_launcher.dart';

class Event {
  final String id; // Added for editing and deleting
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String? location;
  final String? url;
  final String? description;
  final String groupCode;

  Event({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.groupCode,
    this.location,
    this.url,
    this.description,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      groupCode: json['group_code'],
      location: json['location'],
      url: json['url'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'group_code': groupCode,
      'location': location,
      'url': url,
      'description': description,
    };
  }
}

class eventPlannerPage extends StatefulWidget {
  @override
  _EventPlannerPageState createState() => _EventPlannerPageState();
}

class _EventPlannerPageState extends State<eventPlannerPage> {
  final List<Event> _events = [];
  final CalendarController _calendarController = CalendarController();
  final Map<DateTime, Color> _eventColors = {};

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _addEventToState(Event event) {
    setState(() {
      _events.add(event);
      _eventColors[event.startDate] = _generateRandomColor();
    });
  }

  void _fetchEvents() async {
    final currentGroupCode =
        Provider.of<UserState>(context, listen: false).currentUser?.currentGroup?.groupCode;
    if (currentGroupCode == null) return;

    List<Event> fetchedEvents = await EventService.fetchEvents(currentGroupCode);
    setState(() {
      _events.clear();
      _events.addAll(fetchedEvents);
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


  void _showAddEventDialog(DateTime selectedDate) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController urlController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    // Default start and end times
    DateTime startDate = selectedDate;
    DateTime endDate = startDate.add(Duration(hours: 1)); // Default duration is 1 hour

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Add Event',
            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      border: OutlineInputBorder(),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter event name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),

                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: urlController,
                    decoration: InputDecoration(
                      labelText: 'URL (optional)',
                      border: OutlineInputBorder(),

                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 10),
                  // Editable Start Date and Time
                  ListTile(
                    title: Text('Start Date & Time'),
                    subtitle: Text('${startDate.toLocal()}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(startDate),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            startDate = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  // Editable End Date and Time
                  ListTile(
                    title: Text('End Date & Time'),
                    subtitle: Text('${endDate.toLocal()}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: endDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(endDate),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            endDate = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
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
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final currentGroupCode = Provider.of<UserState>(context, listen: false).currentUser?.currentGroup?.groupCode;
                  if (currentGroupCode == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No current group selected")),
                    );
                    return;
                  }

                  Event newEvent = Event(
                    id: "", // Backend will generate this ID
                    name: nameController.text,
                    startDate: startDate,
                    endDate: endDate,
                    groupCode: currentGroupCode,
                    location: locationController.text,
                    url: urlController.text,
                    description: descriptionController.text,
                  );

                  bool success = await EventService.addEvent(newEvent);
                  if (success) {
                    _addEventToState(newEvent);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Failed to add event."),
                    ));
                  }
                }
              },
              child: Text('Add Event'),
            ),
          ],
        );
      },
    );
  }




  void _openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppWebView, // Opens the URL within the app
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to open the URL")),
      );
    }
  }


  void _showEventDetails(List<Event> events) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Event Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: events.map((event) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Event Name: ${event.name}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Time: ${event.startDate.toLocal()} - ${event.endDate.toLocal()}",
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Location:",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(height: 3),
                        Text(
                          event.location?.isNotEmpty == true
                              ? event.location!
                              : "Address not provided",
                          style: TextStyle(fontSize: 14),
                        ),
                        if (event.url != null && event.url!.isNotEmpty)
                          GestureDetector(
                            onTap: () => _openUrl(event.url!),
                            child: Text(
                              event.url!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        SizedBox(height: 8),
                        Text(
                          "Description:",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(height: 3),
                        Text(
                          event.description?.isNotEmpty == true
                              ? event.description!
                              : "Not provided",
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _showEditEventDialog(event),
                              child: Text("Edit"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _deleteEvent(event.id);
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }








  void _showEditEventDialog(Event event) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
    TextEditingController(text: event.name);
    final TextEditingController locationController =
    TextEditingController(text: event.location);
    final TextEditingController urlController = TextEditingController(text: event.url);
    final TextEditingController descriptionController =
    TextEditingController(text: event.description);

    DateTime startDate = event.startDate;
    DateTime endDate = event.endDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Event"),
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
                  SizedBox(height: 10),
                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(labelText: 'Location'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: urlController,
                    decoration: InputDecoration(labelText: 'URL'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
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
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Event updatedEvent = Event(
                    id: event.id,
                    name: nameController.text,
                    startDate: startDate,
                    endDate: endDate,
                    groupCode: event.groupCode,
                    location: locationController.text,
                    url: urlController.text,
                    description: descriptionController.text,
                  );
                  bool success = await EventService.updateEvent(event.id, updatedEvent);
                  if (success) {
                    setState(() {
                      int index = _events.indexWhere((e) => e.id == event.id);
                      _events[index] = updatedEvent;
                    });
                    Navigator.of(context).pop();
                  }
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(String eventId) async {
    bool success = await EventService.deleteEvent(eventId);
    if (success) {
      setState(() {
        _events.removeWhere((event) => event.id == eventId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Event deleted successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Planner"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddEventDialog(DateTime.now());
            },
          ),
        ],
      ),
      body: SfCalendar(
        view: CalendarView.month,
        controller: _calendarController,
        dataSource: EventDataSource(_events),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell &&
              details.date != null) {
            final selectedDate = details.date!;
            final eventsOnSelectedDate = _events.where((event) {
              return event.startDate.year == selectedDate.year &&
                  event.startDate.month == selectedDate.month &&
                  event.startDate.day == selectedDate.day;
            }).toList();

            if (eventsOnSelectedDate.isNotEmpty) {
              _showEventDetails(eventsOnSelectedDate);
            }
          }
        },
      ),
    );
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> events) {
    appointments = events;
  }

  @override
  DateTime getStartTime(int index) => (appointments![index] as Event).startDate;

  @override
  DateTime getEndTime(int index) => (appointments![index] as Event).endDate;

  @override
  String getSubject(int index) => (appointments![index] as Event).name;
}
