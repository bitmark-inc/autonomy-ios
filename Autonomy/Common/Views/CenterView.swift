//
//  CenterView.swift
//  Autonomy
//
//  Created by Thuyen Truong on 3/26/20.
//  Copyright © 2020 Bitmark Inc. All rights reserved.
//

import UIKit
import RxSwift

class CenterView: UIView {

    // MARK: - Properties
    let disposeBag = DisposeBag()

    init(contentView: UIView) {
        super.init(frame: CGRect.zero)

        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.width.centerX.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
