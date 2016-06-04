//
//  LocationPoint.h
//  API
//
//  Created by ShingHo on 16/4/13.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationPoint : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly , copy) NSString *title;

@property (nonatomic, strong) UIImage *addressImage;

@property (nonatomic, copy) NSString *imagePath;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate Title:(NSString *)title addressImage:(UIImage *)image imagePath:(NSString *)imagePath;

- (instancetype)initWithMessage:(Y2WBaseMessage *)message;

@end
