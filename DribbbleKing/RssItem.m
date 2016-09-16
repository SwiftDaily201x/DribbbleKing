//
//  RssItem.m
//  DribbbleKing
//
//  Created by Fnoz on 16/9/16.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

#import "RssItem.h"

@implementation RssItem

- (instancetype)initWithWithXMLElement:(ONOXMLElement *)element {
    self = [self init];
    if (self) {
        self.title = ((ONOXMLElement *)[element childrenWithTag:@"title"][0]).stringValue;
        self.authorName = ((ONOXMLElement *)[element childrenWithTag:@"creator"][0]).stringValue;
        self.link = ((ONOXMLElement *)[element childrenWithTag:@"link"][0]).stringValue;
        NSString *desc = ((ONOXMLElement *)[element childrenWithTag:@"description"][0]).stringValue;
        if ([desc rangeOfString:@"src=\""].location != NSNotFound) {
            NSString *subString = [desc substringFromIndex:[desc rangeOfString:@"src=\""].location + 5];
            if ([subString rangeOfString:@"\""].location != NSNotFound) {
                subString = [subString substringToIndex:[subString rangeOfString:@"\""].location];
                self.imageUrl = subString;
            }
        }
    }
    return self;
}

@end
