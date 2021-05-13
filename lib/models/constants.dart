import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Color kPrimaryColor = Color(0xff4a89dc);
Color kAccentColor = Color(0xff8cc152);
Color kDarkThemeBlack = Color(0xff1E1E1E);
Color kDarkBodyThemeBlack = Color(0xff1A2633);
Color kDarkThemeAccent = Colors.blueGrey[900];
Color kDarkDeep = Colors.blueGrey[900];
Color kPrimaryLight = Color(0xff5d9cec);
Color kAppBarColor = !Get.isDarkMode ? kAppBarColor : kDarkThemeAccent;

// 5d9cec 4a89dc

// 8cc152

final kDefaultFontBold = 'primaryBold';
final kDefaultFont = 'primaryFont';
final kShadowInt = 0.9;

final kGiphyApiKey = "BubG443ZmyMcvRAyOs9XtDKjgRUASevv";
final kGifSearchEndPoint =
    "https://api.giphy.com/v1/gifs/search?api_key=$kGiphyApiKey&q=happy";
final kStickerSearchEndPoint =
    "https://api.giphy.com/v1/stickers/search?api_key=$kGiphyApiKey&q=happy";

// GetStorage constants
final kMyName = kGetStorage.read('myName');
final kMyProfileImage = kGetStorage.read('myProfilePicture');
final kMyId = kGetStorage.read('myId');
final kInterestOne = kGetStorage.read('myInterestOne');
final kInterestTwo = kGetStorage.read('myInterestTwo');
final kInterestThree = kGetStorage.read('myInterestThree');
final kMyAbout = kGetStorage.read('myAbout');
final kMyNotificationToken = kGetStorage.read('myNotificationToken');

final kFirestoreInstance = FirebaseFirestore.instance;
final kFirebaseAuthInstance = FirebaseAuth.instance;
final kUsersRef = kFirestoreInstance.collection('Users');
final kChatRoomsRef = kFirestoreInstance.collection('ChatRooms');
final kClubChatRoomsRef = kFirestoreInstance.collection('ClubChatRooms');
final kClubsRef = kFirestoreInstance.collection('Clubs');
final kInterestSharingPeopleRef =
    kUsersRef.where("interests", arrayContains: kInterestOne);

final String kTemporalImageUrl =
    'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';

BoxDecoration kContainerBorderDecoration = BoxDecoration(
  color: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
  border: Border.all(
    color: Get.isDarkMode ? Colors.transparent : Colors.grey[200],
    width: 1,
  ),
);

TextStyle kFont23 = TextStyle(
  fontSize: 23,
  color: Get.isDarkMode ? Colors.white : Colors.black,
  fontWeight: FontWeight.bold,
);

TextStyle kGrey11 = TextStyle(
  fontSize: 11,
  color: Colors.grey,
);

TextStyle kGrey13 = TextStyle(
  fontSize: 13,
  color: Colors.grey,
);

TextStyle kGrey12 = TextStyle(
  fontSize: 12,
  color: Colors.grey,
);

TextStyle kGrey14 = TextStyle(
  fontSize: 14,
  color: Colors.grey[500],
);

TextStyle kGrey16 = TextStyle(
  fontSize: 16,
  color: Colors.grey,
);

TextStyle placeholderTextStyle = TextStyle(
  fontSize: 16,
);

TextStyle kBold15 = TextStyle(
  fontSize: 15,
  color: Get.isDarkMode ? Colors.white : Colors.black,
  fontWeight: FontWeight.bold,
);

TextStyle kBold16 = TextStyle(
  fontSize: 16,
  color: Get.isDarkMode ? Colors.white : Colors.black,
  fontWeight: FontWeight.bold,
);

TextStyle kBoldColor15 = TextStyle(
  fontSize: 15,
  color: Get.isDarkMode ? Colors.white : kPrimaryColor,
  fontWeight: FontWeight.bold,
);

TextStyle kFont14 = TextStyle(
  fontSize: 14,
  color: Get.isDarkMode ? Colors.white : Colors.black,
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
