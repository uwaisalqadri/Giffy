<h1 align="center"> GiphyGIF</h1> <br>
<p align="center">
  <a href="https://gitpoint.co/">
    <img alt="Mangaku" title="Mangaku" src="https://github.com/uwaisalqadri/GiphyGIF/assets/55146646/4633702f-475b-469a-b75c-30ad1cbae8e5" width="500">
  </a>
</p>

## <a name="introduction"></a> 🤖 Introduction

Giphy Client App with implementation of shiny tech such as **TCA (The Composable Architecture by Pointfreeco)**, **Swinject**, **Coordinator Pattern**, Beautiful UI built with **SwiftUI**, **Clean Architecture with Generic Protocol Approach**, **SPM Modularization** and **XcodeGen!**   

**Module**

* **`GiphyGIF`**: the main app with presentation layer
* **`Giphy`**: domain and data layer
* **`Common`**: common utils and assets
* **`Core`**: generic protocol for _DataSource_ and _Interactor_

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Libraries](#libraries)
- [The Composable Architecture](#composable-architecture)
- [Dependency Injection](#dependency-injection)
- [Coordinator Pattern](#coordinator-pattern)
- [Project Structure](#project-structure)

## <a name="features"></a> 🦾 Features

![image](https://media.giphy.com/media/3o72FkiKGMGauydfyg/giphy.gif)

⚠️ **`This project have no concern about backward compatibility, and only support the very latest or experimental api`** ⚠️

## <a name="screenshot"></a> 📸 Screenshot

![image](https://media.giphy.com/media/3o72FkiKGMGauydfyg/giphy.gif)

## <a name="libraries"></a> 💡 Libraries

* [Swift's New Concurrency](https://developer.apple.com/news/?id=2o3euotz)
* [SDWebImage](https://github.com/SDWebImage/SDWebImage)
* [SwiftUI](https://developer.apple.com/documentation/swiftui)
* [The Composabable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
* [XcodeGen](https://github.com/yonaskolb/XcodeGen)
* [SwiftLint](https://github.com/realm/SwiftLint)
* [Swinject](https://github.com/Swinject/Swinject)
* [CoreData](https://developer.apple.com/documentation/coredata)

## <a name="composable-architecture"></a> 💨 TCA: Reducer, Action, State, and Store

![image](https://github.com/uwaisalqadri/GiphyGIF/assets/55146646/dfeee2c2-851f-4a49-aac0-f5effbd711e5)

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

_"consistent and understandable"_ **- Pointfreeco**


Let your _**Store**_(d) _**Reducer**_ update the View

```swift
struct FavoriteView: ViewControllable {
  var holder: Common.NavStackHolder
  let router: DetailRouter
  
  var store: StoreOf<FavoriteReducer>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        SearchInput { query in
          viewStore.send(.fetch(request: query))
        }.padding(.top, 30)

        if !viewStore.state.list.isEmpty {
          LazyVStack {
            ForEach(
              Array(viewStore.state.list.enumerated()),
              id: \.offset
            ) { _, item in
              SearchRow(isFavorite: true, giphy: item, onTapRow: { giphy in
                guard let viewController = holder.viewController else { return }
                router.routeToDetail(from: viewController, giphy: giphy)
              }, onRemoveFavorite: { giphy in
                viewStore.send(.removeFavorite(item: giphy, request: ""))
              })
              .padding(.vertical, 20)
              .padding(.horizontal, 20)
            }
          }
        } else {
          emptyFavoriteView.padding(.top, 50)
        }

      }
      .navigationTitle(FavoriteString.titleFavorite.localized)
      .onAppear {
        viewStore.send(.fetch(request: ""))
      }
      .onDisappear {
        viewStore.send(.fetch(request: ""))
      }
    }
  }
  
  var emptyFavoriteView: some View {
    VStack {
      LottieView(fileName: "add_to_favorite", bundle: Bundle.common, loopMode: .loop)
        .frame(width: 220, height: 220)
      Text(FavoriteString.labelFavoriteEmpty.localized)
    }
  }

}
```

Read more about [**The Composable Architecture**](https://github.com/pointfreeco/swift-composable-architecture)

## <a name="dependency-injection"></a> 🚀 Dependency Injection
![image](https://media.giphy.com/media/3o72FkiKGMGauydfyg/giphy.gif)

## <a name="coordinator-pattern"></a> ⚙️ Coordinator Pattern with NavigationStack!
![image](https://media.giphy.com/media/3o72FkiKGMGauydfyg/giphy.gif)

## <a name="buy-me-coffee"></a> ☕️ Buy Me a Coffee
If you like this project please support me by <a href="https://www.buymeacoffee.com/uwaisalqadri" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-blue.png" alt="Buy Me A Coffee" height=32></a> ;-)

## <a name="project-structure"></a> 🏛 Project Structure

**`GiphyGIF`**:

 - `Dependency`
 - `App`
 - `Module`
    - `Home`
        - `Router`
        - `Views`
    - `Detail`
    - `Favorite`
    - `Search`


 - `+ **GiphyWidget**`

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
