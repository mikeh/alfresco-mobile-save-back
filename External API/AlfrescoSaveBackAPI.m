/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is the Alfresco Mobile App.
 *
 *
 * ***** END LICENSE BLOCK ***** */
//
//  AlfrescoSaveBackAPI.m
//

#import "AlfrescoSaveBackAPI.h"

NSString * const AlfrescoBundleIdentifier = @"com.alfresco.mobile";
NSString * const AlfrescoSaveBackMetadataKey = @"AlfrescoMetadata";
NSString * const AlfrescoSaveBackDocumentExtension = @".alf01";

/**
 * Save Back to Alfresco helper function.
 *
 * We need to copy (move/rename would also be ok depending on the application) the current file
 * to one with the AlfrescoSaveBackDocumentExtension
 */
NSURL *alfrescoSaveBackURLForFilePath(NSString *filePath, NSError **error)
{
    NSString *tempFilename = [NSTemporaryDirectory() stringByAppendingPathComponent:filePath.pathComponents.lastObject];
    NSString *tempSaveBackPath = [tempFilename stringByAppendingString:AlfrescoSaveBackDocumentExtension];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:tempSaveBackPath])
    {
        [fileManager removeItemAtPath:tempSaveBackPath error:error];
    }
    [fileManager copyItemAtPath:filePath toPath:tempSaveBackPath error:error];

    return [NSURL fileURLWithPath:tempSaveBackPath];
}

/**
 * Alfresco SaveBack integration
 *
 * (Optional) Removes the temporary file created as part of the SaveBack preparation.
 * A suitable place to call this function is the UIDocumentInteractionControllerDelegate method
 * documentInteractionController:didEndSendingToApplication:
 */
void alfrescoSaveBackRemoveTemporaryFileAtURL(NSURL *fileURL)
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[fileURL path]])
    {
        [fileManager removeItemAtURL:fileURL error:NULL];
    }
}
