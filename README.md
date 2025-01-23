#  Flutter App | Firebase DB

This Flutter application enables users to perform various authentication and image-related tasks using Firebase services. Below is a detailed breakdown of the features and dependencies used in this project.

## Features

1. **User Authentication**
   - Sign Up with Email and Password
   - Login with Email and Password
   - Phone Authentication with OTP Verification
   - Forgot Password functionality

2. **User Session Management**
   - Check if the user is logged in or not
   - Persist user sessions

3. **Post Creation**
   - Add posts with images
   - Store posts in Firebase Firestore
   - Upload images to Firebase Storage

## Dependencies

The following Flutter packages are used in this project:

| Package           | Version | Description                                      |
|-------------------|---------|--------------------------------------------------|
| `cupertino_icons` | ^1.0.8  | Provides iOS-style icons                        |
| `firebase_core`   | ^1.21.1 | Connects the app to Firebase services           |
| `firebase_auth`   | ^3.7.0  | Handles user authentication                     |
| `cloud_firestore` | ^3.4.6  | Provides Firestore database access              |
| `firebase_storage`| ^10.3.7 | Uploads and retrieves images from Firebase      |
| `firebase_database`| ^9.1.3 | Real-time database support                      |
| `fluttertoast`    | ^8.0.9  | Displays toast messages                         |
| `image_picker`    | ^0.8.5+3| Picks images from the gallery or camera         |

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd <project-directory>
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Set up Firebase:
   - Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
   - Add your app's `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective directories.

## Usage

### User Authentication

- **Sign Up:** Users can create an account using their email and password.
- **Login:** Users can log in using their email and password or phone number with OTP verification.
- **Forgot Password:** Users can reset their password via email.

### Post Creation

- **Add Image Posts:** Users can pick an image from their gallery or camera, then upload it to Firebase Storage and save post details in Firestore.

### Session Management

- On app launch, the user's session status is checked to determine if they are logged in or not.

## Example Code

### Firebase Initialization

Add the following code to initialize Firebase:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

### Sign Up Function

```dart
Future<void> signUp(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    Fluttertoast.showToast(msg: "Sign up successful");
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
  }
}
```

### Image Picker and Upload

```dart
Future<void> pickAndUploadImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    File file = File(pickedFile.path);
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      await FirebaseStorage.instance.ref('uploads/$fileName').putFile(file);
      Fluttertoast.showToast(msg: "Image uploaded successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
```

## License

This project is licensed under the MIT License. Feel free to modify and use it as per your requirements.

