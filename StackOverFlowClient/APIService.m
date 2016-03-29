//
//  APIService.m
//  StackOverFlowClient
//
//  Created by Andy Malik on 3/29/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "APIService.h"
#import <AFNetworking/AFNetworking.h>

@implementation APIService

+(void)getRequestWithURLString:(NSString * __nonnull)urlString andCompletion:(APIServiceCompletionHandler)completionHandler {
    AFHTTPSessionManager *myManager = [AFHTTPSessionManager manager];
    [myManager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(responseObject, nil);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"ERROR 001: %@", [error localizedDescription]);
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil, error);
        });
    }];
}

@end
