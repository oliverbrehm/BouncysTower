//
//  InAppPurchaseManager.swift
//  BouncysTower iOS
//
//  Created by Oliver Brehm on 21.06.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import StoreKit

class InAppPurchaseManager: NSObject {
    private static let premiumProductIdentifier = "1"
    
    static let shared: InAppPurchaseManager = {
        let instance = InAppPurchaseManager()
        SKPaymentQueue.default().add(instance)
        return instance
    }()
    
    var hasProduct: Bool {
        return premiumProduct != nil
    }
    
    var premiumPurchased: Bool {
        get {
            return UserDefaults.standard.bool(forKey: InAppPurchaseManager.premiumProductIdentifier)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: InAppPurchaseManager.premiumProductIdentifier)
            UserDefaults.standard.synchronize()
        }
    }
    
    var premiumPriceLocalized: String? {
        guard let product = premiumProduct else { return nil}
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        
        return formatter.string(from: product.price)
    }
    
    private var premiumProduct: SKProduct?
    
    private var requestCompletionHandler: ((Bool) -> Void)?
    private var paymentCompletionHandler: ((Bool) -> Void)?
    private var restoreCompletionHandler: ((Bool) -> Void)?
    
    func restorePremiumPurchase(completion: @escaping (Bool) -> Void) {
        SKPaymentQueue.default().restoreCompletedTransactions()
        restoreCompletionHandler = completion
    }
    
    func requestProduct(completion: ((Bool) -> Void)? = nil) {
        let request = SKProductsRequest(productIdentifiers: [InAppPurchaseManager.premiumProductIdentifier])
        request.delegate = self
        request.start()
        requestCompletionHandler = completion
    }
    
    func purchase(completion: @escaping (Bool) -> Void) {
        if let product = premiumProduct {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            paymentCompletionHandler = completion
        } else {
            completion(false)
            paymentCompletionHandler = nil
        }
    }
}

extension InAppPurchaseManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("loaded products")

        if let product = response.products.first {
            premiumProduct = product
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("error loading products, error: \(error)")
        premiumProduct = nil
    }
}

extension InAppPurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                premiumPurchased = true
                paymentCompletionHandler?(true)
                paymentCompletionHandler = nil
                queue.finishTransaction(transaction)
                
            case .failed:
                paymentCompletionHandler?(false)
                paymentCompletionHandler = nil
                restoreCompletionHandler?(false)
                restoreCompletionHandler = nil
                queue.finishTransaction(transaction)
                
            case .restored:
                premiumPurchased = true
                restoreCompletionHandler?(true)
                restoreCompletionHandler = nil
                queue.finishTransaction(transaction)
                
            default: break
            }
        }
    }
}
