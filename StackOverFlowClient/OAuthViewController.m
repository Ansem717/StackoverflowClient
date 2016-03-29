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
static NSString *const kAccessTokenKey = @"kAccessTokenKey";

@interface OAuthViewController () <WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation OAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setUpWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpWebView {
    self.webView = [[WKWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    NSString *stackURLString = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",kBaseURL,kClientID,kRedirectURI];
    NSURL *stackURL = [NSURL URLWithString:stackURLString];
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:stackURL]];
}

#pragma mark - Web View Delegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest *request = navigationAction.request;
    NSURL *requestURL = request.URL;
    
    NSLog(@"requestURL on WebView Delegate: %@", requestURL.description);
    
    if ([requestURL.description containsString:@"access_token"]) {
        [self getAndStoreAccessTokenFromURL:requestURL];
        
        if (self.completion) {
            self.completion();
        }
        
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)getAndStoreAccessTokenFromURL:(NSURL *)url {
    NSCharacterSet *separatingCharacters = [NSCharacterSet characterSetWithCharactersInString:@"#&?"];
    NSArray *urlComponents = [url.description componentsSeparatedByCharactersInSet:separatingCharacters];
    for (NSString *component in urlComponents) {
        NSArray *componentsArray = [component componentsSeparatedByString:@"="];
        
        if (componentsArray.count >= 2) {
            NSString *key = componentsArray[0];
            NSString *value = componentsArray[1];
            
            if (key && value) {
                if ([key isEqualToString:@"access_token"]) {
                    [self saveAccessTokenToKeychain:value];
                }
            }
        }
    }
}

- (void)saveAccessTokenToKeychain:(NSString *)token {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:kAccessTokenKey];
    
    NSData * dataFromToken = [NSKeyedArchiver archivedDataWithRootObject:token];
    
    [keychainQuery setValue:dataFromToken forKey:(NSString *)kSecValueData];
    CFDictionaryRef cfKeychainQuery = (__bridge CFDictionaryRef)keychainQuery;
    SecItemDelete(cfKeychainQuery);
    SecItemAdd(cfKeychainQuery, nil);
    NSLog(@"Keychain Query Add Item: %@", cfKeychainQuery);
}

- (NSString *)getAccessTokenFromKeychain {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:kAccessTokenKey];
    [keychainQuery setValue:(NSNumber *)kCFBooleanTrue forKey:(NSString *)kSecReturnData];
    [keychainQuery setValue:(NSNumber *)kSecMatchLimitOne forKey:(NSString *)kSecMatchLimit];
    CFTypeRef dataRef;
    CFDictionaryRef cfKeychainQuery = (__bridge CFDictionaryRef)keychainQuery;
    
    if (SecItemCopyMatching(cfKeychainQuery, &dataRef) == noErr) {
        if (dataRef) {
            NSData *dataFromRef = (__bridge NSData *)dataRef;
            NSString *token = [NSKeyedUnarchiver unarchiveObjectWithData:dataFromRef];
            return token;
        }
    }

    NSLog(@"Keychain Query Search for Item: %@", cfKeychainQuery);

    return nil;
}

- (NSMutableDictionary *)getKeychainQuery:(NSString *)query {
    NSArray *keys = @[
                      (NSString *)kSecClass,
                      (NSString *)kSecAttrService,
                      (NSString *)kSecAttrAccount,
                      (NSString *)kSecAttrAccessible
                      ];
    NSArray *values = @[
                        (NSString *) kSecClassGenericPassword,
                        query,
                        query,
                        (NSString *) kSecAttrAccessibleAfterFirstUnlock
                        ];
    
    NSMutableDictionary *keyandvalues = [[NSMutableDictionary alloc]initWithObjects:values forKeys:keys];
    return keyandvalues;
}



@end











