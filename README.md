# Foddie-Hunger
A food Delivery App developed in flutter, 
This app has 3 components
  1. Seller App
  2. User App
  3. Admin Web App
  <br>
This is the first Project of food delivery app which is <b>Seller App</b>.

Seller App:
1. The Seller will login through email and password.
2. The form(text fields) are validated before submitting to backend.
3. In case of any error or not validated a dialog box will open with that error to alert ⚠ the user about the same.
4. Once all validation pass, the app will upload the image and required name,email,password etc, to firestore database,
5. The seller is uniquely stored in the database with their unique UID.
6. While registering the user, I have also used SharedPrefrence library to store the data locally,
7. The main feature of storing the data locally is to reduce the time as well as complexity of the code as always for anything, I have to fetch from firestore.
8. Sellers can log in via email and password that will be checked from firebase auth,

Learning Objectives:
 1. I got familiar and get more experience in using Firebase auth,Firestore Database.
 2. I got many ideas of designing UI, that will be more interactive to Seller.
 3. Designing Custom TextField in seprate file and using that many time by importing that library and many such library as a part of cleaning and maintaing bug free code.
 4. Designing Topology.
 5. SharedPrefrences Library by Saving the data locally as to reduce the time of signing in( Seller app took only 2sec for signing in ).


Libraries Used:
1. Image Picker : Seller will upload their Restaurant Image while Registering from gallery.
2. geolocator: For Acessing the Location of Restaurant.
3. geocoding : For Converting Coordinates into readable address.
4. firebase_core: Used for connecting my Seller app to its Firebase project.
5. firebase_auth : Used for authenticating Sellers by their Email and Password.
6. cloud_firestore : Used for storing & syncing data of Sellers.
7. firebase_storage: This is used to store Sellers Images, thier foods image.
8. shared_preferences: Used to Save the Sellers data Locally.

![a](https://user-images.githubusercontent.com/83778936/147323724-f1aec3dd-26da-4cf6-8e8b-1547af56d28a.png)
![b](https://user-images.githubusercontent.com/83778936/147323728-9e3b9ef0-cc75-4a16-b86f-0d34d2514cd0.png)
![c](https://user-images.githubusercontent.com/83778936/147323730-8032c762-c1f2-4d3e-b744-fb457d460c63.png)
![d](https://user-images.githubusercontent.com/83778936/147323731-487e4e6d-bbe2-4de5-83e6-5019a89071b6.png)
![e](https://user-images.githubusercontent.com/83778936/147323716-183576ac-b24e-4a8d-abd7-59d2491d0be4.png)



