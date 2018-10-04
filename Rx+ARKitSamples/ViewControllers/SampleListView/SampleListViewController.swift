//
//  SampleListViewController.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class SampleListViewController: UIViewController, View {
    // MARK typealias
    fileprivate typealias State = SampleListViewReactor.State
    fileprivate typealias Action = SampleListViewReactor.Action
    
    // MARK DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK Life cycle
    init(reactor: SampleListViewReactor = SampleListViewReactor()) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupView()
    }
    
    // MARK Reactor Binder
    func bind(reactor: SampleListViewReactor) {
        bind(state: reactor.state)
        bind(action: reactor.action)
    }
    
    private func bind(state: Observable<State>) {
        state.map({ $0.shouldMoveToVC })
            .filterNil()
            .subscribe(onNext: { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        bindTableView(state: state)
    }
    
    private func bind(action: ActionSubject<Action>) {
        rx.viewDidLoad.map({ Action.refresh })
            .bind(to: action)
            .disposed(by: disposeBag)
        bindTableView(action: action)
    }
    
    // MARK View
    private func setupView() {
        title = "Rx+ARKitSamples"
        view.backgroundColor = UIColor.white
        layoutView()
    }
    
    private func layoutView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK TableView
    public private(set) lazy var tableView: UITableView = UITableView().then {
        $0.register(cell: SampleCell.self)
    }
    
    private func bindTableView(state: Observable<State>) {
        state.map({ $0.sections })
            .bind(to: tableView.rx.items(cell: SampleCell.self)) { row, sampleCellReactor, cell in
                cell.reactor = sampleCellReactor
            }
            .disposed(by: disposeBag)
    }
    
    private func bindTableView(action: ActionSubject<Action>) {
        tableView.rx.modelSelected(SampleCellReactor.self).map({ Action.select($0) }).bind(to: action).disposed(by: disposeBag)
    }
}
