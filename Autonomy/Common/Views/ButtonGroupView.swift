//
//  ButtonGroupView.swift
//  Autonomy
//
//  Created by Thuyen Truong on 3/26/20.
//  Copyright © 2020 Bitmark Inc. All rights reserved.
//

import UIKit

class ButtonGroupView: UIView {

    fileprivate lazy var gradientLayerView = makeGradientLayerView()
    let viewHeight: CGFloat = 50
    let viewHeightWithGradient: CGFloat = 117
    fileprivate let defaultBackgroundColor = UIColor(hexString: "#1B1B1B")!

    init(button1: UIView, button2: UIView, hasGradient: Bool = false) {
        super.init(frame: CGRect.zero)

        let buttonsLine = UIView()
        buttonsLine.addSubview(button1)
        buttonsLine.addSubview(button2)

        button1.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
        }

        button2.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalToSuperview()
        }

        addSubview(buttonsLine)
        buttonsLine.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
                .inset(OurTheme.paddingInset)
        }

        if hasGradient {
            addSubview(gradientLayerView)

            gradientLayerView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }

            snp.makeConstraints { (make) in
                make.height.equalTo(viewHeightWithGradient)
            }
        } else {
            backgroundColor = defaultBackgroundColor
            buttonsLine.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(OurTheme.paddingInset.top)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ButtonGroupView {
    fileprivate func makeGradientLayerView() -> UIView {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [
            defaultBackgroundColor.withAlphaComponent(0).cgColor,
            defaultBackgroundColor.withAlphaComponent(0.6).cgColor,
            defaultBackgroundColor.withAlphaComponent(1).cgColor
        ]
        gradient.locations = [0.0 , 0.22, 0.45]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: viewHeightWithGradient)

        let view = UIView()
        view.backgroundColor = .clear
        view.layer.insertSublayer(gradient, at: 0)
        return view
    }
}
