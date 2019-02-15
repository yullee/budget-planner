// Yul Lee Kim
// ITP 342, Fall 2017
// yulleeki@usc.edu
// AppDelegate.m

#import "AppDelegate.h"
#import <LinkKit/LinkKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"There is an error!", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    
    #if USE_CUSTOM_CONFIG
        [self setupPlaidLinkWithCustomConfiguration];
    #else
        [self setupPlaidLinkWithSharedConfiguration];
    #endif
    return YES;
}

#pragma mark Plaid Link setup with shared configuration from Info.plist
- (void)setupPlaidLinkWithSharedConfiguration {
    // <!-- SMARTDOWN_SETUP_SHARED -->
    // With shared configuration from Info.plist
    [PLKPlaidLink setupWithSharedConfiguration:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            // Handle success here, e.g. by posting a notification
            NSLog(@"Plaid Link setup was successful");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PLDPlaidLinkSetupFinished" object:self];
        }
        else {
            NSLog(@"Unable to setup Plaid Link due to: %@", [error localizedDescription]);
        }
    }];
    // <!-- SMARTDOWN_SETUP_SHARED -->
}


#pragma mark Plaid Link setup with custom configuration
- (void)setupPlaidLinkWithCustomConfiguration {
    
//     <!-- SMARTDOWN_SETUP_CUSTOM -->
//     With custom configuration
    PLKConfiguration* linkConfiguration;
    @try {
        linkConfiguration = [[PLKConfiguration alloc] initWithKey:@"8dab9a5bd2f9dd9ec6c1d03b1f4ca1"
                                                              env:PLKEnvironmentDevelopment
                                                          product:PLKProductAuth];
        linkConfiguration.clientName = @"Link Demo";
        [PLKPlaidLink setupWithConfiguration:linkConfiguration completion:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                // Handle success here, e.g. by posting a notification
                NSLog(@"Plaid Link setup was successful");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PLDPlaidLinkSetupFinished" object:self];
            }
            else {
                NSLog(@"Unable to setup Plaid Link due to: %@", [error localizedDescription]);
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Invalid configuration: %@", exception);
    }
//     <!-- SMARTDOWN_SETUP_CUSTOM -->
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if(error != nil){
        NSAssert(!error, @"Sorry, there is an error!", error);
    } else {
        NSString *givenName = user.profile.givenName;
        NSLog(@"Wow. %@ is signed in.", givenName);
    }
    
    // Perform any operations on signed in user here.
//    NSString *userId = user.userID;                  // For client-side use only!
//    NSString *idToken = user.authentication.idToken; // Safe to send to the server
//    NSString *fullName = user.profile.name;
    
//    NSString *familyName = user.profile.familyName;
//    NSString *email = user.profile.email;
    // ...
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
