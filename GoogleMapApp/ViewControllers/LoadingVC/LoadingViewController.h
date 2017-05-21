//
//  LoadingViewController.h
//  Karmadam
//
//  Created by Amr Elghadban on 5/15/17.
//  Copyright © 2017 KarmaDam. All rights reserved.
//

#import "ParentUIViewController.h"

@interface LoadingViewController : ParentUIViewController
{
    IBOutlet UIImageView *gifImage;
    
    
    __weak IBOutlet UIView *doneLoadingView;
    
    __weak IBOutlet UIImageView *doneLoadingGifImage;
}


/**
 *  This Function Used For Removing the Splash
 */
-(void)removeSplash;

@end
