//
//  SettingsViewController.m
//  tipCalculator
//
//  Created by Shon Thomas on 9/12/16.
//  Copyright © 2016 shon. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *defaultTipPercentage;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger defaultTipPercentage = [defaults integerForKey:@"defaultTipPercentage"];
    self.defaultTipPercentage.text = @"15";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)storeDefaultValues {
    NSInteger tipPercentage = [self.defaultTipPercentage.text integerValue];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:tipPercentage forKey:@"defaultTipPercentage"];
    [defaults synchronize];
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self storeDefaultValues];
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
