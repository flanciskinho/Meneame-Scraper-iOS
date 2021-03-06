//
//  SCNewsVO.m
//  ScrAPPer
//
//  Created by Jacobo Rodriguez on 1/3/17.
//  Copyright © 2017 tBear Software. All rights reserved.
//

#import "SCNewsVO.h"

#import "SCManageModel.h"
#import "NSString+Utils.h"

@implementation SCNewsVO

@dynamic userName;

+ (instancetype)new {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:COREDATA.mainObjectContext];
    id object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:COREDATA.mainObjectContext];
    return object;
}

+ (instancetype)exampleObject {
    
    SCNewsVO *news = [SCNewsVO new];
    news.meneos = 384;
    news.votesPositive = 123;
    news.votesAnonymous = 25;
    news.votesNegative = 2;
    news.karma = 6;
    news.commentsCount = 12;
    news.title = @"News Title";
    news.userUrl = @"User";
    news.soruceTitle = @"Source";
    news.sourceUrl = @"http://www.google.es";
    news.content = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque fringilla iaculis nisi eu imperdiet. Nam scelerisque aliquet lectus, in ultricies velit cursus nec. Vestibulum luctus sapien vel libero bibendum luctus. Phasellus ut mauris neque. Mauris nec nulla in felis consequat mollis id vitae turpis. Vestibulum viverra lorem ut quam consectetur, ut gravida nulla maximus. Praesent condimentum risus et odio commodo, non ullamcorper purus volutpat.";
    
    return news;
}

+ (NSArray *)newsFromSourceCode:(NSString *)sourceCode {
    
    NSMutableArray *newsFound = [NSMutableArray new];
    
//    JRJavascript *js = [JRJavascript sharedManager];
//    js.sourceCode = sourceCode;
//    
//    NSArray *elements = [js getElementsByClassName:@"news-summary"];
//    for (NSString *element in elements) {
//        
//        js.sourceCode = element;
//        
//        SCNewsVO *news = [SCNewsVO new];
//        news.title = [[js getElementsByTagName:@"h2"] firstObject];
//        
//        NSLog(@"News: %@", news.description);
//    }
    
    NSArray *elements = [sourceCode componentsSeparatedByString:@"news-summary"];
    for (NSString *element in elements) {
        if (element != elements.firstObject) {
            
            SCNewsVO *news = [SCNewsVO new];
            
            NSString *meneosDiv = [element substringFromString:@"<div class=\"votes\">" toString:@"</div>"];
            news.meneos = [[meneosDiv substringFromString:@"\">" toString:@"</a>"] intValue];
            
            NSString *imageDiv = [element substringFromString:@"class=\"fancybox thumbnail-wrapper\"" toString:@"</a>"];
            NSString *imageSrc = [imageDiv substringFromString:@" data-src='" toString:@"'"];
            if (imageSrc.length == 0) {
                imageSrc = [imageDiv substringFromString:@" data-src=\"" toString:@"\""];
            }
            news.imageUrl = imageSrc.length > 0 ? [NSString stringWithFormat:@"https://mnmstatic.net/%@", imageSrc] : nil;
            
            NSString *titleDiv = [element substringFromString:@"<h2>" toString:@"</h2>"];
            news.url = [titleDiv substringFromString:@"href=\"" toString:@"\""];
            news.title = [titleDiv substringFromString:@">" toString:@"</a>"];
            
            if ([element substringFromString:@"<i class=\"fa fa-camera\" alt=\"imagen\" title=\"imagen\">" toString:nil].length > 0) {
                news.type = SCNewsTypeImage;
            } else if ([element substringFromString:@"<i class=\"fa fa-video-camera\" alt=\"imagen\" title=\"imagen\">" toString:nil].length > 0) {
                news.type = SCNewsTypeVideo;
            } else {
                news.type = SCNewsTypeNormal;
            }
            
            NSString *newsSubmittedDiv = [element substringFromString:@"<div class=\"news-submitted\">" toString:@"</div>"];
            news.userUrl = [newsSubmittedDiv substringFromString:@"<a href=\"" toString:@"\""];
            news.userImageUrl = [newsSubmittedDiv substringFromString:@"<img src=\"" toString:@"\""];
            
            NSString *sourceDiv = [element substringFromString:@"<span class=\"showmytitle\"" toString:@"</span>"];
            news.sourceUrl = [sourceDiv substringFromString:@"title=\"" toString:@"\""];
            news.soruceTitle = [sourceDiv substringFromString:@">" toString:@"<"];
            
            double sendedTimestamp = [[newsSubmittedDiv substringFromString:@"<span data-ts=\"" toString:@"\"" index:0] doubleValue];
            news.sendedDate = [NSDate dateWithTimeIntervalSince1970:sendedTimestamp];
            
            double publishedTimestamp = [[newsSubmittedDiv substringFromString:@"<span data-ts=\"" toString:@"\"" index:1] doubleValue];
            news.sendedDate = [NSDate dateWithTimeIntervalSince1970:publishedTimestamp];
            
            news.content = [element substringFromString:@"<div class=\"news-content\">" toString:@"</div>"];
            
            NSString *votesUpDiv = [element substringFromString:@"<span class=\"votes-up\"" toString:@"</span>"];
            news.votesPositive = [[votesUpDiv substringFromString:@"<strong>" toString:@"</strong>"] intValue];
            
            NSString *votesAnonymousDiv = [element substringFromString:@"<span class=\"wideonly votes-anonymous\"" toString:@"</span>"];
            news.votesAnonymous = [[votesAnonymousDiv substringFromString:@"<strong>" toString:@"</strong>"] intValue];
            
            NSString *votesDownDiv = [element substringFromString:@"<span class=\"votes-down\"" toString:@"</span>"];
            news.votesNegative = [[votesDownDiv substringFromString:@"<strong>" toString:@"</strong>"] intValue];
            
            NSString *karmaDiv = [element substringFromString:@"<span class=\"karma-value\"" toString:@"</span>"];
            news.karma = [[karmaDiv substringFromString:@">  " toString:@"  "] intValue];
            
            NSString *commentsDiv = [element substringFromString:@"<i class=\"fa fa-comments\">" toString:@"</a>"];
            news.commentsCount = [[commentsDiv substringFromString:@"</i>" toString:@" comentarios"] intValue];
            
            [newsFound addObject:news];
        }
    }
    
    return newsFound;
}

#pragma mark - Getter

- (NSString *)userName {
    
    return [self.userUrl stringByReplacingOccurrencesOfString:@"/user/" withString:@""];
}

@end
