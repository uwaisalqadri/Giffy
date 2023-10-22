<h1 align="center"> GiphyGIF</h1> <br>
<p align="center">
     <img alt="A" title="B" src="https://github.com/uwaisalqadri/GiphyGIF/assets/55146646/2d216304-130c-4007-8308-efbf85f0732d" width="200">
    <img alt="B" title="B" src="https://github.com/uwaisalqadri/GiphyGIF/assets/55146646/cb299bd3-6aff-4dd4-9ed8-990a55a098b6" width="200">
    <img alt="C" title="C" src="https://github.com/uwaisalqadri/GiphyGIF/assets/55146646/b7eb36c1-7e7b-42f9-a2f9-cbd090b7659b" width="200">
    <img alt="D" title="D" src="https://github.com/uwaisalqadri/GiphyGIF/assets/55146646/591de856-cc69-414f-bf41-7b319d1236f2" width="200">
</p>



## <a name="introduction"></a> 🤖 Introduction

Giphy Client App built with some of the interesting iOS tech such as **TCA (The Composable Architecture by Point-Free)**, **Swinject**, **Coordinator Pattern**, Beautiful UI built with **SwiftUI**, **Clean Architecture with Generic Protocol Approach**, **SPM Modularization** and **XcodeGen!**   

**Module**

