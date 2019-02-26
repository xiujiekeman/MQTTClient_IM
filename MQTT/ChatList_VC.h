//
//  ChatList_VC.h
//  MQTT
//
//  Created by 休杰克曼 on 2019/2/22.
//  Copyright © 2019 休杰克曼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQTTClientManager.h"

typedef NS_ENUM(NSInteger, enterType) {
    singleType = 0,
    groupType = 1
};
NS_ASSUME_NONNULL_BEGIN

@interface ChatList_VC : UIViewController

@property (nonatomic,strong)MQTTClientManager *mqttManager;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,assign)enterType enterType;

@end

NS_ASSUME_NONNULL_END
