//
//  QuestionSearchViewController.m
//  StackOverFlowClient
//
//  Created by Andy Malik on 3/28/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverflowService.h"
#import "JSONParser.h"
#import "Question.h"
#import "User.h"

@interface QuestionSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *questionResultsTableView;

@property (strong, nonatomic) NSArray<Question *> *datasourceQuestions;

@end

@implementation QuestionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchBar setPlaceholder:@"Search for a question on Stack Overflow"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(NSString *)identifier {
    return @"QuestionSearchViewController";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasourceQuestions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.questionResultsTableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.datasourceQuestions[indexPath.row].title;
    
    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [StackOverflowService searchWithTerm:searchBar.text withCompletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR IN QUESTION-VC SEARCH: %@", [error localizedDescription]);
        }
        self.datasourceQuestions = [JSONParser questionsArrayFromDictionary:data];
        [self.questionResultsTableView reloadData];
    }];
    [self resignFirstResponder];
}

@end
