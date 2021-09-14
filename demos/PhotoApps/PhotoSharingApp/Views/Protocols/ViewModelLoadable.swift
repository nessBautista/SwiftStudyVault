//
//  ViewModelLoadable.swift
//  PhotoSharingApp
//
//  Created by Nestor Hernandez on 14/06/21.
//

import Foundation
protocol ViewModelLoadable {
    associatedtype ViewModel
    var viewModel: ViewModel? { get }
    func load(_ viewModel: ViewModel)
}
