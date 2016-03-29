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

@end

@implementation UserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+(NSString *)identifier {
    return @"UserSearchViewController";
}

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
