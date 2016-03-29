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
    
    NSString * searchURL = [NSString stringWithFormat:@"%@search?order=%@&sort=%@&intitle=%@&site=%@", kSOAPIBaseURL, orderParam, sortParam, formattedSearchTerm, siteParam];
    
    
    NSLog(@"%@", searchURL);
    
    
    [APIService getRequestWithURLString:searchURL andCompletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR 002: %@", [error localizedDescription]);
            completionHandler(nil, error);
            return;
        }
        completionHandler(data, nil);
    }];
}

+(void)searchUserWithTerm:(NSString * __nonnull)searchTerm withCompletion:(APIServiceCompletionHandler __nullable)completionHandler {
    NSString * formattedSearchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString * sortParam = @"reputation";
    NSString * orderParam = @"desc";
    NSString * siteParam = @"stackoverflow";
    
    NSString * searchURL = [NSString stringWithFormat:@"%@users?order=%@&sort=%@&inname=%@&site=%@", kSOAPIBaseURL, orderParam, sortParam, formattedSearchTerm, siteParam];
    
    
    NSLog(@"%@", searchURL);
    
    
    [APIService getRequestWithURLString:searchURL andCompletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR 005: %@", [error localizedDescription]);
            completionHandler(nil, error);
            return;
        }
        completionHandler(data, nil);
    }];
}

@end
