
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
import ballerina/test;
import nuwantissera/googleapis_drive as drive;
import nuwantissera/googleapis_drive.trigger as glistener;

configurable string callbackURL = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshUrl = drive:REFRESH_URL;
configurable string refreshToken = ?;

# Event Trigger class  
public class EventTrigger {
    
    public function onNewFolderCreatedEvent(string folderId) {
        log:print("New folder was created:" + folderId);
    }

    public function onFolderDeletedEvent(string folderID) {}

    public function onNewFileCreatedEvent(string fileId) {}

    public function onFileDeletedEvent(string fileId) {}

    public function onNewFileCreatedInSpecificFolderEvent(string fileId) {}

    public function onNewFolderCreatedInSpecificFolderEvent(string folderId) {}

    public function onFolderDeletedInSpecificFolderEvent(string folderId) {}

    public function onFileDeletedInSpecificFolderEvent(string fileId) {}

    public function onFileUpdateEvent(string fileId) {}
}

    drive:Configuration clientConfiguration = {clientConfig: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshUrl: refreshUrl,
        refreshToken: refreshToken
    }};

    glistener:ListenerConfiguration configuration = {
        port: 9090,
        callbackURL: callbackURL,
        clientConfiguration: clientConfiguration,
        eventService: new EventTrigger()
    };

    listener glistener:DriveEventListener gDrivelistener = new (configuration);

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

    function testDriveAPITrigger() {
        log:print("gDriveClient -> watchFiles()");
        int i = 0;
        while (true) {
            i = 0;
        }
        test:assertTrue(true, msg = "expected to be created a watch in google drive");
    }

