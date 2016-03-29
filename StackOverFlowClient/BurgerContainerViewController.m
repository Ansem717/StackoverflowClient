//
//  BurgerContainerViewController.m
//  StackOverFlowClient
//
//  Created by Andy Malik on 3/28/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "BurgerContainerViewController.h"
#import "MenuTableViewController.h"
#import "QuestionSearchViewController.h"
#import "UserSearchViewController.h"



CGFloat const kBurgerOpenScreenDivider = 2.5;
CGFloat const kBurgerOpenScreenMultipler = 1.8;
CGFloat const kBurgerButtonWidth = 65;
CGFloat const kBurgerButtonHeight = 50;
NSTimeInterval const kSlideOpenDuration = 0.25;
NSTimeInterval const kSlideCloseDuration = 0.3;

@interface BurgerContainerViewController () <UITableViewDelegate>

@property (strong, nonatomic) MenuTableViewController * menuVC;
@property (strong, nonatomic) QuestionSearchViewController * questionSearchVC;
@property (strong, nonatomic) UserSearchViewController * userSearchVC;

@property (strong, nonatomic) UIViewController * topViewController;

@property (strong, nonatomic) NSArray *viewControllers;

@property (strong, nonatomic) UIButton *burgerButton;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@end

@implementation BurgerContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuViewController];
    [self setupInitialContentViewController];
    [self setupAdditionalViewController];
    self.viewControllers = @[self.questionSearchVC, self.userSearchVC];
    self.topViewController = [self.viewControllers firstObject];
    [self setupPanGesture];
    [self burgerButtonWithColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]];
    [self.burgerButton setTitle:@"Menu" forState:UIControlStateNormal];
    [self.burgerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+ (NSString *)identifier {
    return @"BurgerContainerViewController";
}

- (void)setupMenuViewController {
    MenuTableViewController *menuVC = [self.storyboard instantiateViewControllerWithIdentifier:[MenuTableViewController identifier]];
    [self setupChildViewController:menuVC onScreen:YES];
    self.menuVC = menuVC;
    menuVC.tableView.delegate = self;
}

- (void)setupInitialContentViewController {
    QuestionSearchViewController * questionSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:[QuestionSearchViewController identifier]];
    [self setupChildViewController:questionSearchVC onScreen:YES];
    self.questionSearchVC = questionSearchVC;
}

- (void)setupAdditionalViewController {
    UserSearchViewController *userSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:[UserSearchViewController identifier]];
    [self setupChildViewController:userSearchVC onScreen:NO];
    self.userSearchVC = userSearchVC;
}

- (void)setupChildViewController:(UIViewController *)viewController onScreen:(BOOL)onScreen {
    if (onScreen) {
        viewController.view.frame = self.view.frame;
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
    } else {
        viewController.view.frame = [self offScreenLocation];
    }
}

- (CGRect)offScreenLocation {
    return CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - Pan Gesture

- (void)setupPanGesture {
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tvcPanned:)];
    [self.topViewController.view addGestureRecognizer:pan];
    self.panGesture=pan;
}

- (void)tvcPanned:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged) {
        [self panGestureStateChangedWithSender:sender];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self panGestureStateEnded];
    }
}

- (void)panGestureStateChangedWithSender:(UIPanGestureRecognizer *)sender {
    CGPoint velocity = [sender velocityInView:self.topViewController.view];
    CGPoint translation = [sender translationInView:self.topViewController.view];
    CGPoint previousCenter = self.topViewController.view.center;
    CGPoint newCenter = CGPointMake(previousCenter.x + translation.x, previousCenter.y);
    if (velocity.x  > 0 ) {
        self.topViewController.view.center = newCenter;
        [sender setTranslation:CGPointZero inView:self.topViewController.view];
    }
}

- (void)panGestureStateEnded {
    CGFloat finalX = self.topViewController.view.frame.origin.x;
    CGFloat finalW = self.topViewController.view.frame.size.width / kBurgerOpenScreenDivider;
    CGPoint menuOpenLocation = CGPointMake(self.view.center.x * kBurgerOpenScreenMultipler, self.view.center.y);
    CGPoint menuCloseLocation = CGPointMake(self.view.center.x, self.view.center.y);
    __weak typeof(self) weakSelf = self;
    if (finalX > finalW) {
        [UIView animateWithDuration:kSlideOpenDuration animations:^{
            weakSelf.topViewController.view.center = menuOpenLocation;
        } completion:^(BOOL finished) {
            [weakSelf setupTapGesture];
            weakSelf.burgerButton.userInteractionEnabled = NO;
        }];
    } else {
        [UIView animateWithDuration:kSlideCloseDuration animations:^{
            weakSelf.topViewController.view.center = menuCloseLocation;
        } completion:^(BOOL finished) {
            NSLog(@"Pan motion cut short - Closing menu...");
        }];
    }
}

- (void)setupTapGesture {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseMenu:)];
    [self.topViewController.view addGestureRecognizer:tap];
}

- (void)tapToCloseMenu:(UITapGestureRecognizer *)sender {
    [self.topViewController.view removeGestureRecognizer:sender];
    
    [UIView animateWithDuration:kSlideCloseDuration animations:^{
        self.topViewController.view.center = self.view.center;
    } completion:^(BOOL finished) {
        self.burgerButton.userInteractionEnabled = YES;
    }];
}

- (void)burgerButtonWithColor:(UIColor *)color {
    CGRect burgerSize = CGRectMake(0, 20, kBurgerButtonWidth, kBurgerButtonHeight);
    UIButton *burgerButton = [[UIButton alloc]initWithFrame:burgerSize];
    [burgerButton setBackgroundColor:color];
    [self.topViewController.view addSubview:burgerButton];
    [burgerButton addTarget:self action:@selector(burgerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.burgerButton = burgerButton;
}

- (void)burgerButtonPressed:(UIButton *)sender {
    
    CGPoint newCenter = CGPointMake(self.view.center.x * kBurgerOpenScreenMultipler, self.view.center.y);
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kSlideOpenDuration animations:^{
        weakSelf.topViewController.view.center = newCenter;
    } completion:^(BOOL finished) {
        [weakSelf setupTapGesture];
        weakSelf.burgerButton.userInteractionEnabled = NO;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController * viewController = self.viewControllers[indexPath.row];
    if (![viewController isEqual:self.topViewController]) {
        [self switchToViewController:viewController];
    }
}

- (void)replaceTopViewControllerWith:(UIViewController *)viewController {
    [self setupChildViewController:viewController onScreen:NO];
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    [self.topViewController willMoveToParentViewController:nil];
    [self.topViewController.view removeFromSuperview];
    [self.topViewController removeFromParentViewController];
    self.topViewController = viewController;
    [self.burgerButton removeFromSuperview];
    [self.topViewController.view addSubview:self.burgerButton];
}

- (void)switchToViewController:(UIViewController *)viewController {
    
    [self setupChildViewController:viewController onScreen:YES];
    
    
    [UIView animateWithDuration:kSlideOpenDuration animations:^{
        self.topViewController.view.frame = [self offScreenLocation];
    } completion:^(BOOL finished) {
        
        [self replaceTopViewControllerWith:viewController];
        
        [UIView animateWithDuration:kSlideCloseDuration animations:^{
            self.topViewController.view.center = self.view.center;
        } completion:^(BOOL finished) {
            [self.topViewController.view addGestureRecognizer:self.panGesture];
            self.burgerButton.userInteractionEnabled = YES;
        }];
    }];
}


@end








