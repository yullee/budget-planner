// Yul Lee Kim
// ViewController.m

#import <LinkKit/LinkKit.h>
#import "ViewController.h"

@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Configure Google Sign-in.
    GIDSignIn* signIn = [GIDSignIn sharedInstance];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeGmailReadonly, nil];
//    [signIn signInSilently];
    
    // Add the sign-in button.
//    self.signInButton = [[GIDSignInButton alloc] init];
//    [self.view addSubview:self.signInButton];
//
//    // Create a UITextView to display output.
//    self.output = [[UITextView alloc] initWithFrame:self.view.bounds];
//    self.output.editable = false;
//    self.output.contentInset = UIEdgeInsetsMake(20.0, 0.0, 20.0, 0.0);
//    self.output.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    self.output.hidden = true;
//    [self.view addSubview:self.output];
    
    // Initialize the service object.
    self.service = [[GTLRGmailService alloc] init];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error != nil) { // Failure
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    } else { // Successfully logged in
        self.signInButton.hidden = true;
        self.output.hidden = true;
        // Directs to the account page
        [self performSegueWithIdentifier: @"goMain" sender:self];
        NSLog(@"Successfully logged in.");
        self.service.authorizer = user.authentication.fetcherAuthorizer;
        [self fetchLabels];
    }
}

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
//    [myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// Construct a query and get a list of labels from the user's gmail. Display the
// label name in the UITextView
- (void)fetchLabels {
    self.output.text = @"Getting labels...";
    GTLRGmailQuery_UsersLabelsList *query = [GTLRGmailQuery_UsersLabelsList queryWithUserId:@"me"];
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}

- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket
             finishedWithObject:(GTLRGmail_ListLabelsResponse *)labelsResponse
                          error:(NSError *)error {
    if (error == nil) {
        NSMutableString *labelString = [[NSMutableString alloc] init];
        if (labelsResponse.labels.count > 0) {
//            [labelString appendString:@"Labels:\n"];
//            for (GTLRGmail_Label *label in labelsResponse.labels) {
//                [labelString appendFormat:@"%@\n", label.name];
//            }
        } else {
            [labelString appendString:@"No labels found."];
        }
        self.output.text = labelString;
    } else {
        [self showAlert:@"Error" message:error.localizedDescription];
    }
}


// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
