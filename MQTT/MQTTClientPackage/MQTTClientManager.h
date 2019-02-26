//
//  MQTTClientManager.h
//  MQTT
//
//  Created by 休杰克曼 on 2019/2/18.
//  Copyright © 2019 休杰克曼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MQTTClient/MQTTClient.h>
#import <MQTTClient/MQTTSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^getMqttPingStatusBlock)(NSString *strState);
typedef void(^getMqttMessageBlock)(NSData *MessageData ,MQTTSessionManager *sessionManager);

@interface MQTTClientManager : NSObject


@property (nonatomic,copy)getMqttPingStatusBlock getMqttPingStatusB;
@property (nonatomic,copy)getMqttMessageBlock getMqttMessageB;


//初始化
- (instancetype)initMQTTWith:(NSString *)strName;

//发送信息
- (void)sendMessageWith:(NSString *)strMessage WithTpoic:(NSString *)strTopic WithSendUserName:(NSString *)strName;

//断开连接
- (void)disMQTTConnect;

//添加主题
- (void)addTopicWithName:(NSString *)strTopic isGroup:(BOOL)isGroup;
//删除主题
- (void)deleteTopicWithName:(NSString *)strTopic isGroup:(BOOL)isGroup;

//block
- (void)getMqttPingStatus:(getMqttPingStatusBlock)block;
- (void)getMqttMessage:(getMqttMessageBlock)block;

@end

NS_ASSUME_NONNULL_END
