// Yul Lee Kim
// TransactionModel.m

#import "TransactionModel.h"

@interface TransactionModel()

// Private properties
// A mutable array containing transaction objects
@property (strong, nonatomic) NSMutableArray* transactions;

//@property (strong, nonatomic) NSMutableArray *favortransactions;
@property (strong, nonatomic) NSString* filepath;
@end

@implementation TransactionModel

+ (instancetype) sharedModel {
    
    static TransactionModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Code to be executed once
        _sharedModel = [[self alloc] init];
        
    });
    return _sharedModel;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

        NSString *documentsDirectory = paths[0];

        NSLog(@"docDir = %@", documentsDirectory);

        self.filepath = [documentsDirectory stringByAppendingPathComponent:@"transactions.plist"];

        // Log the filepath
        NSLog(@"filepath = %@", self.filepath);

        // Initialize the transactions array
        NSMutableArray *transactions = [NSMutableArray arrayWithContentsOfFile:self.filepath];
//
//        _transactions = [[NSMutableArray alloc] init];
        if(!transactions) { // File doesn't exist
            // Add at least 5 transactions to the array

            
        Transaction* transaction1 = [[Transaction alloc] initWithAmount: @"0.00"
                                                                 detail: @"Grove"
                                                                   date: @"12/05/2017"
                                                               category: @"Shopping"
                                                                   type: @"Withdrawal"];
            
            _transactions = [NSMutableArray arrayWithObjects:transaction1, nil];
        }
        
        
        
        else {
            // transactions - convert from plist to transaction
            _transactions = [[NSMutableArray alloc] init];

            for (NSDictionary* transactionD in transactions) {
              
                Transaction *transaction = [[Transaction alloc]
                                            initWithAmount: transactionD[amountKey]
                                            detail: transactionD[detailKey]
                                            date: transactionD[dateKey]
                                            category: transactionD[categoryKey]
                                            type: transactionD[typeKey]];
                                        
                [_transactions addObject: transaction];

            }

        }
        // Initialize the currentIndex to 0
        _currentIndex = 0;
        
        
    }
    return self;
}

- (NSUInteger) numberOfTransactions {
    return (NSUInteger)self.transactions.count;
}

- (Transaction *) transactionAtIndex: (NSUInteger) index {
    return self.transactions[index];
}

- (void) insertWithAmount: (NSString *) amount
                 detail: (NSString *) detail
                   date: (NSString *) date
               category: (NSString *) category
                   type: (NSString *) type
{
    Transaction* newTransaction = [[Transaction alloc] initWithAmount: amount
                                                               detail: detail
                                                                 date: date
                                                             category: category
                                                                 type: type];
    // When inserting a transaction without an index, add it at the end.
    [self.transactions addObject: newTransaction];

    // Save model when add a transaction
    [self save];
}

- (void) insertWithAmount: (NSString *) amount
                   detail: (NSString *) detail
                     date: (NSString *) date
                 category: (NSString *) category
                     type: (NSString *) type
                  atIndex: (NSUInteger) index
{
    Transaction* newTransaction = [[Transaction alloc] initWithAmount: amount
                                                               detail: detail
                                                                 date: date
                                                             category: category
                                                                 type: type];
    
    // If the index is less than or equal to the number of transactions
    if([self.transactions count] > index) {
    // Insert a transaction with an index
        [self.transactions insertObject: newTransaction atIndex: index];
    } else {
         // When inserting a transaction without an index, add it at the end.
        [self.transactions addObject: newTransaction];
    }

    // Save model when add a transaction
    [self save];
}

// Removing a transaction
- (void) removeTransaction
{
    [self.transactions removeObjectAtIndex: self.transactions.count - 1];
    // Save model when delete a transaction
    [self save];
}

- (void) removeTransactionAtIndex: (NSUInteger) index
{
    if([self.transactions count] > index) {
        [self.transactions removeObjectAtIndex: index];
        // Save model when delete a transaction
        [self save];
    }
}

#pragma mark - helper method
-(void) save {

    NSMutableArray *transactions2 = [[NSMutableArray alloc] init];

    for (Transaction* transaction in self.transactions) {
        NSDictionary *transactionD = [transaction convertForPList];
        [transactions2 addObject: transactionD];
    }

    [transactions2 writeToFile:self.filepath atomically:YES];
}

@end
