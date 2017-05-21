//
//  HistoryViewController.h
//  GoogleMapApp
//
//  Created by Amr Elghadban on 5/21/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import "ParentUIViewController.h"

@interface HistoryViewController : ParentUIViewController  <UITableViewDataSource,UITableViewDelegate>
{


}

@property (strong, nonatomic) IBOutlet UITableView *tblView;

@property (strong, nonatomic) NSMutableArray *mAddress;
@property (weak, nonatomic) IBOutlet UIButton *navigationbackButton;

- (IBAction)navigationBackButtonAction:(id)sender;

@end
