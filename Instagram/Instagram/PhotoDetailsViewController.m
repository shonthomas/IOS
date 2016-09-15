//
//  DetailViewController.m
//  Instagram
//
//  Created by Peter Cheung on 9/14/16.
//  Copyright © 2016 codepath. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "PhotoDetailsViewController.h"

@interface PhotoDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detailPhotoView;

@end

@implementation PhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL * imageURL = [NSURL URLWithString:self.photoUrl];
    [self.detailPhotoView setImageWithURL:imageURL];
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
