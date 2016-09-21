//
//  LoginViewController.m
//  Twitter
//
//  Created by Shon Thomas on 9/20/16.
//  Copyright © 2016 shon. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            // Modally present tweets view
            NSLog(@"Welcome to %@", user.name);
            
            TweetsViewController *tweeteVC = [[TweetsViewController alloc] init];
            UINavigationController *tweeteNC = [[UINavigationController alloc] initWithRootViewController:tweeteVC];
            tweeteNC.navigationBar.barTintColor = [UIColor colorWithRed:41.0f/255.0f green:158.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
            [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
            [tweeteNC.navigationBar setTitleTextAttributes:
             @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            
            [self presentViewController:tweeteNC animated:YES completion:nil];
        } else {
            // Present error view
        }
    }];

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
