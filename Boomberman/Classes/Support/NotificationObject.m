//
//  NotificationObject.m
//  WalaCamera
//
//  Created by Vinh on 7/22/13.
//  Copyright (c) 2013 Wala. All rights reserved.
//

#import "NotificationObject.h"

@interface NotificationObject ()

@end

@implementation NotificationObject

@synthesize notificationType    = _notificationType;
@synthesize notificationObject  = _notificationObject;

#pragma mark - init
- (id)init {
    self = [super init];
    if (self) {
        _notificationType   = kNotificationMessageTypeUndifine;
        _notificationObject = nil;
    }
    return self;
}

- (id)initWithType:(kNotificationMessageType)type object:(id)object {
    self = [super init];
    if (self) {
        _notificationType   = type;
        _notificationObject = object;
    }
    return self;
}

#pragma mark - memory
- (void)releaseUI {
    
}

- (void)releaseData {
    
}

- (void)viewDidUnload {
    [self releaseUI];
}

- (void)dealloc
{
    [self releaseUI];
    [self releaseData];
    [super dealloc];
}

@end
