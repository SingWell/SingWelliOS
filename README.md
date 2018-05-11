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


