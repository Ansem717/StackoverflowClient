//
//  OAuthViewController.h
//  StackOverFlowClient
//
//  Created by Andy Malik on 3/28/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OAuthVCCompletion)();

@interface OAuthViewController : UIViewController

@property (strong, nonatomic) OAuthVCCompletion completion;
- (NSString *)getAccessTokenFromKeychain;


@end
