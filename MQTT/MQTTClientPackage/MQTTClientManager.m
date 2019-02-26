//
//  MQTTClientManager.m
//  MQTT
//
//  Created by 休杰克曼 on 2019/2/18.
//  Copyright © 2019 休杰克曼. All rights reserved.
//

#import "MQTTClientManager.h"


@interface MQTTClientManager()<MQTTSessionManagerDelegate>


@property (strong, nonatomic) NSDictionary *dicMqttList;
@property (strong, nonatomic) MQTTSessionManager *manager;


@end


@implementation MQTTClientManager

#pragma mark - 初始化MQTT
- (instancetype)initMQTTWith:(NSString *)strName
{
    if (self = [super init]) {
        [self loadMQTTWithName:strName];
    }
    return self;
}


- (void)loadMQTTWithName:(NSString *)strName
{
    NSURL *urlBundle = [[NSBundle mainBundle]bundleURL];
    NSURL *urlList = [urlBundle URLByAppendingPathComponent:@"MQTT.plist"];
    _dicMqttList = [NSDictionary dictionaryWithContentsOfURL:urlList];

    _manager.delegate = self;
    if (!_manager) {
        _manager = [[MQTTSessionManager alloc] init];
        _manager.delegate = self;
        _manager.subscriptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:MQTTQosLevelExactlyOnce] forKey:MQTTUserSingleTopic(strName)];
        /*
         connectTo服务器地址
         port端口
         tls是否s加密
         keepalive 心跳包间隔
         clean是否清除之前记录
         auth是否用名字密码验证
         user用户
         pass密码
         will遗嘱模式是否开启
         willTopic遗嘱的topic
         willMsg
         willQos 服务质量等级
         willRetainFlag 断线重连时 如果为yes,会自动订阅回消息,如果为no,则要手动订阅topic,不然会收不到消息
         withClientId  用户ID 唯一会被挤掉
         securityPolicy 加密策略
         certificates  双向验证需要的证书相关
         protocolLevel 代理登记
         */
        [_manager connectTo:_dicMqttList[@"host"]
                       port:[_dicMqttList[@"port"] intValue]
                        tls:[_dicMqttList[@"tls"] boolValue]
                  keepalive:60
                      clean:false
                       auth:true
                       user:strName
                       pass:@"111"
                       will:true
                  willTopic:MQTTUserSingleTopic(strName)
                    willMsg:[@"offline" dataUsingEncoding:NSUTF8StringEncoding]
                    willQos:MQTTQosLevelExactlyOnce
             willRetainFlag:false
               withClientId:MQTTUserSingleTopic(strName)
             securityPolicy:nil
               certificates:nil
              protocolLevel:MQTTProtocolVersion31
             connectHandler:^(NSError *error) {
                 NSLog(@"++>>>>++%@",error);
             }];
    } else {
        [_manager connectToLast:^(NSError *error) {
            NSLog(@"------>>>>>%@",error);

        }];
    }
    [_manager addObserver:self
               forKeyPath:@"state"
                  options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                  context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    switch (_manager.state) {
        case MQTTSessionManagerStateClosed:
            NSLog(@"已经关闭");
            _getMqttPingStatusB(@"已经关闭");
            break;
        case MQTTSessionManagerStateClosing:
            NSLog(@"关闭中");
            _getMqttPingStatusB(@"关闭中");
            break;
        case MQTTSessionManagerStateConnected:
            
            NSLog(@"已经连接");
            _getMqttPingStatusB(@"已经连接");
            break;
        case MQTTSessionManagerStateConnecting:
            NSLog(@"连接中");
//            _getMqttPingStatusB(@"连接中");
            break;
        case MQTTSessionManagerStateError:
            NSLog(@"状态error");
            _getMqttPingStatusB(@"状态error");
            break;
        case MQTTSessionManagerStateStarting:
            NSLog(@"开始链接");
            _getMqttPingStatusB(@"开始链接");
            
        default:
            break;
    }
}


#pragma mark - 断开MQTT
- (void)disMQTTConnectWithStrTopic:(NSString *)strTpoic
{
    [_manager sendData:[@"leaves chat" dataUsingEncoding:NSUTF8StringEncoding]
                 topic:strTpoic
                   qos:MQTTQosLevelExactlyOnce
                retain:FALSE];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    [_manager disconnectWithDisconnectHandler:^(NSError *error) {
        
    }];
}


#pragma mark - 发消息
- (void)sendMessageWith:(NSString *)strMessage WithTpoic:(NSString *)strTopic WithSendUserName:(NSString *)strName
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:strMessage,@"message",strName,@"senderName", nil];
    NSData *data= [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [_manager sendData:data
                 topic:strTopic
                   qos:MQTTQosLevelExactlyOnce
                retain:FALSE];
}


#pragma mark - 添加主题
- (void)addTopicWithName:(NSString *)strTopic isGroup:(BOOL)isGroup
{
    if (isGroup) {
        [_manager.session subscribeToTopic:MQTTUserGroupTopic(strTopic) atLevel:MQTTQosLevelExactlyOnce];
    }else{
        [_manager.session subscribeToTopic:MQTTUserSingleTopic(strTopic) atLevel:MQTTQosLevelExactlyOnce];
    }
}

#pragma mark - 删除主题
- (void)deleteTopicWithName:(NSString *)strTopic isGroup:(BOOL)isGroup
{
    if (isGroup) {
        [_manager.session unsubscribeTopic:MQTTUserGroupTopic(strTopic)];
    }else{
        [_manager.session unsubscribeTopic:MQTTUserSingleTopic(strTopic)];
    }
}

/*
 * MQTTSessionManagerDelegate
 */
- (void)sessionManager:(MQTTSessionManager *)sessionManager
     didReceiveMessage:(NSData *)data
               onTopic:(NSString *)topic
              retained:(BOOL)retained
{
    _getMqttMessageB(data,sessionManager);
}

- (void)newMessage:(MQTTSession *)session
              data:(NSData *)data
           onTopic:(NSString *)topic
               qos:(MQTTQosLevel)qos
          retained:(BOOL)retained
               mid:(unsigned int)mid
{
    NSLog(@"1=========");
}

- (BOOL)newMessageWithFeedback:(MQTTSession *)session
                          data:(NSData *)data
                       onTopic:(NSString *)topic
                           qos:(MQTTQosLevel)qos
                      retained:(BOOL)retained
                           mid:(unsigned int)mid
{
    NSLog(@"2=========");
    return YES;
}


- (void)messageDelivered:(MQTTSession *)session msgID:(UInt16)msgID
{
    NSLog(@"3=========");
}
#pragma mark - block
- (void)getMqttPingStatus:(getMqttPingStatusBlock)block
{
    _getMqttPingStatusB = block;
}



- (void)getMqttMessage:(getMqttMessageBlock)block
{
    _getMqttMessageB = block;
}



@end
