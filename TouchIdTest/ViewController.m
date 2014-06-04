//
//  ViewController.m
//  TouchIdTest
//
//  Created by M. Akif Petek on 04/06/14.
//  Copyright (c) 2014 M. Akif Petek. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
            

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, 200)];
    loginButton.center = self.view.center;
    
    [self.view addSubview:loginButton];
    
    [loginButton addTarget:self action:@selector(onLoginTouch:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) onLoginTouch:(UIButton *)button {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Restricted Area!";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    // User authenticated successfully, take appropriate action
                                    alert.title = @"Success";
                                    alert.message = @"You have access to private content!";
                                    [alert show];
                                } else {
                                    // User did not authenticate successfully, look at error and take appropriate action
                                    alert.title = @"Fail";
                                    
                                    switch (error.code) {
                                        case LAErrorUserCancel:
                                            alert.message = @"Authentication Cancelled";
                                            break;
                                            
                                        case LAErrorAuthenticationFailed:
                                            alert.message = @"Authentication Failed";
                                            break;
                                            
                                        case LAErrorPasscodeNotSet:
                                            alert.message = @"Passcode is not set";
                                            break;
                                            
                                        case LAErrorSystemCancel:
                                            alert.message = @"System cancelled authentication";
                                            break;
                                            
                                        case LAErrorUserFallback:
                                            alert.message = @"You chosed to try password";
                                            break;
                                            
                                        default:
                                            alert.message = @"You cannot access to private content!";
                                            break;
                                    }
                                    [alert show];
                                }
                            }];
    } else {
        // Could not evaluate policy; look at authError and present an appropriate message to user
        alert.title = @"Warning";
        
        if(authError.code == LAErrorTouchIDNotEnrolled) {
            alert.message = @"You do not have any fingerprints enrolled!";
        }else if(authError.code == LAErrorTouchIDNotAvailable) {
            alert.message = @"Your device does not support TouchID authentication!";
        }else if(authError.code == LAErrorPasscodeNotSet){
            alert.message = @"Your passcode has not been set";
        }
        
        [alert show];
    }
}

@end
