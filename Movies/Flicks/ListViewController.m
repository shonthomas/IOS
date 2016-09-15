//
//  ViewController.m
//  Flicks
//
//  Created by Shon Thomas on 9/12/16.
//  Copyright © 2016 shon. All rights reserved.
//

#import "ListViewController.h"
#import "MovieCell.h"
#import "MovieGridCell.h"
#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"

//@synthesize segmentedControl;

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) NSString *layoutType;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//UISegmentedControl *segmentedControl;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layoutType = @"list";
    
    // Grid View
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    // List View
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    if([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)])
    {
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Loading state, show the loading icon and hide the table row separator
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    NSAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.refreshControl setAttributedTitle:title];
    [self.refreshControl addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    // Handle layout change
    [self.layoutControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    // Loading movies from the API
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString =
    [[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=", self.endpoint] stringByAppendingString:apiKey];
    
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
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    // NSLog(@"Response: %@", responseDictionary);
                                                    
                                                    self.movies = responseDictionary[@"results"];
                                                    
                                                    // Added this to test MBProgressHUD
                                                    [NSThread sleepForTimeInterval:1.5f];
                                                    
                                                    if (self.movies.count) {
                                                        [self reloadData];
                                                    } else {
                                                        // Display a message when the table is empty
                                                        [self noResults];
                                                    }

                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                    
                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                    
                                                    // Show error massage
                                                    [self.errorView setHidden:NO];
                                                    [self.tableView setHidden:YES];
                                                }
                                            }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"collection movies count: %lu", (unsigned long)self.movies.count);
    return self.movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *movie = self.movies[indexPath.row];
    static NSString *identifier = @"MovieGridCell";
    
    MovieGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    static NSString *const baseUrl = @"https://image.tmdb.org/t/p/w92";
    NSString *imagePath = movie[@"poster_path"];
    if ([imagePath isKindOfClass:[NSString class]]) {
        NSString *posterPath = [baseUrl stringByAppendingString:imagePath];
        [cell.gridPosterView setImageWithURL:[NSURL URLWithString:posterPath] placeholderImage:[UIImage imageNamed:@"no-image"]];
    }
    
    return cell;
}

- (void)viewDidLayoutSubviews {
    [self.collectionView setContentInset: UIEdgeInsetsMake(self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, 0, 0, 0)];
    [self.collectionView setScrollIndicatorInsets:UIEdgeInsetsMake(self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, 0, 0, 0)];
}

// Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    cell.titleLable.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    [cell.synopsisLabel sizeToFit];
    
    
    //Thumbnail image
    
    //Synchronous
    //NSString *posterPath = movie[@"poster_path"];
    //NSString *fullPath = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w92%@", posterPath];
    //NSURL * imageURL = [NSURL URLWithString:fullPath];
    //NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    //UIImage * image = [UIImage imageWithData:imageData];
    //cell.posterView.image = image;
    
    //Asynchronous
    static NSString *const baseUrl = @"https://image.tmdb.org/t/p/w92";
    NSString *imagePath = movie[@"poster_path"];
    if ([imagePath isKindOfClass:[NSString class]]) {
        NSString *posterPath = [baseUrl stringByAppendingString:imagePath];
        [cell.posterView setImageWithURL:[NSURL URLWithString:posterPath] placeholderImage:[UIImage imageNamed:@"no-image"]];
    }

    return cell;
}

- (void)scrollToTop {
    if ([self.layoutType isEqualToString:@"grid"]) {
        [self.collectionView setContentOffset:CGPointMake(0, -self.collectionView.contentInset.top) animated:YES];
    } else {
        [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
    }
}

- (void)reloadData {
    if ([self.layoutType isEqualToString:@"grid"]) {
        [self.collectionView reloadData];
    } else {
        [self.tableView reloadData];
    }
    [self scrollToTop];
}

- (void)refreshView {
    [self.refreshControl endRefreshing];
    [self reloadData];
}

- (void)noResults {
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    messageLabel.text = @"No data is currently available. Please pull down to refresh.";
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
    [messageLabel sizeToFit];
    
    self.tableView.backgroundView = messageLabel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

// Remove the left table cell margin
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString: @"movieDetailSegue"]) {
        NSIndexPath *indexPath;
        if ([self.layoutType isEqualToString:@"grid"]) {
            UICollectionViewCell *cell = sender;
            indexPath = [self.collectionView indexPathForCell:cell];
        } else {
            UITableViewCell *cell = sender;
            indexPath = [self.tableView indexPathForCell:cell];
        }
        MovieDetailViewController *vc = segue.destinationViewController;
        vc.movie = self.movies[indexPath.row];
//    }
}

- (void)segmentAction:(UISegmentedControl *)segment {
    if(segment.selectedSegmentIndex == 0) {
        self.layoutType = @"list";
        [self.tableView setHidden:NO];
        [self.collectionView setHidden:YES];
        [self.tableView addSubview:self.refreshControl];
        [self reloadData];
    }else if(segment.selectedSegmentIndex == 1){
        self.layoutType = @"grid";
        [self.tableView setHidden:YES];
        [self.collectionView setHidden:NO];
        [self.collectionView addSubview:self.refreshControl];
        [self reloadData];
    }
}

@end
