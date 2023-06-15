# SmartCam Flutter based Mobile app



This repo contains Mobile app SmartCam product

## Table of Contents
* Installation Instructions
* Usage Instructions
* Troubleshooting


## Installation Instructions
- Install the latest stable version of Flutter. [LINK](https://docs.flutter.dev/get-started/install)
- Complete at least one of the platform (Android or iOS) setup steps, to be able to build and run app on respective platform . [Windows ANDROID SETUP](https://docs.flutter.dev/get-started/install/windows#android-setup) [MacOS ANDROID SETUP](https://docs.flutter.dev/get-started/install/macos#android-setup) [MacOS iOS SETUP](https://docs.flutter.dev/get-started/install/macos#ios-setup)


## Usage Instructions
- Create a  `env.dart` file inside the lib directory.
~~~
    const BASEURL = '<BASEURL-OF-THE-BACKEND-SERVER>';
    const CDN_BASEURL = '<BASEURL-OF-THE-CDN>';
~~~
- Now configure Amplify CLI [Setup Amplify CLI](https://docs.amplify.aws/cli/start/install/#install-the-amplify-cli)
- After the CLI is setup, call `amplify pull` in the project directory
    - select `ap-south-1` region
    - select `scdashboard` as project
    - select `flutter` as the type of app you are building
    - press enter when asked for storing address of config file
- Now you will able to run the application using `flutter run -d <device_id>` (`flutter devices` to get ids of all connected devices)

###### To Setup Notifications
- (Skip this step if you want to use a existing project) Go to [Firebase](https://firebase.google.com/) to create a new firebase project.
- Follow till Step 2 of [instructions](https://firebase.google.com/docs/flutter/setup?platform=android) to configure firebase cli and flutterfire cli as per your project.
- Now you will be able to send notification to the topic `exwzd` from the firebase fcm console. Notifications will only be received if the user is logged in to the app.

###### Server setup to send notifications (for poc-exaindia-xiss-ui_cloud feature/notification branch)
- Login to your firebase console
- Open your project
- Go to Project Setting>Service Accounts>Firebase Admin SDK>Generate new private key
- Rename the downloaded .json file to `firebaseServiceAccountKey.json`, place the file in the root of the fastapi server and run the server.
- Now, for every raise_alert api call, a firebase notification will be sent to all the devices subscribed to 'exwzd' topic.

## Troubleshooting


