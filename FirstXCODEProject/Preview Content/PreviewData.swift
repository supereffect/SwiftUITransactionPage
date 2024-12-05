
import Foundation
import SwiftUI

var transactionPreviewData = Transaction(id:1, date:"12/05/2024", institution: "Desjardins", account: "Visa Desjardins", merchant: "Apple", amount:11.12, type:"debit", categoryId: 801, category: "Sotware", isPending:false, isTransfer:false, isExpense: true, isEdited:false)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count:10)
