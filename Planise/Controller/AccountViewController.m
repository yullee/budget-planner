// Yul Lee Kim
// AccountViewController.m
// This class calculates income, spending and balance

#import "AccountViewController.h"
#import "TransactionModel.h"
#import "Transaction.h"

@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UILabel * messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeInput;
@property (weak, nonatomic) IBOutlet UILabel *spendingInput;
@property (weak, nonatomic) IBOutlet UILabel *balanceInput;
@property (strong, nonatomic) TransactionModel *transactionModel;

// Properties to hold double
@property double income;
@property double spending;
@property double balance;
@property double amountInput;

@property (strong, nonatomic) NSString *incomeStr;
@property (strong, nonatomic) NSString *spendingStr;
@property (strong, nonatomic) NSString *balanceStr;
@property (strong, nonatomic) UIColor *minusRed;
@property (strong, nonatomic) UIColor *plusGreen;
@property int startIndex;
@property bool minusOrNot;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the model by calling the sharedModel method
    self.transactionModel = [[TransactionModel alloc] init];
    self.transactionModel = [TransactionModel sharedModel];

    // Set a UIColor
    self.minusRed = [[UIColor alloc] initWithRed: 153.0/255.0 green: 0.0 blue: 0.0 alpha: 1.0];
    self.plusGreen = [[UIColor alloc] initWithRed:63.0/255.0 green:195.0/255.0 blue:128.0/225.0 alpha:1.0];
    
    // Call a calculate function; this will be called only one time
    [self calculateBeginning];
}

- (void) calculateBeginning {
    self.startIndex = (int)[self.transactionModel numberOfTransactions];
    if([self.transactionModel numberOfTransactions] > 0) {
        NSLog(@"%@", @"There is at least one transaction.");
        for (NSUInteger i = 0; i < [self.transactionModel numberOfTransactions]; i++) {
            Transaction * transaction = [self.transactionModel transactionAtIndex:i];
            if([transaction.type  isEqual: @"Deposit"]) {
                double amountInput = [transaction.amount doubleValue]; // Cast a textfield to dobule
                NSLog(@"%@", @"Deposit found.");
                _income += amountInput;
                _incomeStr = [NSString stringWithFormat:@"%.02f", _income];
                self.incomeInput.text = _incomeStr;
                
                NSLog(@"Income is %f", _income);
            } else {
                NSLog(@"%@", @"Withdrawal found.");
                double amountInput = [transaction.amount doubleValue]; // Cast a textfield to dobule
                _spending += amountInput;
                NSLog(@"Spending is %f", _spending);
                _spendingStr = [NSString stringWithFormat:@"%.02f", _spending];
                self.spendingInput.text = _spendingStr;
            }
        }
        _balance = _income - _spending; // Calculates a balance
        if(_balance < 0) { // Check if the balance is negative
            _minusOrNot = YES;
        } else {
            _minusOrNot = NO;
        }
        _balanceStr = [NSString stringWithFormat:@"%.02f", _balance]; // Format to display 2 decimal places
        self.balanceInput.text = _balanceStr; // Assign the formatted value to a label
        if(_minusOrNot) { // If negative
            self.balanceInput.textColor = _minusRed; // Change the text color to red
        } else {
            self.balanceInput.textColor = _plusGreen;
        }
    } else {
        NSLog(@"%@", @"No transaction record is found.");
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    if(_startIndex < [self.transactionModel numberOfTransactions]) {
        NSLog(@"%@", @"New transaction is found.");
        for (NSUInteger i = _startIndex; i < [self.transactionModel numberOfTransactions]; i++) {
            Transaction * transaction = [self.transactionModel transactionAtIndex:i];
            if([transaction.type  isEqual: @"Deposit"]) {
                double amountInput = [transaction.amount doubleValue]; // Cast a textfield to dobule
                NSLog(@"%@", @"Deposit found.");
                _income += amountInput;
                _incomeStr = [NSString stringWithFormat:@"%.02f", _income];
                self.incomeInput.text = _incomeStr;
            } else {
                double amountInput = [transaction.amount doubleValue]; // Cast a textfield to dobule
                _spending += amountInput;
                NSLog(@"Spending is %f", _spending);
                _spendingStr = [NSString stringWithFormat:@"%.02f", _spending];
                self.spendingInput.text = _spendingStr;
            }
        }
        
        _balance = _income - _spending; // Calculates a balance
        if(_balance < 0) {
            _minusOrNot = YES;
        } else {
            _minusOrNot = NO;
        }
        
        
        _balanceStr = [NSString stringWithFormat:@"%.02f", _balance]; // Format to display 2 decimal places
        self.balanceInput.text = _balanceStr; // Assign the formatted value to a label
        if(_minusOrNot) {
            self.balanceInput.textColor = _minusRed;
        } else {
            self.balanceInput.textColor = _plusGreen;
        }

        // Update an index value -- track a number of items updated
        _startIndex = (int)[self.transactionModel numberOfTransactions];
    }
    
    // If any of the transactions get deleted
    else if(_startIndex > [self.transactionModel numberOfTransactions]) {
        NSLog(@"%@", @"Deleted transaction is found.");
    }
}

- (void) fadeOut {
    self.messageLabel.alpha = 0.0;
}

- (void) fadeIn: (NSString *) newMessage
      withColor: (UIColor *) newColor {
    self.messageLabel.text = newMessage;
    self.messageLabel.textColor = newColor;
    [UIView animateWithDuration: 2.0
                     animations: ^ {
                         self.messageLabel.alpha = 1.0;
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
