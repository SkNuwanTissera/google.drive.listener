// // Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
// //
// // WSO2 Inc. licenses this file to you under the Apache License,
// // Version 2.0 (the "License"); you may not use this file except
// // in compliance with the License.
// // You may obtain a copy of the License at
// //
// // http://www.apache.org/licenses/LICENSE-2.0
// //
// // Unless required by applicable law or agreed to in writing,
// // software distributed under the License is distributed on an
// // "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// // KIND, either express or implied.  See the License for the
// // specific language governing permissions and limitations
// // under the License.

// import ballerina/http;
// import ballerina/log;
// import nuwantissera/googleapis_drive as drive;
// import nuwantissera/googleapis_drive.'listener as listen;

// configurable string callbackURL = ?;
// configurable string clientId = ?;
// configurable string clientSecret = ?;
// configurable string refreshUrl = drive:REFRESH_URL;
// configurable string refreshToken = ?;

// string parentFolderId = "1BRhpyHgr26pSYq1cgOVfAYI-N37ZcYsF";
// string folderName = "<NEW_FOLDER_NAME>";

// # Event Trigger class  
// public class EventTrigger {
    
//     public function onNewFolderCreatedEvent(string folderId) {
//         log:print("New folder was created:" + folderId);
//     }

//     public function onFolderDeletedEvent(string folderID) {}

//     public function onNewFileCreatedEvent(string fileId) {}

//     public function onFileDeletedEvent(string fileId) {}

//     public function onNewFileCreatedInSpecificFolderEvent(string fileId) {}

//     public function onNewFolderCreatedInSpecificFolderEvent(string folderId) {}

//     public function onFolderDeletedInSpecificFolderEvent(string folderId) {}

//     public function onFileDeletedInSpecificFolderEvent(string fileId) {}

//     public function onFileUpdateEvent(string fileId) {}
// }

//     drive:Configuration config = {
//         clientConfig: {
//             clientId: clientId,
//             clientSecret: clientSecret,
//             refreshUrl: refreshUrl,
//             refreshToken: refreshToken
//         }
//     };

//     listen:ListenerConfiguration configuration = {
//         port: 9090,
//         callbackURL: callbackURL,
//         clientConfiguration: config,
//         eventService: new EventTrigger(),
//         specificFolderOrFileId : parentFolderId
//     };

//     listener listen:DriveEventListener gDrivelistener = new (configuration);

//     service / on gDrivelistener {
//         resource function post gsheet(http:Caller caller, http:Request request) returns string|error? {
//             error? procesOutput = gDrivelistener.findEventType(caller, request);
//             http:Response response = new;
//             var result = caller->respond(response);
//             if (result is error) {
//                 log:printError("Error in responding ", err = result);
//             }
//         }
//     }

// public function main() returns error? {
//     drive:Client driveClient = check new (config);
//     drive:File|error response = driveClient->createFolder(folderName, parentFolderId);
// }