import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reflex/views/my.dart';

Color kPrimaryColor = Colors.blueAccent[400];
Color kAccentColor = Colors.lightGreenAccent;
Color kDarkThemeBlack = Colors.black;
Color kDarkBodyThemeBlack = Colors.grey[900];

final kDefaultFontBold = 'primaryBold';
final kDefaultFont = 'primaryFont';

// GetStorage constants
final kMyName = kGetStorage.read('myName');
final kMyProfileImage = kGetStorage.read('myProfilePicture');
final kMyId = kGetStorage.read('myId');
final kInterestOne = kGetStorage.read('myInterestOne');
final kInterestTwo = kGetStorage.read('myInterestTwo');
final kMyAbout = kGetStorage.read('myAbout');
final kMyNotificationToken = kGetStorage.read('myNotificationToken');

final kFirestoreInstance = FirebaseFirestore.instance;
final kFirebaseAuthInstance = FirebaseAuth.instance;
final kUsersRef = kFirestoreInstance.collection('Users');
final kChatRoomsRef = kFirestoreInstance.collection('ChatRooms');
final kClubChatRoomsRef = kFirestoreInstance.collection('ClubChatRooms');
final kClubsRef = kFirestoreInstance.collection('Clubs');
final kInterestSharingPeopleRef =
    kUsersRef.where("interests", arrayContains: kInterestTwo);

final String kTemporalImageUrl =
    'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';

BoxDecoration kContainerBorderDecoration = BoxDecoration(
  color: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
  border: Border.all(
    color: Get.isDarkMode ? Colors.transparent : Colors.grey[200],
    width: 1,
  ),
);

GestureDetector appBarCircleAvatar = GestureDetector(
  onTap: () => Get.to(Me()),
  child: Container(
    padding: EdgeInsets.all(5),
    child: kMyProfileImage == null
        ? CircleAvatar(
            backgroundColor:
                Get.isDarkMode ? Colors.grey[800] : Colors.grey[100],
            backgroundImage: AssetImage('assets/temporalPhoto.png'),
          )
        : CircleAvatar(
            backgroundColor:
                Get.isDarkMode ? Colors.grey[800] : Colors.grey[100],
            backgroundImage: NetworkImage(kMyProfileImage),
          ),
  ),
);

TextStyle kFont23 = TextStyle(
  fontSize: 23,
  color: Get.isDarkMode ? Colors.white : Colors.black,
  // fontFamily: kDefaultFontBold,
  fontWeight: FontWeight.bold,
);

TextStyle kGrey11 = TextStyle(
  fontSize: 11,
  color: Colors.grey,
  // fontFamily: kDefaultFont,
);

TextStyle kGrey13 = TextStyle(
  fontSize: 13,
  color: Colors.grey,
  // fontFamily: kDefaultFont,
);

TextStyle kGrey14 = TextStyle(
  fontSize: 14,
  color: Colors.grey[400],
  // fontFamily: kDefaultFont,
);

TextStyle kGrey16 = TextStyle(
  fontSize: 16,
  color: Colors.grey,
  // fontFamily: kDefaultFont,
);

TextStyle kBold18 = TextStyle(
  fontSize: 18,
  // fontFamily: kDefaultFontBold,
  fontWeight: FontWeight.bold,
);

TextStyle kBold15 = TextStyle(
  fontSize: 15,
  color: Get.isDarkMode ? Colors.white : Colors.black,
  // fontFamily: kDefaultFontBold,
  fontWeight: FontWeight.bold,
);

// TextStyle kFont13 = TextStyle(
//   fontSize: 13,
//   color: Get.isDarkMode ? Colors.white : Colors.black,
//   // fontFamily: kDefaultFontBold,
//   // fontWeight:FontWeight.bold,
// );

TextStyle kBold16 = TextStyle(
  fontSize: 16,
  color: Get.isDarkMode ? Colors.white : Colors.black,
  // fontFamily: kDefaultFontBold,
  fontWeight: FontWeight.bold,
);

TextStyle kBoldColor15 = TextStyle(
  fontSize: 15,
  color: Get.isDarkMode ? Colors.white : kPrimaryColor,
  // fontFamily: kDefaultFontBold,
  fontWeight: FontWeight.bold,
);

TextStyle kFont14 = TextStyle(
  fontSize: 14,
  color: Get.isDarkMode ? Colors.white : Colors.black,
  // fontFamily: kDefaultFont,
);

