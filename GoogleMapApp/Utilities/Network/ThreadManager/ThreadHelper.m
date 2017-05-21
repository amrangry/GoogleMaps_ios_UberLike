//
//  ThreadHelper.m
//  Karmadam
//
//  Created by Amr Elghadban on 3/8/15.
//  Copyright (c) 2015 Amr Elghadban. All rights reserved.
//

#import "ThreadHelper.h"

void runInUIThread(void (^block) (void)){
    dispatch_async(dispatch_get_main_queue(), block);
}

void runInBackGround(void (^block) (void)){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

