//
//  TextFieldTableViewController.swift
//  Naterade
//
//  Created by Nathan Racklyeft on 8/30/15.
//  Copyright © 2015 Nathan Racklyeft. All rights reserved.
//

import UIKit


public protocol TextFieldTableViewControllerDelegate: class {
    func textFieldTableViewControllerDidEndEditing(_ controller: TextFieldTableViewController)

    func textFieldTableViewControllerDidReturn(_ controller: TextFieldTableViewController)
}


open class TextFieldTableViewController: UITableViewController, UITextFieldDelegate {

    private weak var textField: UITextField?

    @objc public var indexPath: IndexPath?

    @objc public var placeholder: String?

    @objc public var unit: String?

    @objc public var value: String? {
        didSet {
            delegate?.textFieldTableViewControllerDidEndEditing(self)
        }
    }

    @objc public var contextHelp: String?

    @objc public var keyboardType = UIKeyboardType.default

    open weak var delegate: TextFieldTableViewControllerDelegate?

    public convenience init() {
        self.init(style: .grouped)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(TextFieldTableViewCell.nib(), forCellReuseIdentifier: TextFieldTableViewCell.className)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        textField?.becomeFirstResponder()
    }

    // MARK: - UITableViewDataSource

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.className, for: indexPath) as! TextFieldTableViewCell

        textField = cell.textField

        cell.textField.delegate = self
        cell.textField.text = value
        cell.textField.keyboardType = keyboardType
        cell.textField.placeholder = placeholder
        cell.unitLabel.text = unit

        return cell
    }

    open override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return contextHelp
    }

    // MARK: - UITextFieldDelegate

    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        value = textField.text

        return true
    }

    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        value = textField.text

        textField.delegate = nil
        delegate?.textFieldTableViewControllerDidReturn(self)

        return false
    }
}
