//
//  ContactModel.m
//  API
//
//  Created by QS on 16/3/10.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel
@synthesize name = _name;
@synthesize uid = _uid;
@synthesize imageUrl = _imageUrl;
@synthesize image = _image;
@synthesize rowHeight = _rowHeight;
@synthesize sortKey = _sortKey;
@synthesize groupTitle = _groupTitle;
@synthesize label = _label;

- (instancetype)initWithContact:(Y2WContact *)contact {
    if (self = [super init]) {
        _name = contact.name;
        _uid = contact.userId.uppercaseString;
        _imageUrl = contact.avatarUrl;
        _image = [UIImage imageNamed:@"默认个人头像"];
        _rowHeight = 50;
        _sortKey = contact.name;
        _groupTitle = [[[contact.pinyin firstObject] first] uppercaseString];
        _contact = contact;
    }
    return self;
}

@end
