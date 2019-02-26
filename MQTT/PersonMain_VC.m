//
//  PersonMain_VC.m
//  MQTT
//
//  Created by 休杰克曼 on 2019/2/22.
//  Copyright © 2019 休杰克曼. All rights reserved.
//

#import "PersonMain_VC.h"
#import "PersonMain_Veiw.h"
#import "MQTTClientManager.h"
#import "ChatList_VC.h"
#import "Login_VC.h"
@interface PersonMain_VC ()
{
    MQTTClientManager *_manager;
    NSString *_userName;
}
@end

@implementation PersonMain_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    Login_VC *logvc = [[Login_VC alloc]init];
    [logvc selectUserLogin:^(NSString * _Nonnull strUserName) {
        self->_userName = strUserName;
        [self loadMQTT];
        [self creatUI];
    }];
    [self.navigationController presentViewController:logvc animated:YES completion:^{
        
    }];
}



- (void)creatUI
{
    PersonMain_Veiw *viewPersonMain = [[PersonMain_Veiw alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, KDeviceWidth, KDeviceHeight - kNavBarHeight) SuperView:self UserName:_userName];
    [viewPersonMain checkSingleChatBtn:^(NSString * _Nonnull strTheme) {
        ChatList_VC *vc = [[ChatList_VC alloc]init];
        vc.enterType = singleType;
        vc.mqttManager = self->_manager;
        vc.title = strTheme;
        vc.userName = self->_userName;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [viewPersonMain checkGroupChatBtnBlock:^(NSString * _Nonnull strTheme) {
        [self->_manager addTopicWithName:strTheme isGroup:YES];
        ChatList_VC *vc = [[ChatList_VC alloc]init];
        vc.enterType = groupType;
        vc.mqttManager = self->_manager;
        vc.title = strTheme;
        vc.userName = self->_userName;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:viewPersonMain];
}


- (void)loadMQTT
{
    _manager = [[MQTTClientManager alloc]initMQTTWith:_userName];
    //连接状态
    [_manager getMqttPingStatus:^(NSString * _Nonnull strState) {
        
    }];
    //收到消息
    [_manager getMqttMessage:^(NSData * _Nonnull MessageData, MQTTSessionManager * _Nonnull sessionManager) {
        NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:MessageData options:NSJSONReadingMutableLeaves error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getmessage" object:sessionManager userInfo:dictionary];
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
