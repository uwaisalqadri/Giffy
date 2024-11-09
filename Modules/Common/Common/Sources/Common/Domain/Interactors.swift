//
//  Interactors.swift
//  
//
//  Created by Uwais Alqadri on 26/10/24.
//

import Core
import UIKit

public typealias BackgroundRemovalInteractor = Interactor<
  CIImage, ImageData, BackgroundRemovalRepository<
    ImageVisionDataSource
  >
>

public typealias FavoriteInteractor = Interactor<
  String, [Giffy], FavoriteGiphysRepository<
    FavoriteLocalDataSource
  >
>

public typealias RemoveFavoriteInteractor = Interactor<
  Giffy, Bool, RemoveFavoriteRepository<
    FavoriteLocalDataSource
  >
>

public typealias AddFavoriteInteractor = Interactor<
  Giffy, Giffy, AddFavoriteRepository<
    FavoriteLocalDataSource
  >
>

public typealias CheckFavoriteInteractor = Interactor<
  String, Bool, CheckFavoriteRepository<
    FavoriteLocalDataSource
  >
>

public typealias HomeInteractor = Interactor<
  Int, [Giffy], GetGiphyRepository<
    TrendingRemoteDataSource
  >
>

public typealias SearchInteractor = Interactor<
  String, [Giffy], SearchGiphyRepository<
    SearchRemoteDataSource
  >
>
