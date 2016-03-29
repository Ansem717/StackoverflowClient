//
//  Question.m
//  StackOverFlowClient
//
//  Created by Andy Malik on 3/29/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "Question.h"

@implementation Question


- (instancetype)initWithTitle:(NSString *)title andOwner:(User *)owner andQuestionID:(int)questionID andScore:(int)score andIsAnswered:(BOOL)isAnswered withAnswers:(NSArray *)answers {
	
    self = [super init];
    if (self) {
        self.title = title;
        self.owner = owner;
        self.questionID = questionID;
        self.score = score;
        self.isAnswered = isAnswered;
        self.answers = answers;
    }
    return self;
}

- (instancetype)init
{
    return nil;
}

@end
