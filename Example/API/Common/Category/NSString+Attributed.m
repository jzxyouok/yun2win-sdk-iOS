//
//  NSString+Attributed.m
//  LYY
//
//  Created by QS on 15/1/24.
//  Copyright (c) 2015年 lyy. All rights reserved.
//

#import "NSString+Attributed.h"
#import "EmojiManage.h"
@implementation NSString (Attributed)

- (NSMutableAttributedString *)stringForAttributedString
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, self.length)];

    NSArray *resultArray = [self findExpressions];
//    NSArray *expressions = [ExpressionManager manager].expressionArray;
    NSArray *expressions = [EmojiManage shareEmoji].emojisDic[@"People"];
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(NSTextCheckingResult *match in resultArray) {
        NSRange range = [match range];
        NSString *subStr = [self substringWithRange:range];

        for (NSDictionary *dict in expressions)
        {
            NSString *tempString = [NSString stringWithFormat:@"[%@]",dict[@"name"]];
            if ([tempString isEqualToString:subStr])
            {
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //[UIImage imageWithContentsOfFile:@""]
                textAttachment.image = [UIImage imageWithContentsOfFile:dict[@"path"]];
                textAttachment.bounds = CGRectMake( 0, - 3, 14*1.3, 14*1.3);
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];

                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                [imageArray addObject:imageDic];
            }
        }
    }
    for (NSInteger i = imageArray.count -1; i >= 0; i--)
    {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        [string replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
    
    return string;
}
- (NSString *)showNameReplaceSendName
{
    NSString *string = self;
    NSString *pattern = @"\\[[^\\]]*\\]";
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *resultArray = [re matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Expression" ofType:@"plist"];
    NSArray *expressions = [NSArray arrayWithContentsOfFile:plistPath];
    
    for(NSTextCheckingResult *match in [[resultArray reverseObjectEnumerator] allObjects]) {
        NSRange range = [match range];
        NSString *subStr = [self substringWithRange:range];

        for (NSDictionary *dict in expressions)
        {
            if ([dict[@"showName"] isEqualToString:subStr])
            {
                string = [string stringByReplacingCharactersInRange:range withString:dict[@"sendName"]];
            }
        }
    }
    return string;
}

- (CGSize)sizeAttributedWithWidth:(CGFloat)width
{
    NSAttributedString *string = [self stringForAttributedString];
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;

    return  size;
}





- (NSArray *)findValue:(NSString *)value
{
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:value options:NSRegularExpressionCaseInsensitive error:nil];
    return [re matchesInString:self options:0 range:NSMakeRange(0, self.length)];
}
- (NSArray *)findExpressions
{
    NSString *pattern = @"\\[[^\\]]*\\]";
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    return [re matchesInString:self options:0 range:NSMakeRange(0, self.length)];
}
- (NSArray *)findLink
{
    NSString *pattern = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    return [re matchesInString:self options:0 range:NSMakeRange(0, self.length)];
}

- (BOOL)isLink
{
    NSString *pattern = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    return [[re matchesInString:self options:0 range:NSMakeRange(0, self.length)] count];
}

@end



//@implementation NSAttributedString (Attributed)
//
//- (NSMutableAttributedString *)showLinkIsMy:(BOOL)isMy
//{
//    UIColor *color = isMy?[UIColor lyyLinkIsMy]:[UIColor lyyLinkIsOther];
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:self];
//    
//    NSArray *resulArray = [string.string findLink];
//
//    for(NSTextCheckingResult *match in resulArray) {
//        [string addAttribute:NSForegroundColorAttributeName value:color range:match.range];
//    }
//    
//    return string;
//}
//
//@end
