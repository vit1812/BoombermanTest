//
//  NotificationObject.h
//  WalaCamera
//
//  Created by Vinh on 7/22/13.
//  Copyright (c) 2013 Wala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationObject : NSObject

@property (nonatomic, assign) kNotificationMessageType  notificationType;
@property (nonatomic, assign) id                        notificationObject;

- (id)initWithType:(kNotificationMessageType)type object:(id)object;

@end
