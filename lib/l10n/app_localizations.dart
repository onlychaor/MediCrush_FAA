import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('vi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'MediCrush'**
  String get appName;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Medical Information App'**
  String get appDescription;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage account and app preferences'**
  String get settingsSubtitle;

  /// No description provided for @profileSection.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileSection;

  /// No description provided for @medicrushUser.
  ///
  /// In en, this message translates to:
  /// **'MediCrush User'**
  String get medicrushUser;

  /// No description provided for @userEmail.
  ///
  /// In en, this message translates to:
  /// **'user@medicrush.com'**
  String get userEmail;

  /// No description provided for @generalSettings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive updates and news notifications'**
  String get notificationsSubtitle;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dark theme for comfortable viewing'**
  String get darkModeSubtitle;

  /// No description provided for @autoSync.
  ///
  /// In en, this message translates to:
  /// **'Auto Sync'**
  String get autoSync;

  /// No description provided for @autoSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically sync data'**
  String get autoSyncSubtitle;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @personalInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Edit account information'**
  String get personalInfoSubtitle;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update security password'**
  String get changePasswordSubtitle;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @securitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Security and privacy settings'**
  String get securitySubtitle;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get languageVietnamese;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @fontSizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get fontSizeSubtitle;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get download;

  /// No description provided for @downloadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage downloaded data'**
  String get downloadSubtitle;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @clearCacheSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Free up storage space'**
  String get clearCacheSubtitle;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @helpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FAQs and guides'**
  String get helpSubtitle;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @contactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send us your feedback'**
  String get contactSubtitle;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @rateAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your experience'**
  String get rateAppSubtitle;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get aboutSubtitle;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTitle;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutMessage;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete account and data'**
  String get deleteAccountSubtitle;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. Are you sure you want to delete your account?'**
  String get deleteAccountMessage;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account has been deleted'**
  String get accountDeleted;

  /// No description provided for @loggedOut.
  ///
  /// In en, this message translates to:
  /// **'Logged out'**
  String get loggedOut;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2024 MediCrush Team'**
  String get copyright;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'MediCrush v1.0.0'**
  String get version;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a Medication'**
  String get searchHint;

  /// No description provided for @go.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get go;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get searchResults;

  /// No description provided for @medications.
  ///
  /// In en, this message translates to:
  /// **'medications'**
  String get medications;

  /// No description provided for @viewSearchHistory.
  ///
  /// In en, this message translates to:
  /// **'View search history'**
  String get viewSearchHistory;

  /// No description provided for @loadingMedicationData.
  ///
  /// In en, this message translates to:
  /// **'Loading medication data...'**
  String get loadingMedicationData;

  /// No description provided for @welcomeToMedicrush.
  ///
  /// In en, this message translates to:
  /// **'Welcome to MediCrush'**
  String get welcomeToMedicrush;

  /// No description provided for @reliableMedicalInfo.
  ///
  /// In en, this message translates to:
  /// **'Reliable and accessible medical information platform'**
  String get reliableMedicalInfo;

  /// No description provided for @shareWithCommunity.
  ///
  /// In en, this message translates to:
  /// **'Share with Community'**
  String get shareWithCommunity;

  /// No description provided for @shareExperiences.
  ///
  /// In en, this message translates to:
  /// **'Share experiences, questions or useful information'**
  String get shareExperiences;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @shareContent.
  ///
  /// In en, this message translates to:
  /// **'Share Content'**
  String get shareContent;

  /// No description provided for @writeContentHere.
  ///
  /// In en, this message translates to:
  /// **'Write your content here...'**
  String get writeContentHere;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'friends'**
  String get friends;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @shareButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareButton;

  /// No description provided for @recentShares.
  ///
  /// In en, this message translates to:
  /// **'Recent Shares'**
  String get recentShares;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'hours ago'**
  String get hoursAgo;

  /// No description provided for @dayAgo.
  ///
  /// In en, this message translates to:
  /// **'day ago'**
  String get dayAgo;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get daysAgo;

  /// No description provided for @pleaseEnterContent.
  ///
  /// In en, this message translates to:
  /// **'Please enter content to share'**
  String get pleaseEnterContent;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get pleaseSelectCategory;

  /// No description provided for @shareSuccess.
  ///
  /// In en, this message translates to:
  /// **'Content shared successfully!'**
  String get shareSuccess;

  /// No description provided for @attachmentSelected.
  ///
  /// In en, this message translates to:
  /// **'Attachment selected'**
  String get attachmentSelected;

  /// No description provided for @coldTreatmentExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience treating flu'**
  String get coldTreatmentExperience;

  /// No description provided for @antibioticQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question about antibiotics'**
  String get antibioticQuestion;

  /// No description provided for @covidVaccineInfo.
  ///
  /// In en, this message translates to:
  /// **'Information about COVID-19 vaccine'**
  String get covidVaccineInfo;

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @myRewards.
  ///
  /// In en, this message translates to:
  /// **'My Rewards'**
  String get myRewards;

  /// No description provided for @earnPoints.
  ///
  /// In en, this message translates to:
  /// **'Earn Points'**
  String get earnPoints;

  /// No description provided for @redeemRewards.
  ///
  /// In en, this message translates to:
  /// **'Redeem Rewards'**
  String get redeemRewards;

  /// No description provided for @rewardHistory.
  ///
  /// In en, this message translates to:
  /// **'Reward History'**
  String get rewardHistory;

  /// No description provided for @pointsBalance.
  ///
  /// In en, this message translates to:
  /// **'Points Balance'**
  String get pointsBalance;

  /// No description provided for @availableRewards.
  ///
  /// In en, this message translates to:
  /// **'Available Rewards'**
  String get availableRewards;

  /// No description provided for @earnedToday.
  ///
  /// In en, this message translates to:
  /// **'Earned Today'**
  String get earnedToday;

  /// No description provided for @totalPoints.
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get totalPoints;

  /// No description provided for @claimReward.
  ///
  /// In en, this message translates to:
  /// **'Claim Reward'**
  String get claimReward;

  /// No description provided for @rewardDetails.
  ///
  /// In en, this message translates to:
  /// **'Reward Details'**
  String get rewardDetails;

  /// No description provided for @inviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get inviteFriends;

  /// No description provided for @referralProgram.
  ///
  /// In en, this message translates to:
  /// **'Referral Program'**
  String get referralProgram;

  /// No description provided for @inviteAndEarn.
  ///
  /// In en, this message translates to:
  /// **'Invite and Earn Rewards'**
  String get inviteAndEarn;

  /// No description provided for @shareInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Share Invite Code'**
  String get shareInviteCode;

  /// No description provided for @yourInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Your Invite Code'**
  String get yourInviteCode;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get copyCode;

  /// No description provided for @inviteViaWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Invite via WhatsApp'**
  String get inviteViaWhatsApp;

  /// No description provided for @inviteViaSMS.
  ///
  /// In en, this message translates to:
  /// **'Invite via SMS'**
  String get inviteViaSMS;

  /// No description provided for @inviteViaEmail.
  ///
  /// In en, this message translates to:
  /// **'Invite via Email'**
  String get inviteViaEmail;

  /// No description provided for @referralMilestones.
  ///
  /// In en, this message translates to:
  /// **'Referral Milestones'**
  String get referralMilestones;

  /// No description provided for @friendsInvited.
  ///
  /// In en, this message translates to:
  /// **'Friends Invited'**
  String get friendsInvited;

  /// No description provided for @milestoneRewards.
  ///
  /// In en, this message translates to:
  /// **'Milestone Rewards'**
  String get milestoneRewards;

  /// No description provided for @milestone10.
  ///
  /// In en, this message translates to:
  /// **'10 Friends - 100 Points'**
  String get milestone10;

  /// No description provided for @milestone20.
  ///
  /// In en, this message translates to:
  /// **'20 Friends - 250 Points'**
  String get milestone20;

  /// No description provided for @milestone50.
  ///
  /// In en, this message translates to:
  /// **'50 Friends - 750 Points'**
  String get milestone50;

  /// No description provided for @milestone100.
  ///
  /// In en, this message translates to:
  /// **'100 Friends - 2000 Points'**
  String get milestone100;

  /// No description provided for @claimMilestone.
  ///
  /// In en, this message translates to:
  /// **'Claim Milestone'**
  String get claimMilestone;

  /// No description provided for @milestoneClaimed.
  ///
  /// In en, this message translates to:
  /// **'Milestone Claimed'**
  String get milestoneClaimed;

  /// No description provided for @inviteMessage.
  ///
  /// In en, this message translates to:
  /// **'Join me on MediCrush - the best medical information app! Use my code: {code}'**
  String inviteMessage(Object code);

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite code copied to clipboard!'**
  String get codeCopied;

  /// No description provided for @inviteDetails.
  ///
  /// In en, this message translates to:
  /// **'Invite Details'**
  String get inviteDetails;

  /// No description provided for @sendInvite.
  ///
  /// In en, this message translates to:
  /// **'Send Invite'**
  String get sendInvite;

  /// No description provided for @inviteSent.
  ///
  /// In en, this message translates to:
  /// **'Invite Sent'**
  String get inviteSent;

  /// No description provided for @pendingInvites.
  ///
  /// In en, this message translates to:
  /// **'Pending Invites'**
  String get pendingInvites;

  /// No description provided for @successfulInvites.
  ///
  /// In en, this message translates to:
  /// **'Successful Invites'**
  String get successfulInvites;

  /// No description provided for @inviteStatus.
  ///
  /// In en, this message translates to:
  /// **'Invite Status'**
  String get inviteStatus;

  /// No description provided for @waitingForJoin.
  ///
  /// In en, this message translates to:
  /// **'Waiting for friend to join'**
  String get waitingForJoin;

  /// No description provided for @friendJoined.
  ///
  /// In en, this message translates to:
  /// **'Friend joined successfully!'**
  String get friendJoined;

  /// No description provided for @inviteExpired.
  ///
  /// In en, this message translates to:
  /// **'Invite expired'**
  String get inviteExpired;

  /// No description provided for @resendInvite.
  ///
  /// In en, this message translates to:
  /// **'Resend Invite'**
  String get resendInvite;

  /// No description provided for @inviteHistory.
  ///
  /// In en, this message translates to:
  /// **'Invite History'**
  String get inviteHistory;

  /// No description provided for @noInvitesYet.
  ///
  /// In en, this message translates to:
  /// **'No invites sent yet'**
  String get noInvitesYet;

  /// No description provided for @sendYourFirstInvite.
  ///
  /// In en, this message translates to:
  /// **'Send your first invite to start earning rewards!'**
  String get sendYourFirstInvite;

  /// No description provided for @inviteVia.
  ///
  /// In en, this message translates to:
  /// **'Invite via'**
  String get inviteVia;

  /// No description provided for @customMessage.
  ///
  /// In en, this message translates to:
  /// **'Custom Message'**
  String get customMessage;

  /// No description provided for @writePersonalMessage.
  ///
  /// In en, this message translates to:
  /// **'Write a personal message...'**
  String get writePersonalMessage;

  /// No description provided for @sendInviteTo.
  ///
  /// In en, this message translates to:
  /// **'Send invite to'**
  String get sendInviteTo;

  /// No description provided for @enterPhoneOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number or email'**
  String get enterPhoneOrEmail;

  /// No description provided for @inviteSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Invite sent successfully!'**
  String get inviteSentSuccessfully;

  /// No description provided for @friendWillReceive.
  ///
  /// In en, this message translates to:
  /// **'Your friend will receive the invite and can join using your code.'**
  String get friendWillReceive;

  /// No description provided for @progressToNextMilestone.
  ///
  /// In en, this message translates to:
  /// **'Progress to Next Milestone'**
  String get progressToNextMilestone;

  /// No description provided for @pleaseEnterContact.
  ///
  /// In en, this message translates to:
  /// **'Please enter contact information'**
  String get pleaseEnterContact;

  /// No description provided for @sharingViaWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Sharing via WhatsApp...'**
  String get sharingViaWhatsApp;

  /// No description provided for @sharingViaSMS.
  ///
  /// In en, this message translates to:
  /// **'Sharing via SMS...'**
  String get sharingViaSMS;

  /// No description provided for @sharingViaEmail.
  ///
  /// In en, this message translates to:
  /// **'Sharing via Email...'**
  String get sharingViaEmail;

  /// No description provided for @claimed.
  ///
  /// In en, this message translates to:
  /// **'Claimed'**
  String get claimed;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get points;

  /// No description provided for @forMilestone.
  ///
  /// In en, this message translates to:
  /// **'for'**
  String get forMilestone;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @medicationInfo.
  ///
  /// In en, this message translates to:
  /// **'Medication Information'**
  String get medicationInfo;

  /// No description provided for @treatmentExperience.
  ///
  /// In en, this message translates to:
  /// **'Treatment Experience'**
  String get treatmentExperience;

  /// No description provided for @sideEffects.
  ///
  /// In en, this message translates to:
  /// **'Side Effects'**
  String get sideEffects;

  /// No description provided for @medicalQuestion.
  ///
  /// In en, this message translates to:
  /// **'Medical Question'**
  String get medicalQuestion;

  /// No description provided for @drugReview.
  ///
  /// In en, this message translates to:
  /// **'Drug Review'**
  String get drugReview;

  /// No description provided for @medicalReference.
  ///
  /// In en, this message translates to:
  /// **'Medical Reference'**
  String get medicalReference;

  /// No description provided for @shareMedicationInfo.
  ///
  /// In en, this message translates to:
  /// **'Share medication information, dosage, usage instructions...'**
  String get shareMedicationInfo;

  /// No description provided for @shareTreatmentExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your treatment experience...'**
  String get shareTreatmentExperience;

  /// No description provided for @reportSideEffects.
  ///
  /// In en, this message translates to:
  /// **'Report side effects you encountered...'**
  String get reportSideEffects;

  /// No description provided for @askMedicalQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask questions about medications or treatment...'**
  String get askMedicalQuestion;

  /// No description provided for @reviewDrugEffectiveness.
  ///
  /// In en, this message translates to:
  /// **'Review the effectiveness of medications...'**
  String get reviewDrugEffectiveness;

  /// No description provided for @shareMedicalReference.
  ///
  /// In en, this message translates to:
  /// **'Share useful medical documents...'**
  String get shareMedicalReference;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
