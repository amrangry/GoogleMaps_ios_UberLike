//
//  PickUpViewController.h
//  Karmadam
//
//  Created by Amr Elghadban on 3/8/15.
//  Copyright (c) 2015 Amr Elghadban. All rights reserved.
//
#import <UIKit/UIKit.h>


#import "ParentUIViewController.h"


/**
 *  Getting Address From DataBase Delegate Method
 */
@protocol PickUpAddressDelegate <NSObject>

@optional

-(void)getAddressFromPickUpAddressVC:(NSDictionary *)addressDetails;

@end



@interface PickUpViewController : ParentUIViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) BOOL isComingFromMapVCFareButton;
@property(nonatomic,assign) NSInteger typeID;
@property(strong, nonatomic)  NSString *searchString;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarController;
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *mAddress;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (assign, nonatomic) NSInteger locationType;
@property (weak, nonatomic) IBOutlet UIButton *navigationbackButton;
/**
 *  Id of the above Getting address From PickUpVC Delegate Method
 */
@property (nonatomic,assign) id pickUpAddressDelegate;

- (IBAction)navigationBackButtonAction:(id)sender;


@end
