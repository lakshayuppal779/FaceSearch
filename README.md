# FaceSearch App

## Overview

The FaceSearch app is a Flutter-based mobile application designed to enhance user engagement by allowing them to upload images and dynamically view a sequence of images fetched from a backend service. This app showcases advanced functionalities such as image uploading, API integration, and timed image transitions.

## Key Functionalities

### Image Uploading
- Users can upload images directly from their mobile device either by capturing a photo using the camera or selecting one from the gallery.
- The app leverages the `ImagePicker` package for seamless integration with the device's native camera and gallery.

### API Integration
- Uploaded images are sent to temprorary API, which handles both storage and retrieval.
- Network requests are managed using the `http` package, facilitating both the upload of images and the subsequent fetching of image URLs.

### Displaying Images
- The app displays images one after another every 2 seconds on a new screen following a successful upload.
- Image display is managed using a `Timer` that cycles through image URLs fetched from a dummy API simulating a backend image service.

## Workflow 

### Uploading Images
- Images are prepared for upload via a multipart request using the `http` library.
- The app includes comprehensive error handling for network availability, request timeouts, and server errors, ensuring users receive timely feedback through toast messages.

### Navigating and Displaying Results
- A toast message confirms the successful upload, followed by a brief delay before navigating to the image display screen, allowing users time to read the message.
- This enhances UX by not rushing the transition between screens.

### Timed Image Display
- A `Timer` updates the displayed image periodically, cycling through a list of URLs obtained from the dummy API.
- Users can interact with the display by stopping the automatic cycling through a dedicated control button.

### Error Management
- The app gracefully handles API response errors, timeout exceptions, and parsing errors.
- All errors trigger a toast notification with a user-friendly message, ensuring users are well-informed of any operational issues.

## Conclusion

The FaceSearch app combines Flutter's capabilities with best practices in UI design, network communication, and error management. It not only functions as a powerful tool but also serves as an excellent portfolio project to demonstrate the ability to create robust, real-world applications suitable for showcasing to potential employers or recruiters.
