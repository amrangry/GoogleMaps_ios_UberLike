//
//  HistoryViewController.m
//  GoogleMapApp
//
//  Created by Amr Elghadban on 5/21/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import "HistoryViewController.h"
#import "RouteDetailsViewController.h"
#import "DbHandler.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.mAddress = [NSMutableArray array];
    
     [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillAppear:(BOOL)animated{

    DbHandler *db=[DbHandler sharedInstance];
    NSArray *   items =[db getItems];
    
    self.mAddress = [NSMutableArray arrayWithArray:items];
    
    
    [self.tblView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return self.mAddress.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
     AppointmentLocation * addressObj= [self.mAddress objectAtIndex:indexPath.row];
    
    RouteDetailsViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"RouteDetailsViewController"];
    
    vc.appointmentLocaion = addressObj;
    
    [self.navigationController pushViewController:vc animated:YES];


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
        cell.imageView.image=[UIImage imageNamed:@"back_btn_off_ar"];
        
    }
    
    AppointmentLocation * addressObj= [self.mAddress objectAtIndex:indexPath.row];
    cell.textLabel.text =  addressObj.pickUpAddress;
     cell.detailTextLabel.text =[NSString stringWithFormat:@"Lat: %@ / Lon: %@",addressObj.dropOffLatitude,addressObj.dropOffLongitude];
    
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
    
    AppointmentLocation * addressObj= [self.mAddress objectAtIndex:indexPath.row];
    cell.textLabel.text =  addressObj.pickUpAddress;
    cell.detailTextLabel.text =[NSString stringWithFormat:@"Lat: %@ / Lon: %@",addressObj.dropOffLatitude,addressObj.dropOffLongitude];
    
    height1 = [self measureHeightLabel:cell.textLabel];
    height2 = [self measureHeightLabel:cell.detailTextLabel];
    
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

@end
