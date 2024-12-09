// Device token for Firebase Messaging
String? DeviceToken;

// Firebase Project ID
const String projectId = 'fitnest-6980d';

// Service account credentials for authentication
const Map<String, String> firebaseConfig = {
  'serviceAccountEmail': 'fitnestapp@fitnest-6980d.iam.gserviceaccount.com',
  'privateKeyId': 'cedbed82d6bd700808106bc3f343f622b0aabcce',
};

// Notification API endpoint
const String fcmApiUrl = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
