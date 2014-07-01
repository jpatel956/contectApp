//
//  ViewController.m
//  Testing
//
//  Created by ind360 on 7/1/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "ViewController.h"
#import "insertItemViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize arrayDisplayRecord;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    tblShowContent.allowsMultipleSelectionDuringEditing = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
   arrayAllRecord = [[Databasefile shareDatabase]SelectAllFromTable:@"select * from records"];
    
    self.arrayDisplayRecord = [NSMutableArray arrayWithArray:arrayAllRecord];
    [tblShowContent reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark +++++++++++++++++++ Custom Methods ++++++++++++++++++++++
-(IBAction)btnAddClick:(id)sender{
    
//    [self performSegueWithIdentifier:@"additems" sender:nil];
    
    UIStoryboard * objStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    
    insertItemViewController* objInsert = [objStoryBoard instantiateViewControllerWithIdentifier:@"insertItems"];
    objInsert.dictStorePriviousRecord=nil;
    UINavigationController* objNavigationController = [[UINavigationController alloc] initWithRootViewController:objInsert];
    
    [self presentViewController:objNavigationController animated:YES completion:nil];
    
    
}
#pragma mark ++++++++++++ UItableView delegate ++++++++++++++++++++++
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayDisplayRecord count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellreuse"];
    
    UIImageView* imgPhoto = (UIImageView*)[cell.contentView viewWithTag:10];
    
    
    NSString* fileUrl = [[arrayDisplayRecord objectAtIndex:indexPath.row] valueForKey:@"imagename"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask ,YES );
    
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString* fileName =[NSString stringWithFormat:@"%@",fileUrl];
    
    NSString *savedImagePath = [documentsDir stringByAppendingPathComponent:fileName];
    imgPhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:savedImagePath]];
    
    UILabel* lblfirstName = (UILabel*)[cell.contentView viewWithTag:11];
    lblfirstName.text = [[arrayDisplayRecord objectAtIndex:indexPath.row] valueForKey:@"firstname"];
    
    UILabel* lbllastName = (UILabel*)[cell.contentView viewWithTag:12];
    lbllastName.text = [[arrayDisplayRecord objectAtIndex:indexPath.row] valueForKey:@"lastname"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard * objStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    
    insertItemViewController* objInsert = [objStoryBoard instantiateViewControllerWithIdentifier:@"insertItems"];
    objInsert.dictStorePriviousRecord=[self.arrayDisplayRecord objectAtIndex:indexPath.row];
    UINavigationController* objNavigationController = [[UINavigationController alloc] initWithRootViewController:objInsert];
    
    [self presentViewController:objNavigationController animated:YES completion:nil];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self.arrayDisplayRecord removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        NSString* aredelete = [NSString stringWithFormat:@"Delete from records where id='%@'",[[self.arrayDisplayRecord objectAtIndex:indexPath.row] valueForKey:@"id"]];
        [[Databasefile shareDatabase]Delete:aredelete];
        
    }
}
#pragma mark +++++++++++++++++++ text fild delegate methods ++++++++++++++++++++++++++++
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(searchTextFromArray) userInfo:nil repeats:NO];
    
    return YES;
    
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)searchTextFromArray{
    
    [self.arrayDisplayRecord removeAllObjects];
    if ([txtSearchResult.text length]==0){
        
        self.arrayDisplayRecord = [NSMutableArray arrayWithArray:arrayAllRecord];
    }
    else{
        txtSearchResult.text = [txtSearchResult.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSArray *filteredarray = [arrayAllRecord filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(firstname contains[cd] %@  OR lastname contains[cd] %@)", txtSearchResult.text,txtSearchResult.text]];
    
        self.arrayDisplayRecord = [NSMutableArray arrayWithArray:filteredarray];
    }
   
    [tblShowContent reloadData];
    
}
@end
