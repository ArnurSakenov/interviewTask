# GenesysHW - Feed Display iOS App

A native iOS application that displays a feed of items from an API with command-based control functionality. Built programmatically using UIKit and following MVVM architecture.

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Testing](#testing)
- [Dependencies](#dependencies)
- [API](#api)

## Features

- **Real-time Feed Display**: Fetches a new feed item every 5 seconds from the API and displays it in a scrollable list.
- **Command-Based Control**: Supports commands (`start`, `stop`, `pause`, `resume`) to control the feed fetching and display.
- **Image Loading with Caching**: Loads images associated with feed items and caches them to improve performance.
- **Responsive UI**: Automatically scrolls to the latest feed item and adjusts for keyboard appearance.
- **Error Handling**: Displays errors to the user when network requests fail or data cannot be loaded.
- **Unit Tests**: Includes unit tests for key components like `FeedManager`, `FeedViewModel`, and `NetworkService`.

## Architecture

The project follows the MVVM (Model-View-ViewModel) architecture pattern, promoting a clear separation of concerns.

- **Models**: Defines the data structures used in the app.
- **ViewModels**: Handles the business logic and prepares data for the views.
- **Views**: Includes view controllers and custom UI components.
- **Services**: Contains network and image loading services.
- **Tests**: Includes unit tests for the core functionalities.

## Installation

1. **Clone the repository**

   ```bash
   git clone [https://github.com/ArnurSakenov/interviewTask.git]
   ```

2. **Open the project**

   Open `genesysHW.xcodeproj` in Xcode.

3. **Install Dependencies**

   No external dependencies are required.

4. **Build and Run**

   Select a simulator or your device and click `Run` or press `Cmd + R`.

## Usage

1. **Start the Feed**

   - Type `start` in the text field at the bottom and press `Enter`.
   - The app will begin fetching feed items every 5 seconds.

2. **Pause the Feed**

   - Type `pause` and press `Enter`.
   - The app will continue fetching items but won't display them.

3. **Resume the Feed**

   - Type `resume` and press `Enter`.
   - The app will display all paused items and continue regular operation.

4. **Stop the Feed**

   - Type `stop` and press `Enter`.
   - The app will stop fetching items and reset.

**Note**: Commands are case-insensitive (`Start`, `START`, `start` all work).

## Project Structure

```
genesysHW/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Models/
│   └── FeedItem.swift
├── ViewModels/
│   └── FeedViewModel.swift
├── Views/
│   ├── FeedViewController.swift
│   └── Cells/
│       ├── FeedCell.swift
│       └── CommandCell.swift
├── Services/
│   ├── NetworkService.swift
│   ├── ImageLoader.swift
│   └── FeedManager.swift
├── Assets.xcassets
├── LaunchScreen.storyboard
└── Info.plist

genesysHWTests/
├── MockNetworkService.swift
├── FeedViewModelTests.swift
├── FeedManagerTests.swift
└── NetworkServiceTests.swift
```

- **AppDelegate.swift** and **SceneDelegate.swift**: App lifecycle management.
- **Models**: Contains data models like `FeedItem`.
- **ViewModels**: Contains the `FeedViewModel` which handles business logic.
- **Views**: Includes UI components and view controllers.
- **Services**: Holds networking (`NetworkService`), image loading (`ImageLoader`), and feed management (`FeedManager`).

## Testing

The project includes unit tests for the core components.

- **FeedManagerTests**: Tests the `FeedManager`'s command execution and state management.
- **FeedViewModelTests**: Tests command processing and item handling in the `FeedViewModel`.
- **NetworkServiceTests**: Tests API calls and error handling in the `NetworkService`.

To run tests:

1. Select the `genesysHW` scheme.
2. Press `Cmd + U` or go to `Product` -> `Test`.

## Dependencies

The project uses native iOS frameworks:

- **UIKit**: For UI components.
- **Foundation**: Basic types and functionalities.
- **Combine**: For reactive programming and data binding.

No third-party libraries are used, keeping external dependencies minimal.

## API

The app uses the [DummyJSON](https://dummyjson.com/) API to fetch products.

- **Endpoint**: `https://dummyjson.com/products`
- **Parameters**:
  - `limit`: Number of items to fetch.
  - `skip`: Number of items to skip.
- **Usage Example**: `https://dummyjson.com/products?limit=1&skip=2`

**Feed Data**:

- Uses the `description` field from the product as the feed content.
- Uses the `thumbnail` field for the image associated with the feed item.

