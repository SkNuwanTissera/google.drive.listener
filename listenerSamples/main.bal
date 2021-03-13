// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/log;
import nuwantissera/googleapis_drive as drive;
import nuwantissera/googleapis_drive.'listener as listen;

configurable string callbackURL = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshUrl = drive:REFRESH_URL;
configurable string refreshToken = ?;

string parentFolderId = "1IOpfSe4BuxBTzh0EbByQHIWqDkmbEWDW";
string folderId = "<FOLDER_ID_TO_BE_DELETED>";
string folderName = "<FOLDER_ID_TO_BE_DELETED>";

# Event Trigger class  
public class EventTrigger {
    
    public function onNewFolderCreatedEvent(string folderId) {
        log:print("New folder was created:" + folderId);
    }

    public function onFolderDeletedEvent(string folderID) {
        log:print("This folder was removed to the trashed:" + folderID);
    }

    public function onNewFileCreatedEvent(string fileId) {
        log:print("New File was created:" + fileId);
    }

    public function onFileDeletedEvent(string fileId) {
        log:print("This File was removed to the trashed:" + fileId);
    }

    public function onNewFileCreatedInSpecificFolderEvent(string fileId) {
        log:print("A file with Id " + fileId + "was created in side the folder specified");
    }

    public function onNewFolderCreatedInSpecificFolderEvent(string folderId) {
        log:print("A folder with Id " + folderId + "was created in side the folder specified");
    }

    public function onFolderDeletedInSpecificFolderEvent(string folderId) {
        log:print("A folder with Id " + folderId + "was deleted in side the folder specified");
    }

    public function onFileDeletedInSpecificFolderEvent(string fileId) {
        log:print("A file with Id " + fileId + "was deleted in side the folder specified");
    }
    public function onFileUpdateEvent(string fileId) {
        log:print("File updated : " + fileId);
    }
}

    drive:Configuration config = {
        clientConfig: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshUrl: refreshUrl,
            refreshToken: refreshToken
        }
    };

    listen:ListenerConfiguration configuration = {
        port: 9090,
        callbackURL: callbackURL,
        clientConfiguration: config,
        eventService: new EventTrigger(),
        specificFolderOrFileId : parentFolderId
    };

    listener listen:DriveEventListener gDrivelistener = new (configuration);

    service / on gDrivelistener {
        resource function post gsheet(http:Caller caller, http:Request request) returns string|error? {
            error? procesOutput = gDrivelistener.findEventType(caller, request);
            http:Response response = new;
            var result = caller->respond(response);
            if (result is error) {
                log:printError("Error in responding ", err = result);
            }
        }
    }

public function main() returns error? {
    drive:Client driveClient = check new (config);
    // drive:File|error response = driveClient->createFolder("ListnerTest_1");
    drive:File|error response = driveClient->createFile("ListnerTest_1", drive:DOCUMENT, parentFolderId);
    if (response is drive:File) {
        log:print(response.toString());
    }
}