//
//  PickUpViewController.m
//  Karmadam
//
//  Created by Amr Elghadban on 3/8/15.
//  Copyright (c) 2015 Amr Elghadban. All rights reserved.
//

#import "PickUpViewController.h"

#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>

#import "ConstantsVariables.h"



@interface PickUpViewController ()
{
    NSMutableArray *previouslySelectedAddress;
    NSMutableArray *managedAddress;
    GMSPlacesClient *placesClient;
    //    BOOL isManageAddressAvailable;
}

@property(nonatomic,assign) BOOL isSearchResultCome;
@property NSTimer *autoCompleteTimer;
@property NSString *substring;
@property NSMutableArray *pastSearchWords;
@property NSMutableArray *pastSearchResults;

@end

@implementation PickUpViewController

@synthesize latitude;
@synthesize longitude;
@synthesize locationType;
@synthesize isSearchResultCome;


#pragma mark - Initial Methods -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    placesClient = [GMSPlacesClient sharedClient];
    self.mAddress = [NSMutableArray array];
    
    //    self.searchBarController.searchBarStyle = UISearchBarStyleProminent;
    
    self.pastSearchWords = [NSMutableArray array];
    self.pastSearchResults = [NSMutableArray array];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [_searchBarController becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)refresh:(UIRefreshControl *)refreshControl
{
    [refreshControl endRefreshing];
}

#pragma mark - UIButton Actions -

