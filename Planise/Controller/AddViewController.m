// Yul Lee Kim
// TransactionModel.h
// AddViewController.m

#import "AddViewController.h"

@interface AddViewController ()

@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextField *detail;
// Create the IBOutlet for the Cancel button
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
// Create the IBOutlet for the Save button
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl * segmentedControl;

@property (strong, nonatomic) NSString *spendingType;
@property (strong, nonatomic) NSString *spendingDate;
@property (strong, nonatomic) NSString *spendingCategory;



@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.categories = @[@"Food", @"Shopping", @"Transportation", @"Cultural Life", @"Rent", @"Education", @"Medical", @"Utility Bill", @"Income", @"Savings"];
    
    NSDate *now = [NSDate date];
    [self.datePicker setDate:now animated:NO];
    // Set delegate for amount
    [self.amount setDelegate:self];
    
    // Set delegate for detail
    [self.detail setDelegate:self];
    // Set an initial spending type to be withdrawal
    _spendingType = [[NSString alloc] initWithFormat:@"Withdrawal"];
}

// Make the keyboard to automatocally appear
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.amount becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView{
    return 1;
}

- (NSInteger) pickerView: (UIPickerView *) pickerView numberOfRowsInComponent: (NSInteger) component{
    return [self.categories count];
}

- (NSString *) pickerView: (UIPickerView *) pickerView titleForRow: (NSInteger) row
             forComponent: (NSInteger) component {
    return self.categories[row];
}

- (IBAction)backgroundButtonTapped:(id)sender {
    [self.view endEditing: YES];
}

- (void) clearAll {
    self.segmentedControl.selectedSegmentIndex = 1;
}

// IBAction for the Cancel button
- (IBAction)cancelButtonTapped:(id)sender {
    if (self.addInfo) {
        self.addInfo(nil, nil, nil, nil, nil);
    }
}

// IBAction for the Save button
- (IBAction)saveButtonTapped:(id)sender {
    
    // Get the date of the DatePicker
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    _spendingDate = [dateFormat stringFromDate:self.datePicker.date];
    NSString *message = [[NSString alloc] initWithFormat:@"The date you selected is %@", _spendingDate];
    NSLog(@"%@", message);
    
    NSInteger row = [self.categoryPicker selectedRowInComponent:0];
    _spendingCategory = self.categories[row];
    NSString *title = [[NSString alloc] initWithFormat:
                       @"The category you selected %@!", _spendingCategory];
    // Use an UIAlertController to print title
    NSLog(@"%@", title);
    NSLog(@"%@", _spendingType);
    
    if (self.addInfo) {
        self.addInfo(self.amount.text, self.detail.text, _spendingDate, _spendingCategory, _spendingType);
    }
    
    self.amount.text = nil;
    self.detail.text = nil;
    [self clearAll];
}

- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    self.segmentedControl = (UISegmentedControl *) sender;
    
    if(self.segmentedControl.selectedSegmentIndex == 0) {
//        _amountInput = [_amount.text doubleValue]; // Cast a textfield to dobule
        _spendingType = [[NSString alloc] initWithFormat:@"Deposit"];
        
//        _incomeStr = [NSString stringWithFormat:@"%.02f", _income];
        // Testing
        NSLog(@"%@", _spendingType);
    } else {
//        _amountInput = [_amount.text doubleValue]; // Cast a textfield to dobule
        _spendingType = [[NSString alloc] initWithFormat:@"Withdrawal"];
        NSLog(@"%@.", _spendingType);
    }
}
#pragma mark - TextField Delegate Methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *changedString = [textField.text
                               stringByReplacingCharactersInRange:range
                               withString:string];
    
    if(textField == self.amount) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSArray *sep = [newString componentsSeparatedByString:@"."];
        if([sep count] >= 2)
        {
            NSString *sepStr=[NSString stringWithFormat:@"%@",[sep objectAtIndex:1]];
            if (!([sepStr length]>2)) {
                if ([sepStr length]==2 && [string isEqualToString:@"."]) {
                    return NO;
                }
                return YES;
            }
            else{
                return NO;
            }
        }

        [self enableSaveButtonForAmount:changedString detail:self.detail.text];
    } else {
        [self enableSaveButtonForAmount:self.amount.text detail:changedString];
    }
//
    return YES; // Keep what the user is typing -capturing while they are typing before put into the data
}

#pragma mark - Helper Methods
// Enable the save button when data is in all 2 textfields
-(void) enableSaveButtonForAmount: (NSString *) amountText
                            detail: (NSString *) detailText{
    
    self.saveButton.enabled = (amountText.length > 0 && detailText.length > 0);
}

@end
