//
//  StackOverflowService.m
//  StackOverFlowClient
//
//  Created by Andy Malik on 3/29/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "StackOverflowService.h"
#import "APIService.h"

NSString * const kSOAPIBaseURL = @"https://api.stackexchange.com/2.2/";

@implementation StackOverflowService

+(void)searchWithTerm:(NSString * __nonnull)searchTerm withCompletion:(APIServiceCompletionHandler __nullable)completionHandler {
    NSString * formattedSearchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString * sortParam = @"activity";
    NSString * orderParam = @"desc";
    NSString * siteParam = @"stackoverflow";
    
    NSString * searchURL = [NSString stringWithFormat:@"%@search?order=%@&sort=%@&intitle%@&site=%@", kSOAPIBaseURL, orderParam, sortParam, formattedSearchTerm, siteParam];
    
    
    [APIService getRequestWithURLString:searchURL andCompletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR IN COMPLETION: %@", [error localizedDescription]);
            completionHandler(nil, error);
            return;
        }
        NSLog(@"YAY! A THINGY DEE THING!");
        completionHandler(data, nil);
    }];
}

@end
