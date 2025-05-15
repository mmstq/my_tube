# MyTube - Flutter Video Reels App

A Flutter application that fetches and displays video data in a reels-style interface with pagination, following clean architecture principles and modern Flutter development practices.

## Features

- **Reels Interface**: Smooth vertically scrolling video feed
- **Pagination**: Load more content as user scrolls
- **Lazy Loading**: Videos are loaded on-demand for better performance
- **Caching**: Video data is cached to reduce API calls
- **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- **Error Handling**: Graceful error handling for API failures and JSON parsing errors

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
- **cached_network_image**: Image caching and loading

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

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
