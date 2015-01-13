//
//  GroupWidgetView.h
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "BaseGroupWidgetView.h"

@interface GroupWidgetView : BaseGroupWidgetView
@property(nonatomic,strong) NSMutableArray* widgetsView; // <BaseWidget>
@property(nonatomic,assign) BOOL labelsVisible;
-(void) addChildWidget:(BaseWidgetView*)child;
-(void) onAfterChildrenInit;
@end
