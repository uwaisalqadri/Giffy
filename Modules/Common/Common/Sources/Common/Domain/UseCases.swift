//
//  UseCases.swift
//
//
//  Created by Uwais Alqadri on 26/10/24.
//

import Core
import UIKit

public typealias AIGenUseCase = Interactor<
  String, [String], AIGenInteractor<
    AIGenDataSource
  >
>

public typealias BackgroundRemovalUseCase = Interactor<
  CIImage, ImageData, BackgroundRemovalInteractor<
    ImageVisionDataSource
  >
>

public typealias FavoriteUseCase = Interactor<
  String, [Giffy], FavoriteGiphysInteractor<
    FavoriteLocalDataSource
  >
>

public typealias RemoveFavoriteUseCase = Interactor<
  Giffy, Bool, RemoveFavoriteInteractor<
    FavoriteLocalDataSource
  >
>

public typealias AddFavoriteUseCase = Interactor<
  Giffy, Giffy, AddFavoriteInteractor<
    FavoriteLocalDataSource
  >
>

public typealias CheckFavoriteUseCase = Interactor<
  String, Bool, CheckFavoriteInteractor<
    FavoriteLocalDataSource
  >
>

public typealias HomeUseCase = Interactor<
  Int, [Giffy], GetGiphyInteractor<
    TrendingRemoteDataSource
  >
>

public typealias SearchUseCase = Interactor<
  String, [Giffy], SearchGiphyInteractor<
    SearchRemoteDataSource
  >
>
