//
//  User.h
//  StackOverFlowClient
//
//  Created by Andy Malik on 3/29/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (strong, nonatomic) NSString * displayName;
@property (strong, nonatomic) NSURL * profileImageURL;
@property (strong, nonatomic) UIImage * profileImage;
@property (strong, nonatomic) NSURL * link;
@property (nonatomic) int userID;

- (instancetype)initWithDisplayName:(NSString *)displayName andProfileImageURL:(NSURL *)profileImageURL andLink:(NSURL *)link andUserID:(int)userID;


@end
