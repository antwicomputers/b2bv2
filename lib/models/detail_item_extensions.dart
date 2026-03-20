import 'package:b2bmobile/models/business.dart';
import 'package:b2bmobile/models/detail_item.dart';
import 'package:b2bmobile/models/events.dart';
import 'package:b2bmobile/models/resources.dart';
import 'package:b2bmobile/models/support.dart';

extension BusinessDetail on Business {
  DetailItem toDetailItem() => DetailItem(
        id: businessId,
        name: businessName,
        description: businessDescription,
        address: businessAddress,
        category: businessCategory,
        imageUrl: businessUrl,
        firestoreCollection: 'businesses',
        latitude: latitude,
        longitude: longitude,
        phone: phone,
        email: email,
        website: website,
        facebook: facebook,
        twitter: twitter,
        instagram: instagram,
        tiktok: tiktok,
        twitch: twitch,
        linkedIn: linkedIn,
        youtube: youtube,
        podcast: podcast,
      );
}

extension ResourcesDetail on Resources {
  DetailItem toDetailItem() => DetailItem(
        id: businessId,
        name: businessName,
        description: businessDescription,
        address: businessAddress,
        category: businessCategory,
        imageUrl: businessUrl,
        firestoreCollection: 'userresources',
        latitude: latitude,
        longitude: longitude,
        phone: phone,
        email: email,
        website: website,
        facebook: facebook,
        twitter: twitter,
        instagram: instagram,
        tiktok: tiktok,
        twitch: twitch,
        linkedIn: linkedIn,
        youtube: youtube,
        podcast: podcast,
      );
}

extension SupportDetail on Support {
  DetailItem toDetailItem() => DetailItem(
        id: supportId,
        name: supportName,
        description: supportDescription,
        address: supportAddress,
        category: supportCategory,
        imageUrl: supportUrl,
        firestoreCollection: 'userresourcesupport',
        latitude: latitude,
        longitude: longitude,
        phone: phone,
        email: email,
        website: website,
        facebook: facebook,
        twitter: twitter,
        instagram: instagram,
        tiktok: tiktok,
        twitch: twitch,
        linkedIn: linkedIn,
        youtube: youtube,
        podcast: podcast,
      );
}

extension EventsDetail on Events {
  DetailItem toDetailItem() => DetailItem(
        id: eventId,
        name: eventName,
        description: eventDescription,
        address: eventAddress,
        category: eventCategory,
        imageUrl: eventUrl,
        firestoreCollection: 'events',
        latitude: latitude,
        longitude: longitude,
        phone: phone,
        email: email,
        website: website,
        facebook: facebook,
        twitter: twitter,
        instagram: instagram,
        tiktok: tiktok,
        twitch: twitch,
        linkedIn: linkedIn,
        youtube: youtube,
        podcast: podcast,
        eventDate: eventDate,
      );
}
