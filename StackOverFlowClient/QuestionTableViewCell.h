//
//  CustomTableViewCell.h
//  StackOverFlowClient
//
//  Created by Andy Malik on 3/30/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *isAvailableImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;

@end
