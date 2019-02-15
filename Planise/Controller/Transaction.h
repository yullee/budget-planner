// Yul Lee Kim
// Transaction.h

#import <Foundation/Foundation.h>

// Constants
static NSString * const amountKey = @"amountKey";
static NSString * const detailKey = @"detailKey";
static NSString * const dateKey = @"dateKey";
static NSString * const categoryKey = @"categoryKey";
static NSString * const typeKey = @"typeKey";

@interface Transaction : NSObject

// Declare public properties
@property (strong, nonatomic, readonly) NSString* amount;
@property (strong, nonatomic, readonly) NSString* detail;
@property (strong, nonatomic, readonly) NSString* date;
@property (strong, nonatomic, readonly) NSString* category;
@property (strong, nonatomic, readonly) NSString* type;
//@property (nonatomic, assign) BOOL isFavorite;

- (NSNumber *) getAmount;
- (NSNumber *) getDetail;
- (NSNumber *) getDate;
- (NSString *) getCategory;
- (NSString *) getType;

- (void) logInfo;

// Initializing a transaction
- (instancetype) initWithAmount: (NSString *) amount
                         detail: (NSString *) detail
                           date: (NSString *) date
                       category: (NSString *) category
                           type: (NSString *) type;

- (NSDictionary *) convertForPList;

@end
