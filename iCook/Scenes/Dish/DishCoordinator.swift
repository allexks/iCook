//
//  DishCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class DishCoordinator: Coordinator {
    
    private let viewController: UIViewController
    private let services: ServiceDependencies
    private let dishId: Int
    
    private let navControllerWrapper: UINavigationController = {
        let result = UINavigationController()
        result.modalPresentationStyle = .fullScreen
        return result
    }()
    
    private lazy var dishViewController: DishViewController = {
        let result = DishViewController.instantiateFromStoryboard()
        result.viewModel = dishViewModel
        return result
    }()
    
    private lazy var dishViewModel: DishViewModel = {
        let result = DishViewModel(dishId: dishId, dishService: services.dishService)
        result.coordinatorDelegate = self
        return result
    }()
    
    init(in viewController: UIViewController, services: ServiceDependencies, dishId: Int) {
        self.viewController = viewController
        self.services = services
        self.dishId = dishId
    }
    
    func start() {
        navControllerWrapper.setViewControllers([dishViewController], animated: false)
        viewController.present(navControllerWrapper, animated: true, completion: nil)
        dishViewModel.load()
    }
    
    func finish() {
        navControllerWrapper.dismiss(animated: true, completion: nil)
    }
}

extension DishCoordinator: DishViewModelCoordinatorDelegate {
    func goToTakeaway() {
        // TODO
    }
    
    func goToAddRecipe() {
        // TODO
    }
}
