//
//  MenuViewController.m
//  Twitter
//
//  Created by Shon Thomas on 9/21/16.
//  Copyright © 2016 shon. All rights reserved.
//

#import "MenuViewController.h"
#import "ProfileViewController.h"
#import "TweetsViewController.h"
#import "TwitterClient.h"

@interface MenuViewController ()

@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIViewController *currentVC;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set bg color
    self.view.backgroundColor = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    
    // reset constraint
    self.contentViewLeftMargin.constant = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self initViewControllers];
    [self.tableView reloadData];
}

- (void)initViewControllers {
    
    // Profile View
    ProfileViewController *profileViewVC = [[ProfileViewController alloc] init];
    UINavigationController *profileViewNC = [[UINavigationController alloc] initWithRootViewController:profileViewVC];
    profileViewNC.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    //[UIColor colorWithRed:41.0f/255.0f green:158.0f/255.0f blue:238.0f/255.0f alpha:1.0f]
    profileViewNC.navigationBar.tintColor = [UIColor whiteColor];
    [profileViewNC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    profileViewNC.navigationBar.translucent = NO;
    // set self as delage for pull downs
    profileViewVC.delegate = self;
    
    // Timeline
    TweetsViewController *tweetsVC = [[TweetsViewController alloc] init];
    UINavigationController *tweetsNC = [[UINavigationController alloc] initWithRootViewController:tweetsVC];
    tweetsNC.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    tweetsNC.navigationBar.tintColor = [UIColor whiteColor];
    [tweetsNC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    tweetsNC.navigationBar.translucent = NO;
    
    self.viewControllers = [NSArray arrayWithObjects:profileViewNC, tweetsNC, nil];
    
    // set Timeline as initial view
    self.currentVC = tweetsNC;
    self.currentVC.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.currentVC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self removeCurrentViewController];
    self.currentVC = self.viewControllers[indexPath.row];
    [self setContentController];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.bounds.size.height / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Profile";
            break;
        case 1:
            cell.textLabel.text = @"Timeline";
            break;
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
    cell.textLabel.textColor = [UIColor whiteColor];
    // use twitter color https://about.twitter.com/press/brand-assets
    cell.backgroundColor = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    
    return cell;
}

- (void)removeCurrentViewController {
    //    [self.currentVC willMoveToParentViewController:nil];
    //    [self.currentVC.view removeFromSuperview];
    //    [self.currentVC removeFromParentViewController];
}

- (void)setContentController {
    self.currentVC.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.currentVC.view];
    [self.currentVC didMoveToParentViewController:self];
    
    [UIView animateWithDuration:.24 animations:^{
        self.contentViewLeftMargin.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (void)showProfileViewController {
    [self removeCurrentViewController];
    self.currentVC = self.viewControllers[0];
    [self setContentController];
}

- (IBAction)didSwipeLeft:(UISwipeGestureRecognizer *)sender {
    NSLog(@"Swipe left detected");
    [UIView animateWithDuration:.24 animations:^{
        self.contentViewLeftMargin.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)didSwipeRight:(UISwipeGestureRecognizer *)sender {
    NSLog(@"Swipe right detected");
    // reload data to handle height change since row heights are based on table height
    [self.tableView reloadData];
    [UIView animateWithDuration:.24 animations:^{
        self.contentViewLeftMargin.constant = 240;
        [self.view layoutIfNeeded];
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
