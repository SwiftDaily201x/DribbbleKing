//
//  RssItemCell.h
//  DribbbleKing
//
//  Created by Fnoz on 16/9/16.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RssItem.h"

@interface RssItemCell : UITableViewCell

- (void)loadItem:(RssItem *)item;

@end
