//
//  Y2WImageMessage.m
//  API
//
//  Created by ShingHo on 16/4/7.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WImageMessage.h"

@implementation Y2WImageMessage

- (void)updateWithDict:(NSDictionary *)dict {
    [super updateWithDict:dict];
    
    NSMutableDictionary *content = dict[@"content"];
    if ([content isKindOfClass:[NSString class]]) {
        content = [dict[@"content"] parseJsonString];
        if (!content[@"height"]) [content setValue:@"80" forKey:@"height"];
        if (!content[@"width"]) [content setValue:@"150" forKey:@"width"];
    }
    if ([content isKindOfClass:[NSDictionary class]]) {
        self.content = content;
        if (!content[@"height"]) [content setValue:@"80" forKey:@"height"];
        if (!content[@"width"]) [content setValue:@"150" forKey:@"width"];
    }
    self.imageUrl = [NSString stringWithFormat:@"%@%@?access_token=%@",[URL baseURL],content[@"src"],[[Y2WUsers getInstance].getCurrentUser token]];
    self.thumImageUrl = [NSString stringWithFormat:@"%@%@?access_token=%@",[URL baseURL],content[@"thumbnail"],[[Y2WUsers getInstance].getCurrentUser token]];
    self.text = @"[图片]";
}

@end
