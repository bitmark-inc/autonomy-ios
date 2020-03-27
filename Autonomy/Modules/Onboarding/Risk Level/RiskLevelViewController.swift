//
//  RiskLevelViewController.swift
//  Autonomy
//
//  Created by Thuyen Truong on 3/26/20.
//  Copyright © 2020 Bitmark Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SwifterSwift
import BEMCheckBox

class RiskLevelViewController: ViewController, BackNavigator {

    // MARK: - Properties
    lazy var headerScreen: UIView = {
        HeaderView(header: R.string.localizable.riskLevel().localizedUppercase)
    }()
    lazy var titleScreen = makeTitleScreen()
    lazy var yesRiskCheckboxBox = makeYesRiskCheckboxView()
    lazy var noRiskSelectionBox = makeNoRiskCheckboxView()
    lazy var backButton = makeLightBackItem()
    lazy var doneButton = SubmitButton(buttonItem: .done)
    lazy var groupsButton: UIView = {
        ButtonGroupView(button1: backButton, button2: doneButton)
    }()

    lazy var thisViewModel: RiskLevelViewModel = {
        return viewModel as! RiskLevelViewModel
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - bindViewModel
    override func bindViewModel() {
        super.bindViewModel()

        thisViewModel.riskLevelSelectionRelay
            .map { $0 != nil }
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: disposeBag)

        doneButton.item.rx.tap.bind { [weak self] in
            self?.thisViewModel.signUp()
        }.disposed(by: disposeBag)

        thisViewModel.signUpResultSubject
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (event) in
                guard let self = self else { return }
                switch event {
                case .completed:
                    self.gotoMainScreen()
                case .error(let error):
                    self.errorWhenSignUp(error: error)
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Error Handlers
    fileprivate func errorWhenSignUp(error: Error) {
        guard !AppError.errorByNetworkConnection(error),
            !handleErrorIfAsAFError(error),
            !showIfRequireUpdateVersion(with: error) else {
                return
        }

        Global.log.error(error)
        showErrorAlertWithSupport(message: R.string.error.system())
    }

    // MARK: - Setup views
    override func setupViews() {
        super.setupViews()

        // *** Setup subviews ***
        let paddingContentView = LinearView(
            (headerScreen, 0),
            (titleScreen, 0),
            (SeparateLine(height: 1), 3),
            (makeYesRiskCheckboxViewWithDesc(), 29),
            (SeparateLine(height: 1), 15),
            (noRiskSelectionBox, 29)
        )

        paddingContentView.addSubview(groupsButton)
        groupsButton.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentView.addSubview(paddingContentView)
        paddingContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(OurTheme.paddingInset)
        }

        _ = BEMCheckBoxGroup(checkBoxes: [yesRiskCheckboxBox.checkBox,
                                          noRiskSelectionBox.checkBox])
    }
}

// MARK: - BEMCheckBoxDelegate
extension RiskLevelViewController: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        var riskLevel: RiskLevel?
        if yesRiskCheckboxBox.checkBox.on {
            riskLevel = .high
        } else if noRiskSelectionBox.checkBox.on {
            riskLevel = .low
        }

        thisViewModel.riskLevelSelectionRelay.accept(riskLevel)
    }
}

// MARK: - Navigator
extension RiskLevelViewController {
    fileprivate func gotoMainScreen() {
        let viewModel = MainViewModel()
        navigator.show(segue: .main(viewModel: viewModel), sender: self, transition: .replace(type: .none))
    }
}


// MARK: - Setup views
extension RiskLevelViewController {
    fileprivate func makeTitleScreen() -> CenterView {
        let label = Label()
        label.numberOfLines = 0
        label.apply(text: R.string.phrase.riskLevelDescription(),
                    font: R.font.atlasGroteskLight(size: 36),
                    themeStyle: .lightTextColor, lineHeight: 1.2)
        label.textAlignment = .center
        return CenterView(contentView: label, spacing: 26)
    }

    fileprivate func makeYesRiskCheckboxView() -> CheckboxView {
        let checkboxView = CheckboxView(title: R.string.phrase.riskLevelYes())
        checkboxView.checkBox.delegate = self
        return checkboxView
    }

    fileprivate func makeNoRiskCheckboxView() -> CheckboxView {
        let checkboxView =  CheckboxView(title: R.string.phrase.riskLevelNo())
        checkboxView.checkBox.delegate = self
        return checkboxView
    }

    fileprivate func makeYesRiskCheckboxViewWithDesc() -> UIView {
        let descriptionLabel = Label()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.apply(
            text: R.string.phrase.riskLevelYesDescription(),
            font: R.font.atlasGroteskLight(size: 14),
            themeStyle: .silverChaliceColor, lineHeight: 1.2)

        let view = UIView()
        view.addSubview(yesRiskCheckboxBox)
        view.addSubview(descriptionLabel)

        yesRiskCheckboxBox.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(yesRiskCheckboxBox.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(60)
            make.trailing.bottom.equalToSuperview()
        }

        return view
    }
}