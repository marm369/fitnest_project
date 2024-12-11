import 'package:flutter/material.dart';
import 'package:fitnest/features/notifs/models/notif_model.dart';
import '../services/notifications_service.dart';
import 'package:fitnest/features/events/models/event.dart';

class NotifScreen extends StatefulWidget {
  final double userId;
  final double eventId;

  const NotifScreen({Key? key, required this.userId, required this.eventId}) : super(key: key);

  @override
  _NotifScreenState createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {
  late Future<List<NotificationModel>> notifications;

  @override
  void initState() {
    super.initState();
    notifications = fetchUserNotifications(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: FutureBuilder<List<NotificationModel>>(
        future: notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No notifications found."));
          } else {
            return _listView(snapshot.data!);
          }
        },
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: const Text('Notifications'),
      backgroundColor: Colors.blue,
    );
  }

  Widget _listView(List<NotificationModel> notifications) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return _listViewItem(notifications[index]);
      },
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemCount: notifications.length,
    );
  }

  Widget _listViewItem(NotificationModel notification) {
    return GestureDetector(
     /* onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (event) => EventDetailsPage(event: findEvent(eventid)),
          ),
        );
      },*/
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _prefixIcon(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _message(notification),
                    _timeAndDate(notification.timestamp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _prefixIcon() {
    return Container(
      height: 50,
      width: 50,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
      ),
      child: Icon(
        Icons.notifications,
        size: 25,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget _message(NotificationModel notification) {
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: '${notification.type}: ',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: notification.content,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeAndDate(DateTime timestamp) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${timestamp.toLocal().day}-${timestamp.toLocal().month}-${timestamp.toLocal().year}",
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
          Text(
            "${timestamp.toLocal().hour}:${timestamp.toLocal().minute.toString().padLeft(2, '0')} ${timestamp.toLocal().hour >= 12 ? 'PM' : 'AM'}",
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}