- (IBAction)navigationBackButtonAction:(id)sender
{
    [self.view endEditing:YES];
    
   
    
    [self.navigationController popViewControllerAnimated:NO];
    
    //    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  - UITableView DataSource -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.searchBarController.text.length == 0)
    {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.searchBarController.text.length == 0)
    {
        if(section == 0)
        {
            return managedAddress.count;
        }
        else
        {
            return previouslySelectedAddress.count;
        }
    }
    return self.mAddress.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell=nil;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.backgroundColor=[UIColor clearColor];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        cell.backgroundColor=[UIColor clearColor];
        //cell.textLabel.font = [UIFont fontWithName:OpenSans_Regular size:14];
        cell.textLabel.textColor = UIColor.redColor;//UIColorFromRGB(0x4A4971);
        //cell.detailTextLabel.font = [UIFont fontWithName:OpenSans_Regular size:12];
        cell.detailTextLabel.textColor = UIColor.brownColor;//UIColorFromRGB(0x7e7e7e);
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    if(self.searchBarController.text.length == 0)
    {
        //For Managed Address Cell
        if(indexPath.section == 0)
        {
            cell.textLabel.numberOfLines = 1;
            
            if([managedAddress[indexPath.row][@"suite_num"] length] > 0){
                
                [cell.textLabel setText:[NSString stringWithFormat:@"%@, %@",managedAddress[indexPath.row][@"suite_num"],managedAddress[indexPath.row][@"address1"]]];
            }
            else{
                
                cell.textLabel.text = managedAddress[indexPath.row][@"address1"];
            }
            
            if([managedAddress[indexPath.row][@"tag_address"]length] > 0)
            {
                cell.detailTextLabel.text = managedAddress[indexPath.row][@"tag_address"];
            }
            else
            {
                cell.detailTextLabel.text = @"";
            }
        }
        else//For Previously Selected Address Cell
        {
            NSDictionary *searchResult = [previouslySelectedAddress objectAtIndex:indexPath.row];
            cell.textLabel.text = searchResult[@"add1"];
            cell.detailTextLabel.text = searchResult[@"add2"];
        }
        
    }
    else//For Currently Searched Address Cell
    {
        GMSAutocompletePrediction *searchResult = (GMSAutocompletePrediction *)[self.mAddress objectAtIndex:indexPath.row];
        cell.textLabel.text = searchResult.attributedPrimaryText.string;
        cell.detailTextLabel.text = searchResult.attributedSecondaryText.string;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell=nil;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.backgroundColor=[UIColor clearColor];
    
    if(cell == nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        
       // cell.textLabel.font = [UIFont fontWithName:OpenSans_Regular size:14];
        cell.textLabel.textColor = UIColor.redColor;//UIColorFromRGB(0x4A4971);
        cell.textLabel.numberOfLines = 0;
        
      //  cell.detailTextLabel.font = [UIFont fontWithName:OpenSans_Regular size:12];
        cell.detailTextLabel.textColor =UIColor.redColor;// UIColorFromRGB(0x7e7e7e);
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    float height1;
    float height2;
    
    if(self.searchBarController.text.length == 0)
    {
        //For Managed Address Cell
        if(indexPath.section == 0)
        {
            cell.textLabel.numberOfLines = 1;
            cell.detailTextLabel.numberOfLines = 1;
            
            if([managedAddress[indexPath.row][@"suite_num"] length] > 0){
                
                [cell.textLabel setText:[NSString stringWithFormat:@"%@, %@",managedAddress[indexPath.row][@"suite_num"],managedAddress[indexPath.row][@"address1"]]];
            }
            else{
                
                cell.textLabel.text = managedAddress[indexPath.row][@"address1"];
            }
            
            
            if([managedAddress[indexPath.row][@"tag_address"]length] > 0)
            {
                cell.detailTextLabel.text = managedAddress[indexPath.row][@"tag_address"];
                height2 = [self measureHeightLabel:cell.detailTextLabel];
            }
            else
            {
                cell.detailTextLabel.text = @"";
                height2 = 0;
            }
            
            return 35+10;
            
        }
        else//For Previously Selected Address
        {
            NSDictionary *searchResult = [previouslySelectedAddress objectAtIndex:indexPath.row];
            cell.textLabel.text = searchResult[@"add1"];
            cell.detailTextLabel.text = searchResult[@"add2"];
            
            height2 = [self measureHeightLabel:cell.detailTextLabel];
        }
        
        
    }
    else//For Currently Searched Address
    {
        GMSAutocompletePrediction *searchResult = (GMSAutocompletePrediction *)[self.mAddress objectAtIndex:indexPath.row];
        cell.textLabel.text = searchResult.attributedPrimaryText.string;
        cell.detailTextLabel.text = searchResult.attributedSecondaryText.string;
        height2 = [self measureHeightLabel:cell.detailTextLabel];
    }
    
    height1 = [self measureHeightLabel:cell.textLabel];
    
    return height1+height2+10;
}

- (CGFloat)measureHeightLabel: (UILabel *)label
{
    CGSize constrainedSize = CGSizeMake(self.view.frame.size.width-30  , 9999);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:label.font.fontName size:label.font.pointSize], NSFontAttributeName,
                                          nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:label.text attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    CGRect newFrame = label.frame;
    newFrame.size.height = requiredHeight.size.height;
    return  newFrame.size.height;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(tableView.frame), 25)];
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, CGRectGetWidth(tableView.frame)-20, 20)];
//
//    [headerView addSubview:titleLabel];
//
//    NSString *title;
//
//    if(isManageAddressAvailable)
//    {
//        title = @"Searched Addresses";
//    }
//    else if (self.mAddress.count == 0)
//    {
//        title = @"No Searched Address";
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    else
//    {
//        title = @"Result";
//    }
//
//    titleLabel.text = title;
//
//    titleLabel.font = [UIFont fontWithName:OpenSans_SemiBold size:13];
//    titleLabel.textColor = UIColorFromRGB(0x333333);
//
//    return headerView;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    //    if (section == 0) {
    //        return 25;
    //    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.searchBarController.text.length == 0 && indexPath.section == 0)
    {
        NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:managedAddress[indexPath.row]];
        //        NSDictionary *dict = @{
        //                               @"address1":flStrForStr(self.mAddress[indexPath.row][@"address1"]),
        //                               @"address2":@"",
        //                               @"lat":flStrForStr(self.mAddress[indexPath.row][@"lat"]),
        //                               @"lng":flStrForStr(self.mAddress[indexPath.row][@"long"]),
        //                             };
        
        if (self.pickUpAddressDelegate && [self.pickUpAddressDelegate respondsToSelector:@selector(getAddressFromPickUpAddressVC:)]) {
            [self.pickUpAddressDelegate getAddressFromPickUpAddressVC:dict];
        }
        
        [self navigationBackButtonAction:nil];
    }
    else
    {
        
        NSString *placeID;
        if(self.searchBarController.text.length == 0 && indexPath.section == 1)
        {
            //For Previously Selected Address
            NSDictionary *searchResult;
            searchResult = [previouslySelectedAddress objectAtIndex:indexPath.row];
            placeID =  searchResult[@"placeId"];
            
        }
        else
        {
            //For New Address
            GMSAutocompletePrediction *searchResult;
            searchResult = [self.mAddress objectAtIndex:indexPath.row];
            placeID = searchResult.placeID;
            
            //Checking Previously Any Address is Added in Database
            if(previouslySelectedAddress.count > 0)
            {
                //Checking This Address Details Already There in Database
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"placeId = %@",placeID];
                NSArray *results = [previouslySelectedAddress filteredArrayUsingPredicate:predicate];
                
                if(results.count == 0)
                {
                   // [[Database sharedInstance]makeDataBaseEntryForAddress:[self.mAddress objectAtIndex:indexPath.row]];
                }
                
            }
            else
            {
                //Adding This Address Details To Database
              //  [[Database sharedInstance]makeDataBaseEntryForAddress:[self.mAddress objectAtIndex:indexPath.row]];
            }

            
        }
        
        [self.searchBarController resignFirstResponder];
       // [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
        [self getPlaceInformation:placeID];
        
        
    }
    
    
}

