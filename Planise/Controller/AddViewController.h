// Yul Lee Kim
// AddViewController.h

#import <UIKit/UIKit.h>

// Create a typedefBlock with no return type, and two arguments
typedef void(^AddInfo)(NSString *spendingAmount, NSString *spendingDetail, NSString *spendingDate, NSString *spendingCategory, NSString *spendingType);

@interface AddViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

// Create a public property of the typedefBlock
@property (copy, nonatomic) AddInfo addInfo;

@property (strong, nonatomic) NSArray *categories;
//- (IBAction) buttonPressed;
@end
