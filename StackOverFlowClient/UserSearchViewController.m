//
//  UserSearchViewController.m
//  StackOverFlowClient
//
//  Created by Andy Malik on 3/28/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "UserSearchViewController.h"
#import "StackOverflowService.h"
#import "JSONParser.h"
#import "User.h"

@interface UserSearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *userResultsTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray<User *>* userDatasource;

@property (strong, nonatomic) User * test;

@end

@implementation UserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchBar setPlaceholder:@"Search for a user on Stack Overflow"];
    
    self.test = [[User alloc]initWithDisplayName:@"Test" andProfileImageURL:nil andLink:nil andUserID:100];
    
    [self addObserver:self forKeyPath:@"test.displayName" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    self.test.displayName = @"A DIFF NAME!";
    self.test.displayName = @"Proof of KVO Concept";
    NSLog(@"Should print as 'Proof of KVO Concept', right? Well I changed it: %@", self.test.displayName);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+(NSString *)identifier {
    return @"UserSearchViewController";
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"test.displayName"]) {
        NSLog(@"Name changed!");
        NSLog(@"%@", change);
        if ([change[@"new"] isEqualToString:@"Proof of KVO Concept"]) {
            self.test.displayName = @"Nice Try!";
        }
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"test.displayName"];
}
#pragma mark - Delegates and Datasource stuff

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userDatasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self.userResultsTableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    cell.textLabel.text = self.userDatasource[indexPath.row].displayName;
    return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self resignFirstResponder];
    [StackOverflowService searchUserWithTerm:searchBar.text withCompletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        self.userDatasource = [JSONParser usersArrayFromDictionary:data];
        [self.userResultsTableView reloadData];
    }];
}

@end
