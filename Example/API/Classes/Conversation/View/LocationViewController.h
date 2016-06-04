//
//  LocationViewController.h
//  API
//
//  Created by ShingHo on 16/4/13.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class LocationPoint;

@protocol LocationViewControllerDelegate <NSObject>

- (void)onSendLocation:(LocationPoint *)locationPoint;

@end

@interface LocationViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic,weak) id<LocationViewControllerDelegate> delegate;

- (instancetype)initWithLocationPoint:(LocationPoint *)locationPoint;

@end
