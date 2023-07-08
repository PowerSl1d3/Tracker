//
//  TrackerTitleTextFieldCell.swift
//  Tracker
//
//  Created by Олег Аксененко on 28.06.2023.
//

import UIKit

final class TrackerTitleTextFieldCell: TrackerBaseCell {
    override var reuseIdentifier: String { String(describing: TrackerTitleTextFieldCell.self) }

    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .ypRegularFont(ofSize: 17)
        textField.backgroundColor = .ypBackground
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.rightViewMode = .unlessEditing
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done

        return textField
    }()

    var cellModel: TrackerTitleTextFieldCellModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true

        titleTextField.delegate = self

        contentView.addSubview(titleTextField)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configure(from cellModel: TrackerBaseCellModelProtocol) {
        super.configure(from: cellModel)

        guard let cellModel = cellModel as? TrackerTitleTextFieldCellModel else { return }

        self.cellModel = cellModel
        titleTextField.text = cellModel.title
        titleTextField.placeholder = cellModel.placeholder
    }
}

extension TrackerTitleTextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let cellModel else { return textField.resignFirstResponder() }

        cellModel.title = textField.text
        let shouldShowError = textField.text != nil && textField.text?.count ?? 0 > 38
        cellModel.errorLabelAppearanceHandler?(cellModel, shouldShowError)

        return textField.resignFirstResponder()
    }
}

private extension TrackerTitleTextFieldCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
}
