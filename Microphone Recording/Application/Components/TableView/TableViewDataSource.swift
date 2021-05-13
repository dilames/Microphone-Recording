//
//  TableViewDataSource.swift
//  Fortu Wealth
//
//  Created by Andrew Chersky on 07.02.2021.
//

import ReactiveSwift
import ReactiveCocoa

protocol AnyViewModelConvertable {
    var viewModel: Any { get }
    func safelyUnwrappedViewModel<ViewModel>() -> ViewModel
}

extension AnyViewModelConvertable {
    func safelyUnwrappedViewModel<ViewModel>() -> ViewModel {
        guard let viewModel = viewModel as? ViewModel else { fatalError("Could not cast viewModel as? \(type(of: self.viewModel))") }
        return viewModel
    }
}

private struct AnyViewModel: ViewModel {
    
}

struct TableViewSection: AnyViewModelConvertable {
    
    let viewModel: Any
    let content: [TableViewRow]
    let kind: Kind
    
    init(viewModel: Any = AnyViewModel(), content: [TableViewRow], kind: Kind = .regular) {
        self.viewModel = viewModel
        self.content = content
        self.kind = kind
    }
    
    enum Kind {
        case regular
        case enclosed
    }
    
}

struct TableViewRow: AnyViewModelConvertable {
    let viewModel: Any
}

final class TableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, ReactiveDataSource {
    
    typealias RowConstructor = (_ tableView: UITableView, _ taableViewRow: TableViewRow, _ indexPath: IndexPath) -> UITableViewCell?
    typealias SectionConstructor = (_ tableView: UITableView, _ viewModelSection: TableViewSection) -> UIView?
    typealias SectionViewHeightConstructor = (_ tableView: UITableView, _ heightForHeaderInSection: Int) -> CGFloat
    
    private var structure: MutableProperty<[TableViewSection]> = MutableProperty([])
    private let sectionViewHeightConstructor: SectionViewHeightConstructor
    private let sectionConstructor: SectionConstructor
    private let rowConstructor: RowConstructor
    
    init(rowConstructor: @escaping RowConstructor,
         sectionConstructor: @escaping SectionConstructor = { _, _ in return nil },
         sectionViewHeightConstructor: @escaping SectionViewHeightConstructor = { _, _ in return 0.0 }) {
        self.rowConstructor = rowConstructor
        self.sectionConstructor = sectionConstructor
        self.sectionViewHeightConstructor = sectionViewHeightConstructor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return structure.value[safe: section]?.content.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return structure.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard
            let kind = structure.value[safe: section]?.kind,
            .regular == kind
        else { return 0.0 }
        return sectionViewHeightConstructor(tableView, section)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewSection = structure.value[safe: indexPath.section] ?? TableViewSection(content: [])
        let tableViewRow = tableViewSection.content[safe: indexPath.row] ?? TableViewRow(viewModel: AnyViewModel())
        return rowConstructor(tableView, tableViewRow, indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let kind = structure.value[safe: section]?.kind,
            .regular == kind
        else { return nil }
        return sectionConstructor(tableView, structure.value[section])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func bind(with structure: SignalProducer<[TableViewSection], Never>) {
        self.structure <~ structure
    }
    
    func bind(with structure: MutableProperty<[TableViewSection]>) {
        self.structure = structure
    }
    
}
