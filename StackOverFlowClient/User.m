//
//  User.m
//  StackOverFlowClient
//
//  Created by Andy Malik on 3/29/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDisplayName:(NSString *)displayName andProfileImageURL:(NSURL *)profileImageURL andLink:(NSURL *)link andUserID:(int)userID {
    self = [super init];
    if (self) {
        self.displayName = displayName;
        self.profileImageURL = profileImageURL;
        self.link = link;
        self.userID = userID;
    }
    return self;
}

- (instancetype)init
{
    return nil;
}

@end
