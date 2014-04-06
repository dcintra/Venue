dl2901

=======================
Quick Info
=======================

VenueFider is a location-based app that helps you search for any kind of place (restaurants, bars, shops) nearby. 

=======================
File Highlights (most of the code is here)
=======================

1. CustomClasses Group
2. Controllers Group
3. CoreData
4. Storyboard
5. Images

=======================
Assignment Details
=======================

Steps Completed: All

Details on steps completed:

STEP 1: I decided to take a somewhat different design approach (as discussed with Will). Instead of embedding the search view into the tab controller I decided to decouple it from the map view. As a result the user is not able to get to the tab controller without having done a search. However, they can access their bookmarks by clicking on the  bookmarks button within the search bar. Should nothing be stored in core data, they’ll see a message that they should add places. 

STEP2:  I used a third-party library (SWTableViewCell) to enable swipeable cells to reveal a save button on the ListView. Once the user clicks on the utility button the place name and address is stored in Core Data. To remove a place from your bookmarks, the user goes to their bookmarks tab and can swipe to the left to reveal a delete button. 

STEP 3:  The first time the user uses the app, the app logo falls to the bottom of the screen. The user can drag it around on the screen however once it’s tapped a welcome message is shown. As soon as it’s dismissed the button disappears and won’t appear again unless the app is reinstalled. 

STEP 4: The custom class “PlacesAPISearch” performs the networking requests to return the results. Once you hit search on the search bar, a spinner appears in the search bar  to demonstrate that we’re waiting on the request and the user can hit the cancel button at any time whilst they’re waiting. 

Third-party libraries:
- SWTableViewCell

Sources: 
-Stanford iTunes U, Developing iOS 7 Apps for iPhone and iPad, Lecture 15, Paul Hegarty
-iOS 7 Programming, O’Reilly, Matt Neuburg
-I had to create custom segue from Search bar View to Favorites tab and used Segue described here: http://stackoverflow.com/questions/19243131/xcode-custom-segue-animation


=======================
Known Bugs
=======================

No known bugs

=======================
Lessons Learned
=======================

Core Data is very powerful and I’m excited to explore the features it might have. The Google places API also presents a wide variety of options that got me excited to explore further too. 


