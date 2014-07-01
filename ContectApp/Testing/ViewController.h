//
//  ViewController.h
//  Testing
//
//  Created by ind360 on 7/1/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    __weak IBOutlet UITableView* tblShowContent;
    NSMutableArray* arrayAllRecord;
    __weak IBOutlet UITextField* txtSearchResult;
}
@property (nonatomic,strong) NSMutableArray* arrayDisplayRecord;
-(IBAction)btnAddClick:(id)sender;
@end
