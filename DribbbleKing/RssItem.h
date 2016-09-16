//
//  RssItem.h
//  DribbbleKing
//
//  Created by Fnoz on 16/9/16.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONOXMLDocument.h"

@interface RssItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *link;

- (instancetype)initWithWithXMLElement:(ONOXMLElement *)element;

@end
