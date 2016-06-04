//
//  Y2WFileMessage.m
//  API
//
//  Created by ShingHo on 16/4/8.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WFileMessage.h"

@implementation Y2WFileMessage

- (void)updateWithDict:(NSDictionary *)dict {
    [super updateWithDict:dict];
    NSMutableDictionary *content = dict[@"content"];
    if ([content isKindOfClass:[NSString class]]) {
        content = [dict[@"content"] parseJsonString];
    }
    if ([content isKindOfClass:[NSDictionary class]]) {
        self.content = content;
    }
    self.fileUrl = [NSString stringWithFormat:@"/%@%@?access_token=%@",[URL baseURL],content[@"src"],[[Y2WUsers getInstance].getCurrentUser token]];
    self.filePath = content[@"size"];
    self.text = @"[文件]";
}

@end
