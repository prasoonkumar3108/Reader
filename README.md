📚 Reader – iOS News Application

Reader is a fully modular, test-driven iOS app built using Swift, UIKit, MVVM, and Core Data.
It demonstrates scalable architecture, clean persistence, offline caching, and robust unit testing coverage for every layer — from API parsing to Core Data and repository logic.

🚀 Quick Start Setup
1️⃣ Create a new Xcode project

Open Xcode → File → New → Project → App (iOS)

Name: Reader

Language: Swift

Interface: UIKit

Lifecycle: UIKit App Delegate

✅ Check “Use Core Data”

2️⃣ Create the Core Data Model

Add a Core Data model file named ReaderModel.xcdatamodeld
Add an entity CDArticle with the following attributes:

Attribute	Type	Optional	Default
id	String	No	—
title	String	Yes	—
author	String	Yes	—
content	String	Yes	—
url	String	Yes	—
urlToImage	String	Yes	—
publishedAt	Date	Yes	—
isBookmarked	Boolean	No	NO

💡 Set Codegen → Manual/None and generate managed object subclasses via
Editor → Create NSManagedObject Subclass...

This creates:

CDArticle+CoreDataClass.swift

CDArticle+CoreDataProperties.swift

3️⃣ Add project source files

Copy or add the following Swift files to your project:

Folder	Files
Models/	ArticleDTO.swift, CDArticle+CoreDataClass.swift, CDArticle+CoreDataProperties.swift
Network/	NetworkManager.swift, ImageLoader.swift
Repository/	ArticlesRepository.swift, ArticlesRepositoryProtocol.swift
CoreData/	CoreDataStack.swift
ViewModels/	ArticlesViewModel.swift
Views/	ArticlesViewController.swift, ArticlesViewController.xib, ArticleCell.swift
Extensions/	CDArticle+Extension.swift
Resources/	Assets.xcassets, Info.plist, ReaderModel.xcdatamodeld

Then organize your Xcode groups accordingly.

4️⃣ Add a placeholder image

Add a placeholder asset named placeholder.png in Assets.xcassets
Used when article images fail to load.

5️⃣ Configure the API Key

Get a free API key from https://newsapi.org
.

In NetworkManager.swift, set your key:

private let apiKey = "YOUR_NEWSAPI_KEY_HERE"


The app uses the endpoint:

https://newsapi.org/v2/top-headlines?country=us&apiKey=YOUR_KEY

6️⃣ Build & Run

Select your simulator (e.g., iPhone 15)

Press ⌘R to build & run

The app will:

Load cached articles (from Core Data)

Fetch latest top headlines

Allow searching and bookmarking

Work offline using cached data

🧩 Architecture Overview

The project follows MVVM + Repository pattern with clear separation of concerns.

Reader/
├── Models/
│   ├── ArticleDTO.swift
│   ├── CDArticle+CoreDataClass.swift
│   ├── CDArticle+CoreDataProperties.swift
│
├── Network/
│   ├── NetworkManager.swift
│   └── ImageLoader.swift
│
├── CoreData/
│   └── CoreDataStack.swift
│
├── Repository/
│   ├── ArticlesRepository.swift
│   └── ArticlesRepositoryProtocol.swift
│
├── ViewModels/
│   └── ArticlesViewModel.swift
│
├── Views/
│   ├── ArticlesViewController.swift
│   ├── ArticlesViewController.xib
│   └── Cells/
│       └── ArticleCell.swift
│
├── Extensions/
│   └── CDArticle+Extension.swift
│
└── Resources/
    └── ReaderModel.xcdatamodeld

💾 Core Data Design
Entity	CDArticle
id	Unique identifier (String)
title	Article title
author	Author name
content	Full article text
url	Article link
urlToImage	Image URL
publishedAt	Date
isBookmarked	Boolean (default false)

Managed by:

CoreDataStack → sets up NSPersistentContainer

ArticlesRepository → handles save, fetch, delete, toggle bookmark

🧠 Components Overview
Component	Purpose
NetworkManager	Fetches news from NewsAPI
ImageLoader	Caches and loads images asynchronously
ArticlesRepository	Bridges Core Data + network layer
ArticlesViewModel	Prepares data for display & handles filtering
ArticlesViewController	Displays articles list and bookmarks
CoreDataStack	Encapsulates NSPersistentContainer setup
CDArticle Extension	Adds helper functions like mapping DTOs
ArticleCell	Reusable table view cell for article display
🧪 Test Suite Overview

All logic layers are verified using XCTest for correctness and stability.
Tests use in-memory Core Data stores — no persistence side effects.

✅ Test Files
File	Description
NewsAPIResponseTests.swift	Tests decoding of NewsAPI JSON into ArticleDTO and NewsAPIResponse
CoreDataStackTests.swift	Validates Core Data stack initialization, context save, and fetch
CDArticleTests.swift	Ensures Core Data entity CRUD operations work correctly
CDArticleExtensionTests.swift	Verifies DTO → CDArticle mapping extensions
ArticlesRepositoryTests.swift	Tests repository logic (save, load, toggle bookmark, fetchRemote)
NetworkManagerTests.swift	Checks API success/failure responses using mocked URLProtocol
ImageLoaderTests.swift	Tests image caching and async image download flow
🧰 Run Tests

In Xcode: ⌘U or Product → Test

All test cases run under the ReaderTests target

Expected output: ✅ All tests pass

🧱 Folder Organization
Folder	Description
Models/	DTOs and Core Data entities
Network/	API & image networking layer
CoreData/	Core Data management classes
Repository/	Handles persistence and data source coordination
ViewModels/	Presentation logic
Views/	UIKit components and layout
Extensions/	Helpers & Core Data mapping
ReaderTests/	XCTest unit tests

🧰 Tools & Frameworks
Layer	Technology
UI	UIKit + XIBs
Architecture	MVVM + Repository
Persistence	Core Data
Networking	URLSession
Testing	XCTest
Language	Swift 5+

⚙️ Features Summary
Feature	Description
🔄 Pull-to-Refresh	Fetches latest headlines
🔍 Search	Filters articles by title
📑 Bookmark	Toggles and persists bookmarks
📡 Offline Mode	Displays cached Core Data results
🧠 Core Data	Persistent local storage
🖼 Image Loader	Cached async image downloads
✅ Unit Tests	High coverage of all layers
