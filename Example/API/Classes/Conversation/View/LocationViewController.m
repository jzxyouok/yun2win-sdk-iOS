//
//  LocationViewController.m
//  API
//
//  Created by ShingHo on 16/4/13.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LocationPoint.h"

@interface LocationViewController (){
    BOOL _updateUserLocation;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLGeocoder *geoCoder;

@property (nonatomic, strong) UIBarButtonItem *sendButton;

@property (nonatomic, strong) LocationPoint *locationPoint;

@end

@implementation LocationViewController

- (instancetype)initWithLocationPoint:(LocationPoint *)locationPoint
{
    if (self = [super init]) {
        _locationPoint = locationPoint;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.locationPoint) {
        MKCoordinateRegion theRegion;
        theRegion.center = self.locationPoint.coordinate;
        theRegion.span.longitudeDelta	= 0.01f;
        theRegion.span.latitudeDelta	= 0.01f;
        [self.mapView addAnnotation:self.locationPoint];
        [self.mapView setRegion:theRegion animated:YES];
    }
    [self setUpRightNavButton];
    [self.view addSubview:self.mapView];
    [self.locationManager startUpdatingLocation];
    if ([CLLocationManager locationServicesEnabled]) {
        if (IOS8) {
            [self.locationManager requestAlwaysAuthorization];
        }
        CLAuthorizationStatus status = CLLocationManager.authorizationStatus;
        if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied)
        {
            [self showLocationPermission];
        }
        else    self.mapView.showsUserLocation = YES;
    }
    else
    {
        [self showLocationPermission];
    }
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    self.mapView.frame = self.view.bounds;
//}

- (void)setUpRightNavButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onSend:)];
    self.navigationItem.rightBarButtonItem = item;
    self.sendButton = item;
    self.sendButton.enabled = NO;
}

- (void)showLocationPermission
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的手机目前微开启定位服务，如需开启定位服务，请至设置->隐私->定位服务，开启本程序的定位服务功能" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:doneAction];
    [self showDetailViewController:alert sender:nil];
}

- (void)onSend:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onSendLocation:)]) {
        [self.delegate onSendLocation:self.locationPoint];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (!_updateUserLocation) {
        return;
    }
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    [self reverseGeoLocation:centerCoordinate];
}



- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if (!_updateUserLocation) {
        return;
    }
    [self.mapView removeAnnotations:self.mapView.annotations];
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    static NSString *reusePin = @"reusePin";
    MKPinAnnotationView * pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reusePin];
    if (!pin) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reusePin];
    }
    pin.canShowCallout	= YES;
    return pin;
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    _updateUserLocation = YES;
    MKCoordinateRegion theRegion;
    theRegion.center = userLocation.coordinate;
    theRegion.span.longitudeDelta	= 0.01f;
    theRegion.span.latitudeDelta	= 0.01f;
    [self.mapView setRegion:theRegion animated:NO];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    [self.mapView selectAnnotation:self.locationPoint animated:YES];
    UIView * view = [mapView viewForAnnotation:self.mapView.userLocation];
    view.hidden = YES;
}


- (void)reverseGeoLocation:(CLLocationCoordinate2D)locationCoordinate2D{
    if (self.geoCoder.isGeocoding) {
        [self.geoCoder cancelGeocode];
    }
    CLLocation *location = [[CLLocation alloc]initWithLatitude:locationCoordinate2D.latitude
                                                     longitude:locationCoordinate2D.longitude];
    __weak LocationViewController *wself = self;
    self.sendButton.enabled = NO;
    [self.geoCoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil) {
             CLPlacemark *mark = [placemarks lastObject];
             NSString * title  = [wself nameForPlaceMark:mark];
             
             UIImage *image = [self.view screenshot];
             NSString *imgName = [NSString stringWithFormat:@"IMG_%@.jpeg", @([NSDate timeIntervalSinceReferenceDate])];
             NSString *imgPath = [NSString getDocumentPathInbox:imgName];
             NSData *imgData = UIImageJPEGRepresentation(image,0.1);
             [imgData writeToFile:imgPath atomically:YES];             
             
             LocationPoint *ponit = [[LocationPoint alloc]initWithCoordinate:locationCoordinate2D Title:title addressImage:image imagePath:imgPath];
             wself.locationPoint = ponit;
             [wself.mapView addAnnotation:ponit];
             wself.sendButton.enabled = YES;
         } else {
             wself.locationPoint = nil;
         }
     }];
}

- (NSString *)nameForPlaceMark: (CLPlacemark *)mark
{
    NSString *name = ABCreateStringWithAddressDictionary(mark.addressDictionary,YES);
    unichar characters[1] = {0x200e};   //format之后会出现这个诡异的不可见字符，在android端显示会很诡异，需要去掉
    NSString *invalidString = [[NSString alloc]initWithCharacters:characters length:1];
    NSString *formattedName =  [[name stringByReplacingOccurrencesOfString:@"\n" withString:@" "]
                                stringByReplacingOccurrencesOfString:invalidString withString:@""];
    return formattedName;
}

//#pragma mark - Helper
//- (UIImage *)getImage
//{
//    //整屏截图
//    
//    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 1.0);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    return image;
////    //截取
////    CGRect myImageRect = CGRectMake(0, self.view.center.y - 100, image.size.width, 220);
////    CGImageRef imageRef = image.CGImage;
////    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
////
////    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
////    NSLog(@"---%lf,%lf",smallImage.size.height,smallImage.size.width);
////    UIGraphicsEndImageContext();
////    return smallImage;
//
//}


#pragma mark - 初始化
- (MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc]init];
        _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        _mapView.mapType = MKMapTypeStandard;
        _mapView.delegate = self;
        _mapView.frame = self.view.bounds;

    }
    return _mapView;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
    }
    return _locationManager;
}

- (CLGeocoder *)geoCoder
{
    if(!_geoCoder)
    {
        _geoCoder = [[CLGeocoder alloc]init];
    }
    return _geoCoder;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
