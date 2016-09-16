
//
//  RssItemCell.m
//  DribbbleKing
//
//  Created by Fnoz on 16/9/16.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

#import "RssItemCell.h"
#import "ConstDef.h"
#import "UIImageView+WebCache.h"

@interface RssItemCell ()

@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UILabel *mainTextLabel;

@end

@implementation RssItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.mainImageView];
        [self.contentView addSubview:self.mainTextLabel];
    }
    return self;
}

- (UIImageView *)mainImageView {
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.75)];
    }
    return _mainImageView;
}

- (UILabel *)mainTextLabel {
    if (!_mainTextLabel) {
        _mainTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH * 0.75 - 30, SCREEN_WIDTH, 30)];
        _mainTextLabel.textColor = [UIColor colorWithRed:155 / 255.0 green:89 / 255.0 blue:182 / 255.0 alpha:1];
        _mainTextLabel.font = [UIFont systemFontOfSize:17];
        _mainTextLabel.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    }
    return _mainTextLabel;
}

- (void)loadItem:(RssItem *)item {
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    self.mainTextLabel.text = [NSString stringWithFormat:@"  [%@]  %@", item.authorName, item.title];
}

@end
