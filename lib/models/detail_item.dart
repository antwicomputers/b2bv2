/// A normalized view-model that all entity types (Business, Resources,
/// Support, Events) map into before being shown on the universal detail screen.
/// This avoids having four near-identical detail screens for the same UI.
class DetailItem {
  final String id;
  final String name;
  final String description;
  final String address;
  final String category;
  final String imageUrl;

  // Contact / social
  final String phone;
  final String email;
  final String website;
  final String facebook;
  final String twitter;
  final String instagram;
  final String tiktok;
  final String twitch;
  final String linkedIn;
  final String youtube;
  final String podcast;

  // Firestore collection this item lives in (used for like/favourite writes)
  final String firestoreCollection;

  // Map pinning coordinates
  final double latitude;
  final double longitude;

  /// Optional — only Events have a date
  final DateTime? eventDate;

  /// Multiple images for gallery
  final List<String> galleryImages;

  // Collection-specific flags
  final bool isVerified;
  final bool isSponsored;
  final bool womenOriented;
  final bool isBlackOwned;

  const DetailItem({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.category,
    required this.imageUrl,
    required this.firestoreCollection,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.phone = '',
    this.email = '',
    this.website = '',
    this.facebook = '',
    this.twitter = '',
    this.instagram = '',
    this.tiktok = '',
    this.twitch = '',
    this.linkedIn = '',
    this.youtube = '',
    this.podcast = '',
    this.eventDate,
    this.galleryImages = const [],
    this.isVerified = false,
    this.isSponsored = false,
    this.womenOriented = false,
    this.isBlackOwned = false,
  });
}
