// Yul Lee Kim
// TransactionModel.h

#import <Foundation/Foundation.h>
#import "Transaction.h"

@interface TransactionModel : NSObject

@property (assign, nonatomic, readonly) NSUInteger currentIndex;
// Add the public methods
// Creating the model
+ (instancetype) sharedModel;

// Accessing number of transactions in model
- (NSUInteger) numberOfTransactions;

// Accessing a transaction – sets currentIndex appropriately
- (Transaction *) transactionAtIndex: (NSUInteger) index;

- (void) insertWithAmount: (NSString *) amount
                   detail: (NSString *) detail
                     date: (NSString *) date
                 category: (NSString *) category
                     type: (NSString *) type;

- (void) insertWithAmount: (NSString *) amount
                   detail: (NSString *) detail
                     date: (NSString *) date
                 category: (NSString *) category
                     type: (NSString *) type
                  atIndex: (NSUInteger) index;

// Removing a transaction
- (void) removeTransaction;
- (void) removeTransactionAtIndex: (NSUInteger) index;

@end
