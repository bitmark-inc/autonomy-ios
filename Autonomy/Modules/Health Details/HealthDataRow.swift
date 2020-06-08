//
//  HealthDataRow.swift
//  Autonomy
//
//  Created by Thuyen Truong on 6/5/20.
//  Copyright © 2020 Bitmark Inc. All rights reserved.
//

import UIKit

class HealthDataRow: UIView {

    // MARK: - Properties
    fileprivate let info: String!

    fileprivate lazy var infoLabel = makeInfoLabel()
    fileprivate lazy var numberLabel = makeNumberLabel()
    fileprivate lazy var deltaView = makeDeltaView()
    fileprivate lazy var deltaImageView = makeDeltaImageView()
    fileprivate lazy var numberInfoLabel = makeNumberInfoLabel()

    init(info: String) {
        self.info = info
        super.init(frame: CGRect.zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupViews() {

        let numberView = UIView()
        numberView.addSubview(numberLabel)
        numberView.addSubview(deltaView)

        numberLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(5)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(deltaView.snp.leading).offset(Size.dw(15))
        }

        deltaView.snp.makeConstraints { (make) in
            make.width.equalTo(Size.dw(73))
            make.top.bottom.trailing.equalToSuperview()
        }

        addSubview(infoLabel)
        addSubview(numberLabel)
        addSubview(deltaView)

        infoLabel.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalTo(numberLabel.snp.leading)
        }

        numberLabel.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.top.bottom.equalTo(infoLabel)
        }

        deltaView.snp.makeConstraints { (make) in
            make.leading.equalTo(numberLabel.snp.trailing)
            make.top.bottom.trailing.equalToSuperview()
        }
    }
}

extension HealthDataRow {
    fileprivate func makeInfoLabel() -> Label {
        let label = Label()
        label.numberOfLines = 0
        label.apply(text: info, font: R.font.atlasGroteskLight(size: 14),
                    themeStyle: .lightTextColor)
        return label
    }

    fileprivate func makeNumberLabel() -> Label {
        let label = Label()
        label.textAlignment = .right
        label.font = R.font.ibmPlexMonoLight(size: 14)
        return label
    }

    fileprivate func makeDeltaView() -> UIView {
        let view = UIView()
        view.addSubview(deltaImageView)
        view.addSubview(numberInfoLabel)

        numberInfoLabel.snp.makeConstraints { (make) in
            make.top.trailing.bottom.equalToSuperview()
        }

        deltaImageView.snp.makeConstraints { (make) in
            make.trailing.equalTo(numberInfoLabel.snp.leading).offset(-2)
            make.top.bottom.equalToSuperview()
        }

        return view
    }

    fileprivate func makeDeltaImageView() -> UIImageView {
        return UIImageView()
    }

    fileprivate func makeNumberInfoLabel() -> Label { // delta / rating
        let label = Label()
        label.font = R.font.ibmPlexMonoLight(size: 14)
        return label
    }
}
