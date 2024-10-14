<p align="center">
 <img alt="A" title="B" src="https://github.com/user-attachments/assets/65f88513-376c-4778-906e-a0722c463678" width="150">
 <h1 align="center"> Giffy</h1> 
<p align="center">
<br>

<p align="center">
     <img alt="A" title="B" src="https://github.com/uwaisalqadri/GiphyGIF/assets/55146646/2d216304-130c-4007-8308-efbf85f0732d" width="200">
    <img alt="B" title="B" src="https://github.com/uwaisalqadri/GiphyGIF/assets/55146646/cb299bd3-6aff-4dd4-9ed8-990a55a098b6" width="200">
    <img alt="C" title="C" src="https://github.com/uwaisalqadri/GiphyGIF/assets/55146646/b7eb36c1-7e7b-42f9-a2f9-cbd090b7659b" width="200">
    <img alt="D" title="D" src="https://github.com/uwaisalqadri/GiphyGIF/assets/55146646/591de856-cc69-414f-bf41-7b319d1236f2" width="200">
</p>



## <a name="introduction"></a> 🤖 Introduction

Giphy Client App built with some of the interesting iOS tech such as **TCA (The Composable Architecture by Point-Free)**, **Swinject**, Beautiful UI built with **SwiftUI**, **Clean Architecture with Generic Protocol Approach**, **SPM Modularization** and **XcodeGen!**   

**Module**

