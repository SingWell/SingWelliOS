# SingWelliOS

## ApiHelper

We used AlamoFire and SwiftyJson to interface with the backend (AWS). The four basic calls that you can make are: GET, POST, PUT and PATCH. Most edit calls are made through the PATCH call, and POST and PUT are not in use at this time. There are several other calls to be aware of. 

The makeFileCall is used to pull down files from the backend. This is used for both the pdfs and the mxl files. The upload image function is at this moment only used to upload new profile pictures to the backend, and the getProfilePictures is used to pull profile pictures. This end point can also be used to pull down any other pictures (such as choir pictures) with some modification.

Take some time to look through this file to understand the functionality.

To call any function on this page use the following format:

```
ApiHelper.functionCall(parameters) { response, error in
            
            if error == nil {
                ...
            } else {
                print("Error getting events: ",error as Any)
            }
        }
```

## IBAnimatable and Font

We tried to make everything part of the “Animatable” classes so we have more control over display characteristics in the storyboards and animations. It is not necessary for everything, but it will help you out in general.

We use a specified font that is set through code. The idea is to be able to programmatically change the font throughout the entire application.

## Extensions.swift

This file is used for many different class extensions that may be used throughout the application. The storyboard control is probably the most notable feature in this file. Other things include the ability for an empty message in a table view, order date strings, and color helpers.

## Using Storyboards and View Controllers

When you want to create a new view controller to use in a storyboard, create the view controller file as you normally would, then create a new storyboard file. In this new storyboard file, add a view controller and assign it to the class of your new view controller. Then make that view controller the initial view controller of that storyboard. Then go into the “Extensions.swift” file in the “Resources” folder to add the storyboard name (without the extension) to the case line in the AppStoryboard enum.

When you want to transition to that view controller, you must execute the transitions in code. 

```
let nextVc = AppStoryboard.Register.initialViewController() as! RegisterViewController
self.present(nextVc, animated: true)
```

## SideMenu

The SideMenu storyboard is used to format how the sidemenu looks. 

The HostViewController determines which controller identifiers (Storyboard identifiers found in the AppStoryboard enum) can be used. This is also the file that selects the first view controller after login.

The NavigationMenuViewController determines the order of the cells in the side menu. There used to be a “hack” used to display everything correctly due to a status bar issue. Hopefully this hack is not needed anymore (we found that after adding the login view controller there were no issues).

## PracticeViewController

This file uses the SeeScoreLib library to display and listen to MXL or XML files as sheet music. Most of the variables used throughout the file are instantiated at the top of the class. Take some time to go through this file if needed to figure out how it all works. The updateSettings delegate function updates certain variables after the practice settings are changed. (To implement the ability to have certain volume differences for specified parts, the class variable for the specified volumes would be set here and implemented when playing sound from the “synth”. Look at “partsToDisplay” to figure this out)

There are a bunch of delegate functions that are pretty much left as default for now because the sheet music worked. The license to use this library will need to be updated for a fully functional app.

To make it work, you must put the SeeScoreLib executable file in the directory as shown in the image below.
￼
This file was too big to put on the repo directly, so you can either get this file from the SeeScoreLib website or uncompress the zip file and include it here.

## PracticeSettingsViewController

This VC is used to update various variables to be updated in the PracticeViewController. There are delegate methods to update the PracticeViewController variables when done here.

## ChoirViewController

This page displays choir information in table format. The first cell shows all the basic choir and organization information. The next cells show upcoming events and past events (limit 3). The functions for determining whether events are past or future is determined in a JSON extension in the “Extensions.swift” file.

In the future, this should be the landing page. First, the data needs to be pulled from the server for the user’s choir involvement, then the first choir needs to be selected.

## CalendarViewController

This shows past and upcoming events in calendar format using the JTAppleCalendar library. In the storyboard, you can change how the CalendarCell looks and the EventCell

## MusicLibraryViewController

This file pulls the music library of a given organization in JSON format and displays the basic song information in searchable format.

## NotificationViewController

This is a future view controller to be used for announcements and file changes by the director. Other notifications could be included here as well.

## LoginViewController and RegisterViewController

The LoginVC is used to login or go to the RegisterVC. The main functionality of the login is done through the ApiHelper file, which has `userId` and `AUTH_TOKEN` variables to keep track of who is currently logged in. You can logout from the profile page.

## User View Controller
This is the view controller used to display user information from the roster. It uses the same format as the Profile view controller, however it is not editable. 

Features:

If a user has the default email application that comes with iOS they will be able to send emails from this page using that app. 

If the user has a phone number entered in their profile a text message can be sent from app. 


TODO: 

Instrumentation is hard coded right now. Need to pull this information from the database and display it.

## (New) Edit Profile View Controller

This is the page marked NewEditProfileViewController.This pages allows the user to edit / add some information into their profile page and change their profile picture.

Features:

Can take a picture or choose from library.

If the user has a phone number entered in their profile a text message can be sent from app. 

TODO: 

Find a way to take the year off the birthday picker. The sponsor wanted to only have the actual day/month of the bithday.

Update "Save Profile" icon on the green button. Ionicon is coming out with a floppy disk icon that we wanted to use.

Dynamically move screen up with the keyboard so the user can see what they are typing into the field.

Be able to change / add / remove instrumentation - What instruments do they play, what parts do they sing.


## Song View Controller

This is a table view controller used to display information about a song and whatever resources that are attached to it, such as any pdfs, youtube videos or the .mxl files that can be used with the Practice Page.

The first cell is basic information about the song, like the title, arranger and composer. Then we display the mxl files we have, any youtube links and finally any pdfs. 

The thing to watch out for is that when getting resources from the backend, they are not in any kind of order, and since the table required that we know the number of each type, I had to do some extra arrays to maintain which resource went with which cell, which is why there are a bunch of extra arrays.

TODO: 

Wanted to add more resources types (mp4, wav, etc).

## Event View Controller

On this page we display any events that a choir might be participating in. The first cell displays the event name, date, what time and where the event will take place. The bottom half of the page is used to display the program that will be used at that event. The program includes all the songs that they will be singing. Each song will have display what category of song it is, e.g. choral prelude, the song title, the composer, as well as any notes that the director has that are specific to the program about that song.

Clicking on any of the songs in the program will take the user to the Song View Controller.

## Profile View Controller

This page displays any basic information about the user that they have inputted into the app. This includes stuff like name, birthday, biography, etc. From this page the user can go to the edit profile page or log out.

TODO:

Instrumentation is hard coded. Need to flesh out this part more.

## Roster View Controller

This page displays all the members that are part of a choir. It displays their profile picture, first and last name, and then their email address. You can search through the choir by pulling down from the top to find the search bar. On click of any of the rows it will take you to that user's user page.

TODO:

Bug where the profile picture is not updating when the search function is used.


