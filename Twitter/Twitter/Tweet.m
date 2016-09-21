//
//  Tweet.m
//  Twitter
//
//  Created by Shon Thomas on 9/19/16.
//  Copyright © 2016 shon. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        
        NSString *createdAt = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAt];
        
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
        
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        
        self.idStr = dictionary[@"id_str"];
        
        if (dictionary[@"in_reply_to_status_id_str"]) {
            self.replyToIdStr = dictionary[@"in_reply_to_status_id_str"];
        }
        
        if (dictionary[@"current_user_retweet"]) {
            self.retweetIdStr = dictionary[@"current_user_retweet"][@"id_str"];
        } else if (self.retweeted && [self.user.screenName isEqualToString:[[User currentUser] screenName]]) {
            self.retweetIdStr = self.idStr;
        }
        
        if (dictionary[@"retweeted_status"]) {
            self.retweetedTweet = [[Tweet alloc] initWithDictionary:dictionary[@"retweeted_status"]];
        }
        
    }
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray * )array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

@end
