//
//  ThreadHelper.h
//  Karmadam
//
//  Created by Amr Elghadban on 3/8/15.
//  Copyright (c) 2015 Amr Elghadban. All rights reserved.
//

#import <Foundation/Foundation.h>

void runInUIThread(void (^block) (void));

void runInBackGround(void (^block) (void));