* **`GiphyGIF`**: the main app with presentation layer
* **`Giphy`**: domain and data layer
* **`Common`**: common utils and assets
* **`Core`**: generic protocol for _DataSource_ and _Interactor_

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Libraries](#libraries)
- [The Composable Architecture](#composable-architecture)
- [Coordinator Pattern](#coordinator-pattern)
- [Dependency Injection](#dependency-injection)
- [Project Structure](#project-structure)

## <a name="features"></a> 🦾 Features

- Sharing, Copy-Pasting, and AirDropping GIFs and Stickers
- Search GIFs
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
* [The Composabable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
* [XcodeGen](https://github.com/yonaskolb/XcodeGen)
* [SwiftLint](https://github.com/realm/SwiftLint)
* [Swinject](https://github.com/Swinject/Swinject)
* [CoreData](https://developer.apple.com/documentation/coredata)
* [TCACoordinators](https://github.com/johnpatrickmorgan/TCACoordinators)

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
      ZStack {
        switch viewStore.state {
        case .home:
          AppCoordinatorView(
            coordinator: store.scope(
              state: \.homeTab,
              action: { .homeTab($0) }
            )
          )
        case .search:
          AppCoordinatorView(
            coordinator: store.scope(
              state: \.searchTab,
              action: { .searchTab($0) }
            )
          )
        }

        VStack {
          Spacer()
          TabView(currentTab: viewStore.binding(send: MainTabReducer.Action.selectedTabChanged))
            .padding(.bottom, 20)
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

## <a name="coordinator-pattern"></a> ⚙️ Navigation Between Screens Done with Coordinator Pattern supported by [TCACoodinators!](https://github.com/johnpatrickmorgan/TCACoordinators)

<img width="1232" alt="Screenshot 2023-10-17 at 7 19 53 PM" src="https://github.com/uwaisalqadri/GiphyGIF/assets/55146646/ba07c117-692a-4cad-aab6-36b95ab9e9e6">

```swift
struct AppCoordinatorView: View {
  let coordinator: StoreOf<AppCoordinator>
  
  var body: some View {
    TCARouter(coordinator) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .detail:
          CaseLet(
            /AppScreen.State.detail,
             action: AppScreen.Action.detail,
             then: DetailView.init
          )
        case .favorite:
          CaseLet(
            /AppScreen.State.favorite,
             action: AppScreen.Action.favorite,
             then: FavoriteView.init
          )
        case .home:
          CaseLet(
            /AppScreen.State.home,
             action: AppScreen.Action.home,
             then: HomeView.init
          )
        case .search:
          CaseLet(
            /AppScreen.State.search,
             action: AppScreen.Action.search,
             then: SearchView.init
          )
        }
      }
    }
  }
}
```

```swift
public struct AppScreen: Reducer {
  public enum State: Equatable {
    case detail(DetailReducer.State)
    case favorite(FavoriteReducer.State)
    case home(HomeReducer.State)
    case search(SearchReducer.State)
  }
  
  public enum Action {
    case detail(DetailReducer.Action)
    case favorite(FavoriteReducer.Action)
    case home(HomeReducer.Action)
    case search(SearchReducer.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.detail, action: /Action.detail) {
      DetailReducer(checkUseCase: Injection.shared.resolve(), addUseCase: Injection.shared.resolve(), removeUseCase: Injection.shared.resolve())
    }
    
    Scope(state: /State.favorite, action: /Action.favorite) {
      FavoriteReducer(useCase: Injection.shared.resolve(), removeUseCase: Injection.shared.resolve())
    }
    
    Scope(state: /State.home, action: /Action.home) {
      HomeReducer(useCase: Injection.shared.resolve())
    }
    
    Scope(state: /State.search, action: /Action.search) {
      SearchReducer(useCase: Injection.shared.resolve())
    }
  }
}
```

```swift
public struct AppCoordinator: Reducer {
  public struct State: Equatable, IndexedRouterState {
    public static let rootHomeState = AppCoordinator.State(
      routes: [.root(.home(.init()), embedInNavigationView: true)]
    )
    
    public static let rootSearchState = AppCoordinator.State(
      routes: [.root(.search(.init()), embedInNavigationView: true)]
    )
    
    public var routes: [Route<AppScreen.State>]
  }
  
  public enum Action: IndexedRouterAction {
    case routeAction(Int, action: AppScreen.Action)
    case updateRoutes([Route<AppScreen.State>])
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .routeAction(_, action: .home(.showDetail(item))):
        state.routes.presentSheet(.detail(.init(item: item)))
        
      case .routeAction(_, action: .home(.openFavorite)):
        state.routes.push(.favorite(.init()))
        
      case let .routeAction(_, action: .search(.showDetail(item))):
        state.routes.presentSheet(.detail(.init(item: item)))
        
      case .routeAction(_, action: .search(.openFavorite)):
        state.routes.push(.favorite(.init()))
        
      case let .routeAction(_, action: .favorite(.showDetail(item))):
        state.routes.presentSheet(.detail(.init(item: item)))
        
      default:
        break
      }
      
      return .none
      
    }.forEachRoute {
      AppScreen()
    }
  }
}

```

## <a name="dependency-injection"></a> 🚀 Dependency Injection

Here i'm using _**Swinject**_ for Dependency Injection

```swift
import Swinject

class Injection {
  static let shared = Injection()
  private let container = Container()

  init() {
    registerFavoriteFeature()
  }

  . . . .

  private func registerFavoriteFeature() {
    container.register(FavoriteView.self) { [unowned self] _ in
      FavoriteView(holder: self.resolve(), router: self.resolve(), store: self.resolve())
    }
    
    container.register(StoreOf<FavoriteReducer>.self) { [unowned self] _ in
      Store(initialState: FavoriteReducer.State()) {
        FavoriteReducer(useCase: self.resolve(), removeUseCase: self.resolve())
      }
    }

    . . . .
  }

  func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }

  func resolve<T, A>(argument: A) -> T {
    guard let result = container.resolve(T.self, argument: argument) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }
  func resolve<T>(name: String) -> T {
    guard let result = container.resolve(T.self, name: name) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }
}
```
Read more about [**Swinject**](https://github.com/Swinject/Swinject)

## <a name="buy-me-coffee"></a> ☕️ Buy Me a Coffee
If you like this project please support me by <a href="https://www.buymeacoffee.com/uwaisalqadri" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-blue.png" alt="Buy Me A Coffee" height=32></a> ;-)

## <a name="project-structure"></a> 🏛 Project Structure

**`GiphyGIF`**:

 - `Dependency`
 - `App`
 - `Module`
    - `Home`
    - `Detail`
    - `Favorite`
    - `Search`


 - `**GiphyWidget**`

**`Modules`**:

**`Giphy`**:
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

**`Common`**: 
 - `Assets`
 - `Extensions`
 - `Modifier`
 - `Utils`

[**`Core`**](https://github.com/uwaisalqadri/CoreModule): 
 - `DataSource`
 - `Extension`
 - `Repository`
 - `UseCase`
