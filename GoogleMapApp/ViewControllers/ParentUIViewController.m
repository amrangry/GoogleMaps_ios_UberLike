//
//  ParentUIViewController.m
//
//  Karmadam
//
//  Created by Amr Elghadban on 3/8/15.
//  Copyright (c) 2015 Amr Elghadban. All rights reserved.
//

#import "ParentUIViewController.h"

#import <CommonCrypto/CommonDigest.h>

@interface ParentUIViewController ()

@end

@implementation ParentUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma -mark helper method



-(BOOL) IsEmpty:(id) object {
    return object == nil || ([object respondsToSelector:@selector(length)] && [(NSData *) object length] == 0)
    || ([object respondsToSelector:@selector(count)]
        && [(NSArray *) object count] == 0);
}


@end
