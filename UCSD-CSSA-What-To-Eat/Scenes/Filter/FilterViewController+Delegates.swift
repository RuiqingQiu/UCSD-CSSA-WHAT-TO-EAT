//
//  FilterViewController+Delegates.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Yilun Liu on 10/21/16.
//  Copyright © 2016 Ruiqing Qiu. All rights reserved.
//

import Foundation
import UIKit

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        return sectionItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return sectionItems[section].isExpanded ? cellDescriptors[section].count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CELL_REUSE_IDENTIFIER, for: indexPath) as? RestaurantCell else { return UITableViewCell() }
        cell.configure(isChecked: cellDescriptors[indexPath.section][indexPath.row].checked, title: cellDescriptors[indexPath.section][indexPath.row].label)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UINib.init(nibName: "CategoryHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? CategoryHeaderView

        let state = SelectState(rawValue: sectionItems[section].checked) ?? .None
        headerView?.tag = section
        headerView?.configure(state, isExpand: sectionItems[section].isExpanded, title: sectionItems[section].label)
        headerView?.onPressCheckButton = { [weak self] _ in
            self?.toggleAllInSection(section)
        }
        headerView?.onPressExpandButton = { [weak self] _ in
            self?.expandSection(section)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureExpandSection(_:)))
        headerView?.addGestureRecognizer(gesture)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 44.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 36.0
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        cellDescriptors[indexPath.section][indexPath.row].checked = !cellDescriptors[indexPath.section][indexPath.row].checked
        let count = cellDescriptors[indexPath.section].reduce(0, { result, cellDescriptor in
            return result + (cellDescriptor.checked ? 1 : 0)
        })
        if count == 0 {
            sectionItems[indexPath.section].checked = 0
        } else if count == cellDescriptors[indexPath.section].count {
            sectionItems[indexPath.section].checked = 1
        } else {
            sectionItems[indexPath.section].checked = 2
        }
        tableView.reloadSections([indexPath.section], with: .none)
    }

    // MARK: - Private Helpers

    private func toggleAllInSection( _ section: Int) {

        let selectNum = sectionItems[section].checked == 1 ? 0 : 1
        let select = sectionItems[section].checked == 1 ? false : true
        sectionItems[section].checked = selectNum
        for i in 0 ..< cellDescriptors[section].count {
            cellDescriptors[section][i].checked = select
        }
        tblExpandable.reloadSections([section], with: .none)
    }

    private func expandSection(_ section: Int) {

        sectionItems[section].isExpanded = !sectionItems[section].isExpanded
        tblExpandable.reloadSections([section], with: .fade)
    }

    @objc private func gestureExpandSection(_ sender: UITapGestureRecognizer) {

        guard let headerView = sender.view as? CategoryHeaderView else { return }
        expandSection(headerView.tag)
    }

}
