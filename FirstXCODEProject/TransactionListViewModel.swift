//
//  TransactionListViewModel.swift
//  FirstXCODEProject
//
//  Created by egehan.cakir on 4.12.2024.
//

import Foundation
import Combine
import Collections // OrderedCollection

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)] // ChartBase

final class TransactionListViewModel: ObservableObject
{
    @Published var transactions: [Transaction] = []
    
    private var cancellables = Set<AnyCancellable>()
    init(){
        getTransactions()
    }
    func getTransactions(){
        guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
            print("Invalid url")
            return
        }
        
        //if you ve more complex api not use onyly 200
        URLSession.shared.dataTaskPublisher(for: url).tryMap { (data,response) -> Data in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                
            
                    dump(response) //its like print bot more readable object for response...
                    throw URLError(.badServerResponse)
            }
            return data;
        }.decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion
                {
                case .failure(let error):
                    print("Error fetching transactions", error.localizedDescription)
                case .finished:
                    print("Finished fetching transactions")
                                }
                
            } receiveValue: {[weak self] result in
                self?.transactions = result
            }
            .store(in: &cancellables )
    }
    func groupTranactionsByMonth() ->  TransactionGroup {
        guard !transactions.isEmpty else { return [:]}
            
        let groupedTransactions = TransactionGroup(grouping:transactions)
        {
            $0.month
        }
        return groupedTransactions
        
    }
    
    func accumulateTransactions() -> TransactionPrefixSum {
        print("accumulateTransactions")
        guard !transactions.isEmpty else { return [ ]}
        
        let today = "02/17/2022".dateParsed() // Date()
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        print("dateInterval",dateInterval)
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        for date in stride(from: dateInterval.start, to: today, by:60 * 60 * 24)
        {
            let dailyExpenses = transactions.filter {
                $0.dateParsed == date && $0.isExpense
            }
            let dailyTotal = dailyExpenses.reduce(0) { $0-$1.signedAmount}
            sum += dailyTotal
            sum = sum.rounded2Digits()
            cumulativeSum.append((date.formatted(), sum))
            print(date.formatted(), "dailyTotal:", dailyTotal, "sum:", sum)
        }
        return cumulativeSum
        
    }
    
}
