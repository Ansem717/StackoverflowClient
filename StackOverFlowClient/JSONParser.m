//
//  JSONParser.m
//  StackOverFlowClient
//
//  Created by Andy Malik on 3/29/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "JSONParser.h"
#import "User.h"
#import "Question.h"

@implementation JSONParser

+ (NSMutableArray * __nullable)questionsArrayFromDictionary:(NSDictionary * __nullable)data {
    NSMutableArray *result = [NSMutableArray new];
    
    if (data) {
        NSMutableArray *items = data[@"items"];
        if (items) {
            for (NSDictionary * questionDictionary in items) {
                Question *newQ = [self questionFromDictionary:questionDictionary];
                if (newQ) {
                    [result addObject:newQ];
                }
            }
        }
    }
    return result;
}

+ (Question * __nullable)questionFromDictionary:(NSDictionary *)questionDictionary {
    NSString *title = questionDictionary[@"title"];
    NSNumber *questionId = questionDictionary[@"question_id"];
    NSNumber *score = questionDictionary[@"score"];
    BOOL isAnswered = [questionDictionary[@"is_answered"]isEqualToNumber:@1];
    NSDictionary *ownerDictionary = questionDictionary[@"owner"];
    User *owner = [self userFromDictionary:ownerDictionary];
    return [[Question alloc]initWithTitle:title andOwner:owner andQuestionID:questionId.intValue andScore:score.intValue andIsAnswered:isAnswered withAnswers:nil];
}

+ (User * __nullable)userFromDictionary:(NSDictionary *)userDictionary {
    NSString *displayName = userDictionary[@"display_name"];
    NSString *profileImageURLString = userDictionary[@"profile_image"];
    NSString *linkURLString = userDictionary[@"link"];
    NSString *userID = userDictionary[@"user_id"];
    NSURL *profileImageURL = [NSURL URLWithString:profileImageURLString];
    NSURL *link = [NSURL URLWithString:linkURLString];
    return [[User alloc]initWithDisplayName:displayName andProfileImageURL:profileImageURL andLink:link andUserID:userID.intValue];
}

@end
