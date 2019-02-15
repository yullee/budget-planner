// Yul Lee Kim
// Transaction.m

#import "Transaction.h"

@implementation Transaction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _amount = @"Unknown";
        _detail = @"Unknown";
        _date = @"Unknown";
        _category = @"Unknown";
        _type = @"Unknown";
    }
    return self;
}

- (instancetype) initWithAmount: (NSString *) amount
                         detail: (NSString *) detail
                           date: (NSString *) date
                       category: (NSString *) category
                           type: (NSString *) type
{
    self = [super init];
    if (self) {
        _amount = amount;
        _detail = detail;
        _date = date;
        _category = category;
        _type = type;
    }
    return self;
}

- (NSString *) getAmount {
    NSString *infoStr = [NSString stringWithFormat:@"Amount: %@", [self amount]];
    return infoStr;
}

- (NSString *) getDetail {
    NSString *infoStr = [NSString stringWithFormat:@"Detail: %@", [self detail]];
    return infoStr;
}

- (NSString *) getDate {
    NSString *infoStr = [NSString stringWithFormat:@"Date: %@", [self date]];
    return infoStr;
}

- (NSString *) getCategory {
    NSString *infoStr = [NSString stringWithFormat:@"Category: %@", [self category]];
    return infoStr;
}

- (NSString *) getType {
    NSString *infoStr = [NSString stringWithFormat:@"Type: %@", [self type]];
    return infoStr;
}

- (void) logInfo {
    NSLog (@"You spent $%@ spent on %@ on %@.\n", [self amount], [self detail], self.date);
}

- (NSString *) getInfo {
    NSString *infoStr = [NSString stringWithFormat:@"You spent $%@ spent on %@ on %@.\n", [self amount], [self detail], self.date];
    return infoStr;
}

- (NSDictionary *) convertForPList {
    NSDictionary *transaction = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.amount, amountKey,
                               self.detail, detailKey,
                               self.date, dateKey,
                                self.category, categoryKey,
                                 self.type, typeKey,
                               nil];

    return transaction;
}

@end
