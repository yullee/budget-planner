// Yul Lee Kim
// TableViewController.m

#import "TableViewController.h"
#import "AddViewController.h"
#import "TransactionModel.h"

@interface TableViewController ()

@property (strong, nonatomic) TransactionModel *transactionModel;
@property(nonatomic, readonly, strong) UIView *textLabel;


@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Preserve selection between presentations
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Enable the edit navigation bar item and have it display one the left
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // Use the model's singleton method
    self.transactionModel = [TransactionModel sharedModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.transactionModel numberOfTransactions];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


 // Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView UITableViewAutomaticDimension:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    
    // Configure the cell...
    NSString *tableCellText;
    Transaction *transaction = [self.transactionModel transactionAtIndex: indexPath.row];
    // Populate a title cell
    tableCellText = [NSString stringWithFormat:@"%@    $%@  |  %@", transaction.type, transaction.amount, transaction.category];
    cell.textLabel.text = tableCellText;
    
    // Populate a detail cell
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", transaction.date ];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    
        [self.transactionModel removeTransactionAtIndex: indexPath.row];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


#pragma mark - Navigation

// Implement the prepareForSegue method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    AddViewController *addVC = [segue destinationViewController];
    
    // Set the completion block for AddViewController
    addVC.addInfo = ^(NSString *amount, NSString *detail, NSString *date, NSString *category, NSString *type) {
        if (amount.length > 0 && detail.length > 0 && date.length > 0 && category.length > 0 && type.length > 0) {
             // Add a transaction to model
            [self.transactionModel insertWithAmount: amount
                                            detail: detail
                                              date: date
                                          category: category
                                              type: type];
            // Refresh the table view
            [self.tableView reloadData];
        }
        
        // Make the view controller to go away
        [self dismissViewControllerAnimated:YES completion:nil];
        
    };
    // Pass the selected object to the new view controller.
}

@end
