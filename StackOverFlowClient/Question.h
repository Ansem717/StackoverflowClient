//
//  Question.h
//  StackOverFlowClient
//
//  Created by Andy Malik on 3/29/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Question : NSObject

@property (strong, nonatomic) User * owner;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSArray * answers;
@property (nonatomic) int questionID;
@property (nonatomic) int score;
@property (nonatomic) BOOL isAnswered;

- (instancetype)initWithTitle:(NSString *)title andOwner:(User *)owner andQuestionID:(int)questionID andScore:(int)score andIsAnswered:(BOOL)isAnswered withAnswers:(NSArray *)answers;


@end
