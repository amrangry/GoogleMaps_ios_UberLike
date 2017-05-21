//
//  LoadingViewController.m
//  Karmadam
//
//  Created by Amr Elghadban on 5/15/17.
//  Copyright © 2017 KarmaDam. All rights reserved.
//

#import "LoadingViewController.h"
#import "UIImage+animatedGIF.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    doneLoadingView.hidden=YES;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"splash_giphy" withExtension:@"gif"];
    
    gifImage.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    
    gifImage.animationRepeatCount =0;
}

-(void)viewDidAppear:(BOOL)animated
{
    
    
    [self performSelector:@selector(doneLoading) withObject:self afterDelay:1];
    
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) doneLoading{
    
//    doneLoadingView.hidden=NO;
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"marvel-gif" withExtension:@"gif"];
//    
//    doneLoadingGifImage.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeSplash) userInfo:Nil repeats:NO];

}
-(void)removeSplash
{
   
        ParentUIViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GoogleMapVCViewController"];
        
        [[self navigationController ] pushViewController:mainVC animated:NO];
        
    
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
