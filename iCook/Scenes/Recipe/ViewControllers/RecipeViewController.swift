//
//  RecipeViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit
import RxCocoa

class RecipeViewController: SceneViewController<RecipeViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var fiveStarView: FiveStarView!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var recipeStepsTextView: UITextView!
    @IBOutlet private weak var noCommentsLabel: UILabel!
    @IBOutlet private weak var commentsTableView: UITableView!
    @IBOutlet private weak var commentsLabel: UILabel!
    
    // MARK: - Properties
    
    private let commentCellReuseId = "commentCell"
    private let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    
    // MARK: - Setup
    
    override func setupViews() {
        super.setupViews()
        commentsTableView.tableFooterView = UIView()  // remove extra horizontal lines
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        let output = viewModel.transform(RecipeViewModel.Input(
            viewDidAppear: rx.viewDidAppear.map { _ in }.asObservable(),
            doneButtonTapped: doneButton.rx.tap.asObservable(),
            stepsText: recipeStepsTextView.rx.text.orEmpty.asObservable()
        ))
        
        output.recipeText.drive(recipeStepsTextView.rx.text).disposed(by: disposeBag)
        output.authorInfoText.drive(authorLabel.rx.text).disposed(by: disposeBag)
        output.ratingIsHidden.drive(fiveStarView.rx.isHidden).disposed(by: disposeBag)
        output.commentsAreHidden.drive(commentsTableView.rx.isHidden).disposed(by: disposeBag)
        output.commentLabelIsHidden.drive(commentsLabel.rx.isHidden).disposed(by: disposeBag)
        output.noCommentsTextIsHidden.drive(noCommentsLabel.rx.isHidden).disposed(by: disposeBag)
        output.stepsTextIsEditable.drive(onNext: updateTextViewIsEditable).disposed(by: disposeBag)
        output.doneButtonIsHidden.drive(onNext: updateDoneButtonVisibility).disposed(by: disposeBag)
        output.recipeRating.drive(onNext: fiveStarView.configureStars).disposed(by: disposeBag)
        
        output.commentViewModels.drive(commentsTableView.rx.items(
            cellIdentifier: commentCellReuseId,
            cellType: CommentTableViewCell.self)
        ) { row, viewModel, cell in
            cell.configure(with: viewModel)
        }.disposed(by: disposeBag)
    }
}

// MARK: - Helpers

private extension RecipeViewController {
    func updateDoneButtonVisibility(isHidden: Bool) {
        navigationItem.rightBarButtonItem = isHidden ? nil : doneButton
        doneButton.isEnabled = !isHidden
    }
    
    func updateTextViewIsEditable(_ isEditable: Bool) {
        recipeStepsTextView.isEditable = isEditable
    }
}
