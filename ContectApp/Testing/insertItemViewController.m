//
//  insertItemViewController.m
//  Testing
//
//  Created by ind360 on 7/1/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "insertItemViewController.h"

@implementation insertItemViewController
@synthesize dictStorePriviousRecord;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Add Data";
    self.navigationItem.leftBarButtonItem = btnCancel;
    self.navigationItem.rightBarButtonItem = btnSave;
    
    btnPhoto.layer.cornerRadius=50;
    btnPhoto.layer.borderColor = [UIColor grayColor].CGColor;
    btnPhoto.layer.borderWidth=1;
    btnPhoto.clipsToBounds=YES;
    
    if (self.dictStorePriviousRecord!=nil) {
        
        txtFirstName.text = [self.dictStorePriviousRecord valueForKey:@"firstname"];
         txtLastName.text = [self.dictStorePriviousRecord valueForKey:@"lastname"];
        
        NSString* fileUrl = [self.dictStorePriviousRecord valueForKey:@"imagename"];
        filename = fileUrl;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask ,YES );
        
        NSString *documentsDir = [paths objectAtIndex:0];
        NSString* fileName =[NSString stringWithFormat:@"%@",fileUrl];
        
        NSString *savedImagePath = [documentsDir stringByAppendingPathComponent:fileName];
        
        [btnPhoto setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:savedImagePath]] forState:UIControlStateNormal];
        [btnPhoto setTitle:@"" forState:UIControlStateNormal];
    }
    else{
        [btnPhoto setBackgroundImage:nil forState:UIControlStateNormal];
        [btnPhoto setTitle:@"Add" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ++++++++++++++++++++++ Custom Methods +++++++++++++++++++++++++++
-(IBAction)btnAddPhotoClick:(id)sender{
    

    UIActionSheet* objActionSheet = [[UIActionSheet alloc]initWithTitle:@"Photo" delegate:(id)self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Picture",@"Picture from Library", nil];
    [objActionSheet showInView:self.view];
}
-(IBAction)btnCancelClick:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)btnSaveClick:(id)sender{
    
    txtFirstName.text = [txtFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    txtLastName.text = [txtLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([txtFirstName.text length] == 0 || [txtLastName.text length] == 0 || [filename length] == 0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"All field are mandetory." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        
        if (self.dictStorePriviousRecord==nil) {
            NSString* insertQuery = [NSString stringWithFormat:@"insert into records(firstname,lastname,imagename) values('%@','%@','%@')",txtFirstName.text,txtLastName.text,filename];
            [[Databasefile shareDatabase]Insert:insertQuery];
        }
        else{
            NSString* updateQuery = [NSString stringWithFormat:@"UPDATE records set firstname='%@', lastname='%@', imagename='%@' where id='%@'",txtFirstName.text,txtLastName.text,filename,[self.dictStorePriviousRecord valueForKey:@"id"]];
            [[Databasefile shareDatabase]Update:updateQuery];
        }
        
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark +++++++++++++++ Action Sheet Delegate Event +++++++++++++++++
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"Tag : %d",buttonIndex);
    if (buttonIndex==0) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [myAlertView show];
        }
        else{
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            
            imagePicker.delegate = (id)self;
            
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypeCamera;
            
            imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
            
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker
                               animated:YES completion:nil];
        }
        
    }
    else if(buttonIndex==1){
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = (id)self;
        
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
    }
}

#pragma mark ++++++++++++++++++ Picker Delegate Methods ++++++++++
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
     NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
     UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    
    [btnPhoto setBackgroundImage:chosenImage forState:UIControlStateNormal];
    [btnPhoto setTitle:@"" forState:UIControlStateNormal];

    
     NSString* fileContent=@"";
     filename =@"";
    if ([type isEqualToString:(NSString *)kUTTypeImage]){
        
        fileContent = @"Image";
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask ,YES );
        NSString *documentsDir = [paths objectAtIndex:0];
        filename =[NSString stringWithFormat:@"%@.png",[[appDelegate.dateFormater stringFromDate:[NSDate date]] stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
        
        NSString *savedImagePath = [documentsDir stringByAppendingPathComponent:filename];
        
        NSData *imageData = UIImageJPEGRepresentation(chosenImage, 1.0);
        
        [imageData writeToFile:savedImagePath atomically:YES];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
