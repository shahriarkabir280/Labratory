import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:testapp/features/EventPlanning/eventPlanningPage.dart';

class EventService {
  static const String baseUrl = 'https://famnest.onrender.com'; // Replace with your backend URL

  /// Adds an event to the backend.
  static Future<bool> addEvent(Event event) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create-event/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(event.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Failed to add event: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding event: $e');
      return false;
    }
  }

  /// Fetches events from the backend for a given group code.
  static Future<List<Event>> fetchEvents(String groupCode, {int skip = 0, int limit = 20}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get-events/$groupCode?skip=$skip&limit=$limit'));

      if (response.statusCode == 200) {
        final List<dynamic> eventData = json.decode(response.body);
        return eventData.map((eventJson) => Event.fromJson(eventJson)).toList();
      } else {
        print('Failed to fetch events: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  /// Fetches a single event by ID.
  static Future<Event?> fetchEventById(String eventId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get-event/$eventId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> eventData = json.decode(response.body);
        return Event.fromJson(eventData);
      } else {
        print('Failed to fetch event by ID: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching event by ID: $e');
      return null;
    }
  }

  /// Updates an event in the backend.
  static Future<bool> updateEvent(String eventId, Event updatedEvent) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update-event/$eventId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedEvent.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update event: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating event: $e');
      return false;
    }
  }

  /// Deletes an event by ID.
  static Future<bool> deleteEvent(String eventId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete-event/$eventId'));

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete event: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting event: $e');
      return false;
    }
  }
}
