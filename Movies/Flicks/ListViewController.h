//
//  ViewController.h
//  Flicks
//
//  Created by Shon Thomas on 9/12/16.
//  Copyright © 2016 shon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController

@property (nonatomic, strong) NSString *endpoint;
@property (weak, nonatomic) IBOutlet UISegmentedControl *layoutControl;

@end

