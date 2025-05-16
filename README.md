# MyTube - Flutter Video Reels App

A Flutter application that fetches and displays video data in a reels-style interface with pagination, following clean architecture principles and modern Flutter development practices.

## Features

- **Reels Interface**: Smooth vertically scrolling video feed
- **Pagination**: Load more content as user scrolls
- **Lazy Loading**: Videos are loaded on-demand for better performance
- **Caching**: Video data is cached to reduce API calls
- **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- **Error Handling**: Graceful error handling for API failures and JSON parsing errors

## Design

1. Design inspiration is taken from Reab.com
2. Bottom Bar
3. AppBar
4. Search Bar and Search Chips

## Demo Videos

### Android Demo

https://github.com/user-attachments/assets/3c7dad75-5511-4e73-ad21-0b66d94e41cd



### iOS Demo

https://github.com/user-attachments/assets/54468d36-70a9-40f2-b56c-eb0e8910e35b



## Architecture

The application follows Clean Architecture principles with the following layers:

### Domain Layer
- **Entities**: Core business objects (Video)
- **Repositories**: Abstract interfaces for data operations
- **Use Cases**: Specific business logic operations

### Data Layer
- **Models**: Data representations of entities (VideoModel)
- **Repositories**: Implementations of domain repositories
- **Data Sources**: Remote and local data sources

### Presentation Layer
- **BLoC**: State management using the BLoC pattern
- **Pages**: UI screens
- **Widgets**: Reusable UI components

## Dependencies

- **flutter_bloc**: State management using BLoC pattern
- **http**: API requests
- **get_it**: Dependency injection
- **shared_preferences**: Local storage for caching
- **video_player**: Video playback functionality
- **equatable**: Value equality without boilerplate code
- **hugeicons**: High quality stroke round icons
- **cached_network_image**: Image caching and loading

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

## If Not Working

1. Delete .idea folder in Android Studio
2. Restart Android Studio
3. Run `flutter pub get` to install dependencies

## API

The application uses the following API endpoint:
```
GET https://backend-cj4o057m.fctl.app/bytes/scroll?page=1&limit=10
```

## Implementation Details

- Uses BLoC pattern for state management
- Implements pagination to handle large datasets
- Applies lazy loading to enhance performance
- Caches video data to improve user experience
- Handles errors gracefully with user feedback
- Follows Flutter best practices for code organization and structure

## Notes
- Some URLs in the API response are invalid or broken
- These URLs return 403(forbidden) http status code
- I checked them, they are not private video either
- Moreover, to be certain, I checked URLs in other video players, like VLC and MX Player but not working.
- The app handles these cases gracefully by showing an error icon on video

- I am using the orientation property to determine if the video is shorts or horizontal

- As last page is not available, I am deciding last page by checking if the next page has empty data
