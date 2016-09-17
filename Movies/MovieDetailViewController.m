//
//  MovieDetailViewController.m
//  Flicks
//
//  Created by Shon Thomas on 9/12/16.
//  Copyright © 2016 shon. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *popularityLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *popularityIcon;
@property (weak, nonatomic) IBOutlet UILabel *timeIcon;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleLable.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    
//    CGRect frame = self.infoView.frame;
//    frame.size.height = self.synopsisLabel.frame.size.height + self.synopsisLabel.frame.origin.y + 20;
//    self.infoView.frame = frame;
//    
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 40 + self.infoView.frame.origin.y + self.infoView.frame.size.height);
    

    // Load Image
    static NSString *const baseUrl = @"https://image.tmdb.org/t/p/w500";
    NSString *posterPath = [baseUrl stringByAppendingString:self.movie[@"poster_path"]];
    [self.posterView setImageWithURL:[NSURL URLWithString:posterPath] placeholderImage:[UIImage imageNamed:@"no-image.svg"]];
    
    // Release Date
    NSDate *releaseDate  = self.movie[@"release_date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date  = [dateFormatter dateFromString:releaseDate];
    //Convert to new Date format
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *newDate = [dateFormatter stringFromDate:date];
    self.dateLabel.text = newDate;
    
    // popularity
    NSString *popularity = [[NSString alloc] initWithFormat:@"%2.0f%%",([self.movie[@"popularity"] floatValue])];
    self.popularityLabel.text = popularity;
    
    // Size
    self.sizeLabel.text = [self timeFormatted:10900];
    
    // Icons
    [self.popularityIcon setFont:[UIFont fontWithName:@"FujiIcons" size:130]];
    [self.popularityIcon setText:[NSString stringWithUTF8String:"\u265A"]];
    [self.timeIcon setFont:[UIFont fontWithName:@"FujiIcons" size:130]];
    [self.timeIcon setText:[NSString stringWithUTF8String:"\u266A"]];
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d hr %02d mins",hours, minutes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
