//
//  AppAssembler.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation

protocol Assembler: HomeAssembler,
                    SearchAssembler,
                    DetailAssembler,
                    FavoriteAssembler {}

class AppAssembler: Assembler {}
