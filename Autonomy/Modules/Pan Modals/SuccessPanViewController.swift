//
//  SuccessPanViewController.swift
//  Autonomy
//
//  Created by Thuyen Truong on 3/31/20.
//  Copyright © 2020 Bitmark Inc. All rights reserved.
//

import Moya
import RxSwift
import UIKit
import RxCocoa
import PanModal

class SuccessPanViewController: ViewController, PanModalPresentable {

    // *** Override Properties in PanModal ***
    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        view.layoutIfNeeded()
        return .contentHeight(paddingContentView.frame.size.height + 85)
    }

    var longFormHeight: PanModalHeight {
        view.layoutIfNeeded()
        return .contentHeight(paddingContentView.frame.size.height + 85)
    }

    var cornerRadius: CGFloat = 0.0
    var allowsDragToDismiss = false

    // MARK: - Properties
    var paddingContentView: UIView!
    lazy var headerScreen: HeaderView = {
        HeaderView(header: "")
    }()
    lazy var titleLabel = makeTitleLabel()
    lazy var descLabel = makeDescLabel()
    lazy var gotItButton = LeftIconButton(
        title: R.string.localizable.gotIt().localizedUppercase,
        icon: R.image.tickCircleArrow()!)

    var delegate: PanModalDelegate?

    override func bindViewModel() {
        super.bindViewModel()

        gotItButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }

    deinit {
        delegate?.donePanModel()
    }

    override func setupViews() {
        super.setupViews()

        themeService.rx
            .bind( { $0.mineShaftBackground }, to: contentView.rx.backgroundColor)
            .disposed(by: disposeBag)

        paddingContentView = LinearView(
        items: [
            (headerScreen, 0),
            (titleLabel, 11),
            (descLabel, 15)
        ], bottomConstraint: true)

        contentView.addSubview(paddingContentView)
        contentView.addSubview(gotItButton)

        paddingContentView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
                .inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        }

        gotItButton.snp.makeConstraints { (make) in
            make.top.equalTo(paddingContentView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
    }
}

extension SuccessPanViewController {
    fileprivate func makeTitleLabel() -> Label {
        let label = Label()
        label.numberOfLines = 0
        label.apply(
            font: R.font.domaineSansTextLight(size: 18),
            themeStyle: .lightTextColor, lineHeight: 1.2)
        label.textAlignment = .center
        return label
    }

    fileprivate func makeDescLabel() -> Label {
        let label = Label()
        label.numberOfLines = 0
        label.apply(
            font: R.font.atlasGroteskLight(size: 18),
            themeStyle: .lightTextColor, lineHeight: 1.2)
        label.textAlignment = .center
        return label
    }
}
