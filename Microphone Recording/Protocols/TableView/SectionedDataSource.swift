//
//  SectionedDataSource.swift
//  Fortu Wealth
//
//  Created by Andrew Chersky on 06.02.2021.
//

import ReactiveCocoa
import ReactiveSwift

protocol ReactiveDataSource: UITableViewDataSource, UITableViewDelegate {
    func bind(with structure: SignalProducer<[TableViewSection], Never>)
    func bind(with structure: MutableProperty<[TableViewSection]>)
}

extension Reactive where Base: UITableView {
    
    func set<DataSource: ReactiveDataSource>(dataSource: DataSource) {
        base.dataSource = dataSource
        base.delegate = dataSource
    }
    
}
