# SaveNine

An iOS time tracking app built with SwiftUI for managing project sessions.

## Purpose

A straightforward time tracker app to learn Swift, SwiftUI, SwiftData and iOS widgets. SaveNine tracks time spent on projects with start/stop functionality, custom session labels, and project tags.

**iOS Integration:**
- WidgetKit - Home screen widgets
- Dynamic Island - Live timer display
- Live Activities - Persistent timer visibility
- ActivityKit - Real-time session updates

## Key Features

**Project Organization:**
- Create projects with names, descriptions, and images
- Tag projects for categorization
- Track project status (active/closed)
- Export session data as formatted text

**Time Tracking:**
- Start/stop timers with one tap
- Custom labels for individual sessions
- Automatic duration calculation
- Session history with timestamps
- Cancel active sessions with confirmation

**iOS Integration:**
- Home screen widget shows recently tracked project
- Dynamic Island timer during active sessions
- Live Activities keep timer visible
- Widget tap opens directly to project

## Getting Started

### Requirements
- iOS 18.0 or later
- Xcode 16.0+ for building

### Installation
1. Clone the repository
2. Open `SaveNine.xcodeproj` in Xcode
3. Build and run on device or simulator

### Usage
1. Create a project
2. Add tags for organization
3. Start timer with custom session label
4. Review tracked time and session history

## Project Structure

- **Models**: SwiftData models for Project, Session, and Tag
- **Views**: Feature-organized SwiftUI views
- **Navigation**: Adaptive tab/split view navigation
- **Widgets**: iOS widget and Live Activity implementation
- **Extensions**: Utility functions and formatting helpers

## Development Context

Built while learning SwiftData and exploring iOS widget capabilities. Demonstrates modern iOS features including Dynamic Island integration and Live Activities for persistent timer display.
