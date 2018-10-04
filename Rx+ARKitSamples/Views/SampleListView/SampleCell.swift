//
//  SampleCell.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

class SampleCell: UITableViewCell, View {
    // MARK typealias
    fileprivate typealias State = SampleCellReactor.State
    
    // MARK DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupView()
    }
    
    // MARK Reactor Binder
    func bind(reactor: SampleCellReactor) {
        bind(state: reactor.state)
    }
    
    private func bind(state: Observable<State>) {
        bindTitleLabel(state: state)
        bindDescriptionLabel(state: state)
    }
    
    // MARK View
    private func setupView() {
        layoutView()
    }
    
    private func layoutView() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(16)
            $0.right.greaterThanOrEqualToSuperview().offset(-16)
        }
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.equalTo(titleLabel)
            $0.right.greaterThanOrEqualToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    // MARK Title Label
    public private(set) lazy var titleLabel: UILabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 21)
        $0.textColor = UIColor.black
    }
    
    private func bindTitleLabel(state: Observable<State>) {
        state.map({ $0.title }).bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    }
    
    // MARK Description Label
    public private(set) lazy var descriptionLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.black
    }
    
    private func bindDescriptionLabel(state: Observable<State>) {
        state.map({ $0.description }).bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
    }
}
