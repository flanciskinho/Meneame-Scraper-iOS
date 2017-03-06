//
//  SCScraperManager.m
//  ScrAPPer
//
//  Created by Jacobo Rodriguez on 20/2/17.
//  Copyright © 2017 tBear Software. All rights reserved.
//

#import "SCScraperManager.h"
#import "SCScraperWebManager.h"
#import "SCNewsVO.h"
#import "AFNetworking.h"

@interface SCScraperManager ()

@property (nonatomic, strong) SCScraperWebManager *webScraper;

@end

@implementation SCScraperManager

+ (instancetype)sharedManager {
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        //NSString *userAgent = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36";
        //[[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent": userAgent}];
        _webScraper = [SCScraperWebManager new];
    }
    return self;
}

#pragma mark - User

- (void)loginWithUsername:(NSString *)userName password:(NSString *)password completion:(void(^)(NSDictionary *user, NSError *error))completion {
    
    if (completion) {
        completion(nil, [NSError new]);
    }
}

- (void)logoutWithcompletion:(void(^)(BOOL result, NSError *error))completion {
    
    if (completion) {
        completion(nil, nil);
    }
}

#pragma mark - News

- (void)newsFromPage:(NSInteger)page completion:(void(^)(NSDictionary *newsList, NSError *error))completion {
    
    NSDictionary *dictionary = @{@"page": @(page), @"elements": @[[SCNewsVO exampleObject]]};
    if (completion) {
        completion(dictionary, nil);
    }
}

#pragma mark - Notifications

- (void)notificationsWithCompletion:(void(^)(NSDictionary *notifications, NSError *error))completion {
    
    if (completion) {
        completion(nil, nil);
    }
}

#pragma mark - Search

- (void)search:(NSString *)string completion:(void(^)(NSDictionary *data, NSError *error))completion {
    
    if (completion) {
        completion(nil, nil);
    }
}

#pragma mark - Preferences

- (void)showOnlyMySubs:(BOOL)show userId:(NSString *)userId controlKey:(NSString *)controlKey completion:(void(^)(NSError *error))completion {
    
    if (completion) {
        completion(nil);
    }
}

#pragma mark - Utils

- (NSDictionary *)getWebInfoFromSourceCode:(NSString *)sourceCode {
    
    NSString *infoString = [sourceCode substringFromString:@"base_key" toString:@"}"];
    NSString *infoUser = [sourceCode substringFromString:@"<ul id=\"userinfo\">" toString:@"</ul>"];
    BOOL subsChecked = [sourceCode containsString:@"<input id=\"subs_default_header\" name=\"subs_default\" value=\"subs_default\" type=\"checkbox\" checked=\"\">"];
    
    NSDictionary *infoDict = @{@"base_key": [infoString substringFromString:@"\"" toString:@"\""],
                               @"link_id": [infoString substringFromString:@"link_id = " toString:@","],
                               @"base_url_sub": [infoString substringFromString:@"base_url_sub=\"" toString:@"\""],
                               @"user": @{@"user_login": [infoString substringFromString:@"user_login='" toString:@"'"],
                                          @"user_image": [infoUser substringFromString:@"<img id=\"avatar\" src=\"" toString:@"\""],
                                          @"user_id": [infoString substringFromString:@"user_id=" toString:@","]
                                          },
                               @"subs_default": subsChecked ? @(YES) : @(NO)
                               };
    
    return infoDict;
}

@end
