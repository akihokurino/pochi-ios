//
//  BankAccountCell.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class BankAccountCell: UITableViewCell {
    
    static let HEIGHT: Int = 82
    static let IDENTITY: String = R.reuseIdentifier.bankAccountCell.identifier
    static let NIB: UINib = R.nib.bankAccountCell()
    
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(account: BankAccount) {
        var type: String = ""
        switch account.accountType {
        case .normal:
            type = "普通口座"
        case .current:
            type = "当座口座"
        }
        
        self.bankLabel.text = "\(account.bank?.name ?? "") \(type)"
        self.nameLabel.text = "\(account.branchCode) \(account.branch?.name ?? "") \(account.name)"
    }
}