-(void)getPlaceInformation:(NSString *)placeId
{
   /* [self retrieveJSONDetailsAbout:placeId
                    withCompletion:^(NSArray *place) {
                        
                        if (self.pickUpAddressDelegate && [self.pickUpAddressDelegate respondsToSelector:@selector(getAddressFromPickUpAddressVC:)])
                        {
                            
                            NSDictionary *dict = [NSDictionary dictionary];
                            
                            NSString *add1 = [NSString stringWithFormat:@"%@",[place valueForKey:@"name"]];
                            NSString *add2 = [NSString stringWithFormat:@"%@",[place valueForKey:@"formatted_address"]];
                            if (add1.length == 0) {
                                
                                add1 = [add1 stringByAppendingString:[place valueForKey:@"formatted_address"]];
                                add2 = @"";
                            }
                            
                            NSString *late = [NSString stringWithFormat:@"%@,",[place valueForKey:@"geometry"][@"location"][@"lat"]];
                            NSString *longi = [NSString stringWithFormat:@"%@",[place valueForKey:@"geometry"][@"location"][@"lng"]];
                            
                            dict = @{
                                     @"address1":add1,
                                     @"address2":add2,
                                     @"lat":late,
                                     @"long":longi,
                                     };
                            
                            
                            
                            [self.pickUpAddressDelegate getAddressFromPickUpAddressVC:dict];
                        }
                        
                        [self navigationBackButtonAction:nil];
                        
                    }];*/
    
    [placesClient lookUpPlaceID:placeId
                       callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
                           
                           if (self.pickUpAddressDelegate && [self.pickUpAddressDelegate respondsToSelector:@selector(getAddressFromPickUpAddressVC:)])
                           {
                               
                               if (error != nil) {
                                   NSLog(@"Place Details error %@", [error localizedDescription]);
                                   return;
                               }
                               
                               if (result != nil) {
                                   
                                   NSLog(@"Place name %@", result.name);
                                   NSLog(@"Place address %@", result.formattedAddress);
                                   NSLog(@"Place placeID %@", result.placeID);
                                   NSLog(@"Place attributions %@", result.attributions);
                                   
                                   NSDictionary *dict = [NSDictionary dictionary];
                                   
                                   NSString *add = [NSString stringWithFormat:@"%@",result.formattedAddress];
                                   
                                   CLLocationCoordinate2D location = result.coordinate;
                                   
                                   NSString *lat = [NSString stringWithFormat:@"%f,",location.latitude];
                                   NSString *lon = [NSString stringWithFormat:@"%f,",location.longitude];

   
                                   dict = @{
                                           @"address":add,
                                           @"lat":lat,
                                           @"lon":lon,
                                          };
   
                                  
                                  
                                  [self.pickUpAddressDelegate getAddressFromPickUpAddressVC:dict];

                                   
                               } else {
                                   NSLog(@"No place details for %@", placeId);
                               }
                        
                            }
                           
                           [self navigationBackButtonAction:nil];
    
                           
                       }];
    

}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *title;
//
//    if(isManageAddressAvailable)
//    {
//        title = @"Searched Addresses";
//        [self.tblView headerViewForSection:0].textLabel.textAlignment = NSTextAlignmentLeft;
//    }
//    else if (self.mAddress.count == 0)
//    {
//        title = @"No Searched Address";
//        [self.tblView headerViewForSection:0].textLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    else
//    {
//        title = @"Result";
//        [self.tblView headerViewForSection:0].textLabel.textAlignment = NSTextAlignmentLeft;
//    }
//
//    [self.tblView headerViewForSection:0].textLabel.font = [UIFont fontWithName:OpenSans_SemiBold size:13];
//    [self.tblView headerViewForSection:0].textLabel.textColor = UIColorFromRGB(0x333333);
//
//    return title;
//}



