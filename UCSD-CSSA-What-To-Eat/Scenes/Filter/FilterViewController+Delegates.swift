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

        return sectionItems[section].isExpanded ? sectionItems[section].cellDescriptors.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CELL_REUSE_IDENTIFIER, for: indexPath) as? RestaurantCell else { return UITableViewCell() }
        let cellDescriptors = sectionItems[indexPath.section].cellDescriptors
        cell.configure(isChecked: cellDescriptors[indexPath.row].checked, title: cellDescriptors[indexPath.row].label)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UINib.init(nibName: "CategoryHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? CategoryHeaderView

        headerView?.tag = section
        headerView?.configure(sectionItems[section].state, isExpand: sectionItems[section].isExpanded, title: sectionItems[section].label)
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

        var cellDescriptors = sectionItems[indexPath.section].cellDescriptors
        cellDescriptors[indexPath.row].checked = !cellDescriptors[indexPath.row].checked
        sectionItems[indexPath.section].state = computeSelectStateForSectionItem(sectionItem: sectionItems[indexPath.section])
        tableView.reloadSections([indexPath.section], with: .none)
    }

    // MARK: - Private Helpers

    private func toggleAllInSection( _ section: Int) {

        let selectState = sectionItems[section].state == .Full ? SelectState.None : SelectState.Full
        let checked = sectionItems[section].state == .Full ? false : true
        sectionItems[section].state = selectState
        for i in 0 ..< sectionItems[section].cellDescriptors.count {
            sectionItems[section].cellDescriptors[i].checked = checked
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
