//
//  OAuthViewController.m
//  StackOverFlowClient
//
//  Created by Andy Malik on 3/28/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "OAuthViewController.h"
@import WebKit;

static NSString const *kClientID = @"6797";
static NSString const *kBaseURL = @"https://stackexchange.com/oauth/dialog";
static NSString const *kRedirectURI = @"https://stackexchange.com/oauth/login_success";

@interface OAuthViewController () <WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation OAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUpWebView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setUpWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpWebView {
    self.webView = [[WKWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    NSString *stackURLString = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",kBaseURL,kClientID,kRedirectURI];
    NSURL *stackURL = [NSURL URLWithString:stackURLString];
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:stackURL]];
    
//    [[UIApplication sharedApplication]openURL:stackURL];
    
}

#pragma mark - Web View Delegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest *request = navigationAction.request;
    NSURL *requestURL = request.URL;
    
    if ([requestURL.description containsString:@"access_token"]) {
        [self getAndStoreAccessTokenFromURL:requestURL];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)getAndStoreAccessTokenFromURL:(NSURL *)url {
    NSCharacterSet *separatingCharacters = [NSCharacterSet characterSetWithCharactersInString:@"#&?"];
    NSArray *urlComponents = [url.description componentsSeparatedByCharactersInSet:separatingCharacters];
    NSLog(@"Key-Value pairing from URL Response {");
    for (NSString *component in urlComponents) {
        NSArray *componentsArray = [component componentsSeparatedByString:@"="];
        
        if (componentsArray.count >= 2) {
            NSString *key = componentsArray[0];
            NSString *value = componentsArray[1];
            
            if (key && value) {
                NSLog(@"   \"%@\" = %@", key, value);
                [self saveStringToKeychain:value forKey:key];
            }
        }
    }
    NSLog(@"}");
}

- (void)saveStringToKeychain:(NSString *)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end











