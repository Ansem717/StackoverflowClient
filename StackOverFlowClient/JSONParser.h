//
//  JSONParser.h
//  StackOverFlowClient
//
//  Created by Andy Malik on 3/29/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject

+ (NSMutableArray * __nullable)questionsArrayFromDictionary:(NSDictionary * __nullable)data;
+ (NSMutableArray * __nullable)usersArrayFromDictionary:(NSDictionary * __nullable)data;

@end
