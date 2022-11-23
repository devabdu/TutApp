///onBoarding
class SliderObject {
  String title;
  String subTitle;
  String image;

  SliderObject(
    this.title,
    this.subTitle,
    this.image,
  );
}

class SliderViewObject {
  SliderObject sliderObject;
  int numOfSlides;
  int currentIndex;

  SliderViewObject(
    this.sliderObject,
    this.numOfSlides,
    this.currentIndex,
  );
}

// login
class User {
  String userId;
  String userName;
  int userNumOfNotification;

  User(this.userId, this.userName, this.userNumOfNotification);
}

class Contacts {
  String phone;
  String email;
  String link;

  Contacts(this.phone, this.email, this.link);
}

class Authentication {
  User? user;
  Contacts? contacts;

  Authentication(this.user, this.contacts);
}

// home
class Services {
  int id;
  String title;
  String image;

  Services(this.id, this.title, this.image);
}

class Banners {
  int id;
  String link;
  String title;
  String image;

  Banners(this.id, this.link, this.title, this.image);
}

class Stores {
  int id;
  String title;
  String image;

  Stores(this.id, this.title, this.image);
}

class HomeData {
  List<Services> services;
  List<Banners> banners;
  List<Stores> stores;

  HomeData(this.services, this.banners, this.stores);
}

class HomeObject {
  HomeData data;

  HomeObject(this.data);
}

// storeDetails
class StoreDetails {
  String image;
  int id;
  String title;
  String details;
  String services;
  String about;

  StoreDetails(
      this.image, this.id, this.title, this.details, this.services, this.about);
}
