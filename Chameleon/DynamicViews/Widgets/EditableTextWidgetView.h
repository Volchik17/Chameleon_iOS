//
//  EditableTextWidgetView.h
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "BaseFieldWidgetView.h"

@interface EditableTextWidgetView : BaseFieldWidgetView
@property(nonatomic,assign) int size;
//@property(nonatomic,assign) BOOL enable;
@property(nonatomic,assign) BOOL editable;
@end
