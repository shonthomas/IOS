//
//  ViewController.m
//  Instagram
//
//  Created by Peter Cheung on 9/14/16.
//  Copyright © 2016 codepath. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "PhotosViewController.h"
#import "PhotoTableViewCell.h"
#import "PhotoDetailsViewController.h"

@interface PhotosViewController ()

@property (strong, atomic) NSDictionary *responseDictionary;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSArray  *posts;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self loadTumblrData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (long)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numbersOfRowsInSection called");
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath called");
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoTableViewCell"];
    
    NSLog(@"%ld", indexPath.row);
    
    
    NSDictionary *post = [self.posts objectAtIndex:indexPath.section];
    NSArray *photosArray = post[@"photos"];
    
    NSDictionary *originalPhoto = [photosArray objectAtIndex:0][@"original_size"];
    NSString *fullPath = originalPhoto[@"url"];
    NSURL * imageURL = [NSURL URLWithString:fullPath];
    [cell.photoContainer setImageWithURL:imageURL];
    
    return cell;
}


 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"photoDetailsController"])
     {
         UITableViewCell *cell = sender;
         PhotoDetailsViewController *vc = [segue destinationViewController];
         NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
         
         NSDictionary *post = [self.posts objectAtIndex:indexPath.row];
         
         NSArray *photosArray = post[@"photos"];
         NSDictionary *originalPhoto = [photosArray objectAtIndex:0][@"original_size"];
         NSString *fullPath = originalPhoto[@"url"];
         
         vc.photoUrl = fullPath;
     }
 }


- (void)loadTumblrData {
    NSString *clientId = @"Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV";
    NSString *urlString =
    [@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=" stringByAppendingString:clientId];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    self.responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    NSDictionary *response = self.responseDictionary[@"response"];
                                                    NSArray *posts = response[@"posts"];
                                                    self.posts = posts;
                                                    
                                                    NSLog(@"Response: %@", self.responseDictionary);
                                                    [self.tableView reloadData];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];
    [task resume];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (long) numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"post count: %ld", self.posts.count);
    return self.posts.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [headerView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.9]];
    
    UIImageView *profileView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [profileView setClipsToBounds:YES];
    profileView.layer.cornerRadius = 15;
    profileView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.8].CGColor;
    profileView.layer.borderWidth = 1;
    
    // Use the section number to get the right URL
    NSDictionary *post = [self.posts objectAtIndex:section];
    NSArray *photosArray = post[@"photos"];
    NSDictionary *originalPhoto = [photosArray objectAtIndex:0][@"original_size"];
    NSString *fullPath = originalPhoto[@"url"];
    NSURL * imageURL = [NSURL URLWithString:fullPath];
    [profileView setImageWithURL:imageURL];
    
    [headerView addSubview:profileView];
    
    // Add a UILabel for the username here
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

@end