TextStyle kFont13 = TextStyle(
  fontSize: 13,
);

TextStyle kFont16 = TextStyle(
  fontSize: 16,
);

TextStyle kWhiteFont16 = TextStyle(
  fontSize: 16,
  color: Colors.white,
);

final kGetStorage = GetStorage();

List kClubCategories = <String>[
  "Humour",
  "Science and tech",
  "Travel",
  "Buy and sell",
  "Business",
  "Style",
  "Health",
  "Animals",
  "Sports and fitness",
  "Arts",
  "Education",
  "Entertainment",
  "Faith and spirituality",
  "Relationship and identity",
  "Parenting",
  "Hobbies and interests",
  "Foods and drinks",
  "Vehicles",
  "Civics and community",
];

List kInterestsItems = <String>[
  'Acting',
  'Arts',
  'Astrology',
  'Baseball',
  'Basketball',
  'Blacksmithing',
  'Blogging',
  'Board Games',
  'Body Building',
  'Boxing',
  'Car Racing',
  'Cardio Workout',
  'Cartooning',
  'Collecting',
  'Compose Music',
  'Computer activities and tech',
  'Cooking',
  'Cosplay',
  'Crafts',
  'Crocheting',
  'Chess',
  'Cycling',
  'Dancing',
  'Darts',
  'Digital Photography',
  'Diving',
  'Dodgeball',
  'Downhill Skateboarding',
  'Downhill Mountain Biking',
  'Drawing',
  'Dumpster Diving',
  'Electronics',
  'Embroidery',
  'Entertaining',
  'Exercise',
  'Fast cars',
  'Felting',
  'Fencing',
  'Fishing',
  'Floorball',
  'Floral Arrangements',
  'Flowboarding',
  'Fly Fishing',
  'Football',
  'Four Wheeling',
  'Free Climbing',
  'Freshwater Aquariums',
  'Frisbee Golf',
  'Computer Games',
  'Garage Saleing',
  'Gardening',
  'Ghost Hunting',
  'Glowsticking',
  'Gnoming',
  'Go Kart Racing',
  'Going to movies',
  'Golf',
  'Guitar',
  'Gun Collecting',
  'Gunsmithing',
  'Gymnastics',
  'Gyotaku',
  'Hang gliding',
  'Herping',
  'Highlining',
  'Hiking',
  'Home Brewing',
  'Home Repair',
  'Horseback Riding',
  'Hot air ballooning',
  'Hula Hooping',
  'Hunting',
  'Ice Climbing',
  'Ice Diving',
  'Ice Cross Downhill',
  'Ice Fishing',
  'Ice Skating',
  'Impersonations',
  'Inline Skating',
  'Illusion',
  'Internet',
  'Inventing',
  'Jet Engines',
  'Jetboarding',
  'Jewelry Making',
  'Jigsaw Puzzles',
  'Jousting',
  'Juggling',
  'Jump Roping',
  'Kayaking',
  'Keep A Journal',
  'Kitchen Chemistry',
  'Kite Boarding',
  'Knitting',
  'Learning A Foreign Language',
  'Learning An Instrument',
  'Leathercrafting',
  'Legos',
  'Listening to music',
  'Macramé',
  'Motocross',
  'Motorcycle Stunts',
  'Mountain Biking',
  'Musical Instruments',
  'Painting',
  'Parachuting',
  'Paragliding or Power Paragliding',
  'Parkour',
  'Photography',
  'Playing music',
  'Playing team sports',
  'Pole Dancing',
  'Robotics',
  'Rapping',
  'Reading',
  'Rock Climbing',
  'Running',
  'Sailing',
  'Scrapbooking',
  'Scuba Diving',
  'Sewing',
  'Shopping',
  'Skateboarding',
  'Singing',
  'Sketching',
  'Sky Diving',
  'Soap Making',
  'Snowboarding',
  'Soccer',
  'Socializing',
  'Storytelling',
  'Surfing',
  'Swimming',
  'Tai Chi',
  'Tennis',
  'Traveling',
  'Treasure Hunting',
  'Tutoring Children',
  'Video Games',
  'Watching sporting events',
  'Wine Making',
  'Woodworking',
  'Working on cars',
  'Working In A Food Pantry',
  'Wrestling',
  'Writing',
  'Writing Songs',
  'Yoga',
  'Ziplining',
];
