//
//  StackOverflowService.h
//  StackOverFlowClient
//
//  Created by Andy Malik on 3/29/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^APIServiceCompletionHandler)(NSDictionary * __nullable data, NSError * __nullable error);

@interface StackOverflowService : NSObject

+(void)searchWithTerm:(NSString * __nonnull)searchTerm withCompletion:(APIServiceCompletionHandler __nullable)completionHandler;

@end