#pragma mark - Search Bar Delegates -
#pragma mark  Autocomplete SearchBar methods -

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.autoCompleteTimer invalidate];
    [self searchAutocompleteLocationsWithSubstring:self.substring];
    [self.searchBarController resignFirstResponder];
    [self.tblView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSString *searchWordProtection = [self.searchBarController.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (searchWordProtection.length > 0) {
        
        [self runScript];
        
    } else {
        
      //  [self loadsManageAndPreviouslySelectedAddress];
        //        [[ProgressIndicator sharedInstance]hideProgressIndicator];
    }
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    self.substring = [NSString stringWithString:self.searchBarController.text];
    self.substring= [self.substring stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    self.substring = [self.substring stringByReplacingCharactersInRange:range withString:text];
    
    if ([self.substring hasPrefix:@"+"] && self.substring.length >1) {
        self.substring  = [self.substring substringFromIndex:1];
    }
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //    [searchBar setShowsCancelButton:YES animated:YES];
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    //    [self.view endEditing:YES];
}

- (void)runScript{
    
    [self.autoCompleteTimer invalidate];
    self.autoCompleteTimer = [NSTimer scheduledTimerWithTimeInterval:0.15f
                                                              target:self
                                                            selector:@selector(searchAutocompleteLocationsWithSubstring:)
                                                            userInfo:nil
                                                             repeats:NO];
}

- (void)searchAutocompleteLocationsWithSubstring:(NSString *)substring
{
    //    isManageAddressAvailable = NO;
    
    
    //
    
    if (![self.pastSearchWords containsObject:self.substring]) {
        
        //        [[ProgressIndicator sharedInstance] showPIOnView:[[UIApplication sharedApplication] keyWindow]
        //                                                     withMessage:@"Loading..."];
        
        [self.mAddress removeAllObjects];
        [self.tblView reloadData];
        
        [self.pastSearchWords addObject:self.substring];
        [self autoCompleteUsingGMS:self.substring
                              withCompletion:^(NSArray * results) {
                                  
                                  if(results)//GOT RESULTS
                                  {
                                      //                                [[ProgressIndicator sharedInstance]hideProgressIndicator];
                                      [self.mAddress addObjectsFromArray:results];
                                      //                                  isSearchResultCome = YES;
                                      NSDictionary *searchResult = @{@"keyword":self.substring,@"results":results};
                                      [self.pastSearchResults addObject:searchResult];
                                      [self.tblView reloadData];
                                  }
                                  else
                                  {
                                      
                                  }
                                  
                              }];
        
    }else if([self.pastSearchWords containsObject:self.substring]) {
        
        [self.mAddress removeAllObjects];
        for (NSDictionary *pastResult in self.pastSearchResults) {
            if([[pastResult objectForKey:@"keyword"] isEqualToString:self.substring]){
                [self.mAddress addObjectsFromArray:[pastResult objectForKey:@"results"]];
                [self.tblView reloadData];
            }
        }
    }
    else
    {
      //  [self loadsManageAndPreviouslySelectedAddress];
    }
}


#pragma mark - Google API Requests -


-(void)retrieveGooglePlaceInformation:(NSString *)searchWord
                       withCompletion:(void (^)(NSArray *))complete {
    
    
    NSString *searchWordProtection = [searchWord stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (searchWordProtection.length != 0) {
        
        NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment|geocode&location=%@,%@&radius=500po &language=en&key=%@",searchWord,latitude,longitude,googleKeyAPIkey];
        
        NSLog(@"AutoComplete URL: %@",urlString);
        
        
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLSession *delegateFreeSession;
        delegateFreeSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                            delegate:nil
                                                       delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *task;
        task = [delegateFreeSession dataTaskWithRequest:request
                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                          
                                          
                                          if (!data || !response || error) {
                                              NSLog(@"Google Service Error : %@",[error localizedDescription]);
                                              return;
                                          }
                                          
                                          NSDictionary *jSONresult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                          NSArray *results = [jSONresult valueForKey:@"predictions"];
                                          
                                          if (error || [jSONresult[@"status"] isEqualToString:@"NOT_FOUND"] || [jSONresult[@"status"] isEqualToString:@"REQUEST_DENIED"]) {
                                              
                                              complete(nil);
                                          }
                                          else
                                          {
                                              complete(results);
                                          }
                                      }];
        [task resume];
    }
    
}

-(void)autoCompleteUsingGMS:(NSString *)searchWord
             withCompletion:(void (^)(NSArray *))complete
{
    [NSObject cancelPreviousPerformRequestsWithTarget:placesClient selector:@selector(autocompleteQuery:bounds:filter:callback:) object:self];
    
    if(searchWord.length>0)
    {
        GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
        filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
        
    
        GMSVisibleRegion visibleRegion;
        visibleRegion.farLeft = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
        visibleRegion.farRight = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
        visibleRegion.nearLeft = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
        visibleRegion.nearRight = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
        
    
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc]initWithCoordinate:visibleRegion.farLeft coordinate: visibleRegion.nearRight];

        
        [placesClient autocompleteQuery:searchWord
                                  bounds:bounds
                                  filter:filter
                                callback:^(NSArray *results, NSError *error) {
                                    if (error != nil) {
                                        NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                        complete(nil);
                                        return;
                                    }
                                    if(results.count >0 ){
                                        
                                        complete(results);
                                    }else{
                                        complete(nil);
                                    }
                                }];
    }else{
        complete(nil);
    }

}

-(void)retrieveJSONDetailsAbout:(NSString *)place withCompletion:(void (^)(NSArray *))complete {
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",place,googleKeyAPIkey];
    
    NSURL *url = [NSURL URLWithString:urlString];// stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [delegateFreeSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jSONresult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *results = [jSONresult valueForKey:@"result"];
        
        if (error || [jSONresult[@"status"] isEqualToString:@"NOT_FOUND"] || [jSONresult[@"status"] isEqualToString:@"REQUEST_DENIED"]){
            if (!error){
                NSDictionary *userInfo = @{@"error":jSONresult[@"status"]};
                NSError *newError = [NSError errorWithDomain:@"API Error" code:666 userInfo:userInfo];
                complete(@[@"API Error", newError]);
                return;
            }
            complete(@[@"Actual Error", error]);
            return;
        }else{
            complete(results);
        }
    }];
    
    [task resume];
}

@end
