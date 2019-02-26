//
//  PersonMain_Veiw.h
//  MQTT
//
//  Created by 休杰克曼 on 2019/2/22.
//  Copyright © 2019 休杰克曼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonMain_VC.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^checkSingleChatBtnBlock)(NSString *strTheme);
typedef void(^checkGroupChatBtnBlock)(NSString *strTheme);

@interface PersonMain_Veiw : UIView

@property (nonatomic,copy)checkSingleChatBtnBlock checkSingleChatBtnB;
@property (nonatomic,copy)checkGroupChatBtnBlock checkGroupChatBtnB;

- (instancetype)initWithFrame:(CGRect)frame SuperView:(UIViewController *)superView UserName:(NSString *)strName;

- (void)checkSingleChatBtn:(checkSingleChatBtnBlock)block;
- (void)checkGroupChatBtnBlock:(checkGroupChatBtnBlock)block;
@end

NS_ASSUME_NONNULL_END
