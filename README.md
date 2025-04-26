# 🌎 SismikApp

SismikApp is a Clean Architecture iOS application that displays recent earthquake data based on the user's current location, using the [USGS Earthquake API](https://earthquake.usgs.gov/).

Built with Swift 5.9, SwiftUI, UIKit, Combine, and Clean Architecture principles.

---

## 🚀 Features

- Fetch and display nearby earthquakes based on user location
- View detailed earthquake information (magnitude, depth, coordinates)
- SwiftUI for UI components
- UIKit for navigation (Coordinator pattern)
- Clean Architecture and MVVM separation
- Fully Combine-based reactive data flow
- Dark Mode and Light Mode support
- Supports iOS 16+

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift 5.9 |
| UI | SwiftUI + UIKit (Coordinator Pattern) |
| Networking | URLSession + Combine |
| Location Services | CoreLocation |
| Architecture | Clean Architecture + MVVM |
| Dependency Management | Native (no third-party libraries) |
| Deployment Target | iOS 16.0+ |

---

## 🏗️ Project Architecture

```
Presentation (SwiftUI Views, UIKit Coordinators)
  ↓
Domain (Entities, UseCases, Repository Protocols)
  ↓
Data (DTOs, Mappers, Repositories, Services)
  ↓
Core (Location Manager, Endpoint, Network Layer)
```

✅ Each layer depends only on the layer below it (Dependency Rule)  
✅ No UI code inside Domain or Data layers  
✅ High testability, scalability, and modularity

---

## 📸 Screenshots (Placeholders)

| Earthquake List | Earthquake Details |
|:---:|:---:|
| ![List Screen](docs/screenshots/list.png) | ![Details Screen](docs/screenshots/details.png) |

*(Screenshots will be added after first release.)*

---

## 🧩 Setup Instructions

1. Clone this repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/SismikApp.git
   ```
2. Open `SismikApp.xcodeproj` in Xcode 15+
3. Make sure the Deployment Target is iOS 16.0+
4. Run on Simulator or Device

✅ No third-party dependencies  
✅ No CocoaPods, Carthage, or SwiftPM setup needed

---

## 🎯 Branching Strategy

- `main` — Stable, production-ready branch
- `develop` — Active development branch
- `feature/*` — New features are developed here
- `bugfix/*` — Bug fixes
- `hotfix/*` — Critical production fixes

✅ Protected branches (no direct push)  
✅ Pull Request workflow required

---

## 📄 License

MIT License — Feel free to fork and use it for educational or personal projects!

---

## 🙏 Credits

- USGS Earthquake API ([earthquake.usgs.gov](https://earthquake.usgs.gov/))
- Inspired by Clean Swift, MVVM-C, and Clean Architecture practices

---

# 🌟 Made with passion by [Ertan Yağmur](https://github.com/YOUR_USERNAME)

