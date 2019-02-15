// Yul Lee Kim
// ViewController.h

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GTLRGmail.h>

@interface ViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UIButton *signOutButton;
@property (nonatomic, strong) IBOutlet GIDSignInButton *signInButton;
@property (nonatomic, strong) UITextView *output;
@property (nonatomic, strong) GTLRGmailService *service;

@end