* **`Giffy`**: the main app with presentation layer
* **`Common`**: domain and data layer
* **`CommonUI`**: common utils and assets
* **`Core`**: generic protocol for _DataSource_ and _Interactor_

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Libraries](#libraries)
- [The Composable Architecture](#composable-architecture)
- [Dependency Injection](#dependency-injection)
- [Project Structure](#project-structure)

## <a name="features"></a> 🦾 Features

- Sharing, Copy-Pasting, and AirDropping GIFs and Stickers
- Search GIFs from various sources (Giphy and Tenor
- Save Favorite GIFs
- Widget, Live Activty, and Dynamic Island
- Animations!

⚠️ **`This project have no concern about backward compatibility, and only support the very latest or experimental api`** ⚠️

## <a name="installation"></a> 💿 Installation

With the greatness of _**XcodeGen**_ you can simply execute :

```
xcodegen
```

Rate my [XcodeGen setup!](https://github.com/uwaisalqadri/GiphyGIF/blob/master/project.yml)

## <a name="libraries"></a> 💡 Libraries

* [Swift's New Concurrency](https://developer.apple.com/news/?id=2o3euotz)
* [SDWebImage](https://github.com/SDWebImage/SDWebImage)
* [SwiftUI](https://developer.apple.com/documentation/swiftui)
* [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
* [XcodeGen](https://github.com/yonaskolb/XcodeGen)
* [SwiftLint](https://github.com/realm/SwiftLint)
* [Swinject](https://github.com/Swinject/Swinject)
* [CoreData](https://developer.apple.com/documentation/coredata)

## <a name="composable-architecture"></a> 💨 TCA: Reducer, Action, State, and Store

Define your screen's _**State**_ and _**Action**_

```swift
 public struct State: Equatable {
    public var list: [Giphy] = []
    public var errorMessage: String = ""
    public var isLoading: Bool = false
    public var isError: Bool = false
  }
  
  public enum Action {    
    case fetch(request: String)
    case removeFavorite(item: Giphy, request: String)
    
    case success(response: [Giphy])
    case failed(error: Error)
  }
```

Setup the _**Reducer**_ 

```swift
public struct FavoriteReducer: Reducer {
  
  private let useCase: FavoriteInteractor
  private let removeUseCase: RemoveFavoriteInteractor
  
  init(useCase: FavoriteInteractor, removeUseCase: RemoveFavoriteInteractor) {
    self.useCase = useCase
    self.removeUseCase = removeUseCase
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .fetch(let request):
        state.isLoading = true
        return .run { send in
          do {
            let response = try await self.useCase.execute(request: request)
            await send(.success(response: response))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .success(let data):
        state.list = data
        state.isLoading = false
        return .none
        
      case .failed:
        state.isError = true
        state.isLoading = false
        return .none
        
      case .removeFavorite(let item, let request):
        return .run { send in
          do {
            let response = try await self.removeUseCase.execute(request: item)
            await send(.fetch(request: request))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      }
    }
  }
}
```

**Composing** the Reducer
```swift
struct MainTabView: View {
  let store: StoreOf<MainTabReducer>

  var body: some View {
    WithViewStore(store, observe: \.selectedTab) { viewStore in
      NavigationView {
        ZStack {
          switch viewStore.state {
          case .home:
            HomeView(
              store: store.scope(
                state: \.home,
                action: \.home
              )
            )
            
          case .search:
            SearchView(
              store: store.scope(
                state: \.search,
                action: \.search
              )
            )
          }
          
          . . . .

        }
      }
    }
  }
}
```

_"consistent and understandable"_ **- Point-Free**


Let your _**Store**_(d) _**Reducer**_ update the View

```swift
struct FavoriteView: View {
  let store: StoreOf<FavoriteReducer>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        SearchField { query in
          viewStore.send(.fetch(request: query))
        }.padding(.vertical, 20)
        
        if viewStore.state.list.isEmpty {
          FavoriteEmptyView()
            .padding(.top, 50)
        }
        
        LazyVStack {
          ForEach(viewStore.state.list, id: \.id) { item in
            GiphyItemRow(
              isFavorite: true,
              giphy: item,
              onTapRow: { giphy in
                viewStore.send(.showDetail(item: giphy))
              },
              onFavorite: { giphy in
                viewStore.send(.removeFavorite(item: giphy, request: ""))
              }
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
          }
        }
      }
      .padding(.horizontal, 10)
      .navigationTitle(FavoriteString.titleFavorite.localized)
      .onAppear {
        viewStore.send(.fetch(request: ""))
      }
    }
  }
}
```

Read more about [**The Composable Architecture**](https://github.com/pointfreeco/swift-composable-architecture)

## <a name="dependency-injection"></a> 🚀 Dependency Injection

Here i'm using _**Swinject**_ for Dependency Injection

```swift
import Swinject

class Injection {
  static let shared = Injection()
  private let container = Container()

  init() {
    registerSearchFeature()
  }

  . . . .

  private func registerSearchFeature() {
    container.register(SearchInteractor.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(SearchGiphyRepository<SearchRemoteDataSource>.self) { [unowned self] _ in
      SearchGiphyRepository(remoteDataSource: self.resolve())
    }
    container.register(SearchRemoteDataSource.self) { _ in
      SearchRemoteDataSource()
    }
  }

  public static func resolve<T>() -> T {
    Injection().resolve()
  }

  public static func resolve<T, A>(argument: A) -> T {
    Injection().resolve(argument: argument)
  }

  public static func resolve<T>(name: String) -> T {
    Injection().resolve(name: name)
  }

  private func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }

  private func resolve<T, A>(argument: A) -> T {
    guard let result = container.resolve(T.self, argument: argument) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }

  private func resolve<T>(name: String) -> T {
    guard let result = container.resolve(T.self, name: name) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }
}
```

### Usage:
```
Injection.resolve()
```

Read more about [**Swinject**](https://github.com/Swinject/Swinject)

## <a name="buy-me-coffee"></a> ☕️ Buy Me a Coffee
If you like this project please support me by <a href="https://www.buymeacoffee.com/uwaisalqadri" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-blue.png" alt="Buy Me A Coffee" height=32></a> ;-)

## <a name="project-structure"></a> 🏛 Project Structure

**`Giffy`**:

 - `Dependency`
 - `App`
 - `Module`
    - `Home`
    - `Detail`
    - `Favorite`
    - `Search`


 - `**GiffyWidget**`
 - `**GiffyTests**`

**`Modules`**:

**`Common`**:
 - `Data`
    - `API`
    - `DB`
    - `DataSource`
        - `Local`
        - `Remote`
    - `Entity`
    - `Repository`
- `Domain`
    - `Model`
    - `Mapper`

**`CommonUI`**: 
 - `Assets`
 - `Extensions`
 - `Modifier`
 - `Utils`

[**`Core`**](https://github.com/uwaisalqadri/CoreModule): 
 - `DataSource`
 - `Extension`
 - `Repository`
 - `UseCase`
