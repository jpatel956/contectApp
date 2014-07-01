//
//  insertItemViewController.h
//  Testing
//
//  Created by ind360 on 7/1/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface insertItemViewController : UIViewController<UIImagePickerControllerDelegate>
{
   __weak IBOutlet UIBarButtonItem* btnCancel;
    __weak IBOutlet UIBarButtonItem* btnSave;
    __weak IBOutlet UIButton* btnPhoto;
    __weak IBOutlet UITextField* txtFirstName;
    __weak IBOutlet UITextField* txtLastName;
    NSString* filename;
}
@property (nonatomic,strong)NSMutableDictionary* dictStorePriviousRecord;
-(IBAction)btnAddPhotoClick:(id)sender;
-(IBAction)btnCancelClick:(id)sender;
-(IBAction)btnSaveClick:(id)sender;
@end
