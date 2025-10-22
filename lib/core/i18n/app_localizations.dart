import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AppLocalizations {
  final BuildContext _context;

  AppLocalizations._(this._context);

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations._(context);
  }

  Locale get locale => _context.locale;

  String translate(
    String key, {
    Map<String, String>? namedArgs,
    List<String>? args,
  }) {
    return tr(key, context: _context, namedArgs: namedArgs, args: args);
  }

  String pluralize(String key, num count, {Map<String, String>? namedArgs}) {
    final suffix = count == 1 ? 'one' : 'other';
    final mergedArgs = {...?namedArgs, 'count': '$count'};
    return translate('$key.$suffix', namedArgs: mergedArgs);
  }

  // Helper methods for commonly used strings
  String get appTitle => translate('app.title');

  // Auth
  String get signIn => translate('auth.signIn');
  String get signUp => translate('auth.signUp');
  String get email => translate('auth.email');
  String get password => translate('auth.password');
  String get confirmPassword => translate('auth.confirmPassword');
  String get signInButton => translate('auth.signInButton');
  String get signUpButton => translate('auth.signUpButton');
  String get noAccount => translate('auth.noAccount');
  String get hasAccount => translate('auth.hasAccount');
  String get emailVerificationSent => translate('auth.emailVerificationSent');
  String get accountCreated => translate('auth.accountCreated');
  String get signOutButton => translate('auth.signOutButton');
  String get resendVerification => translate('auth.resendVerification');

  // Home
  String get homeTitle => translate('home.title');
  String get welcome => translate('home.welcome');
  String loggedInAs(String email) =>
      translate('home.loggedInAs').replaceAll('{email}', email);
  String get emailNotVerified => translate('home.emailNotVerified');
  String get emailVerified => translate('home.emailVerified');
  String get comingSoon => translate('home.comingSoon');

  // Jobs
  String get myJobs => translate('jobs.myJobs');
  String get createJob => translate('jobs.createJob');
  String get noJobsYet => translate('jobs.noJobsYet');
  String get createFirstJob => translate('jobs.createFirstJob');
  String get errorLoadingJobs => translate('jobs.errorLoadingJobs');
  String get rooms => translate('jobs.rooms');
  String get moreServices => translate('jobs.moreServices');

  // Job
  String get jobNewTitle => translate('job.newTitle');
  String get jobCreateSuccess => translate('job.createSuccess');

  // Job Form
  // PG-14: Address fields
  String get jobFormTitle => translate('jobForm.title');
  String get jobFormAddress => translate('jobForm.address');
  String get jobFormAddressRequired => translate('jobForm.addressRequired');
  String get jobFormCity => translate('jobForm.city');
  String get jobFormCityRequired => translate('jobForm.cityRequired');
  String get jobFormDistrict => translate('jobForm.district');
  String get jobFormHint => translate('jobForm.hint');
  String get jobFormHintExample => translate('jobForm.hintExample');
  String get jobFormDoorcode => translate('jobForm.doorcode');
  String get jobFormDoorcodeExample => translate('jobForm.doorcodeExample');
  String get jobFormLocationTitle => translate('jobForm.location.title');
  String get jobFormLocationHelper => translate('jobForm.location.helper');
  String get jobFormLocationPlaceholder =>
      translate('jobForm.location.placeholder');
  String jobFormLocationCoordinates({
    required String lat,
    required String lng,
  }) => translate(
    'jobForm.location.coordinates',
  ).replaceAll('{lat}', lat).replaceAll('{lng}', lng);
  String get jobFormLocationMapCaption =>
      translate('jobForm.location.mapCaption');
  String get jobFormLocationSelect => translate('jobForm.location.select');
  String get jobFormLocationChange => translate('jobForm.location.change');
  String jobFormLocationSelected({required String address}) =>
      translate('jobForm.location.selected').replaceAll('{address}', address);
  String get jobFormLocationAddressRequired =>
      translate('jobForm.location.addressRequired');
  String get jobFormLocationNoResults =>
      translate('jobForm.location.noResults');
  String get jobFormLocationDialogTitle =>
      translate('jobForm.location.dialog.title');
  String get jobFormLocationDialogAddressLabel =>
      translate('jobForm.location.dialog.addressLabel');
  String get jobFormLocationDialogAddressHint =>
      translate('jobForm.location.dialog.addressHint');
  String get jobFormLocationDialogSearching =>
      translate('jobForm.location.dialog.searching');
  String get jobFormLocationDialogSearch =>
      translate('jobForm.location.dialog.search');

  String jobFormDurationHours(int hours) =>
      translate('jobForm.durationHours').replaceAll('{hours}', '$hours');

  String jobFormDurationHoursMinutes(int hours, int minutes) => translate(
    'jobForm.durationHoursMinutes',
  ).replaceAll('{hours}', '$hours').replaceAll('{minutes}', '$minutes');

  String get jobFormSize => translate('jobForm.size');
  String get jobFormSizeM2 => translate('jobForm.sizeM2');
  String get jobFormSizeRequired => translate('jobForm.sizeRequired');
  String get jobFormSizeInvalid => translate('jobForm.sizeInvalid');
  String get jobFormRooms => translate('jobForm.rooms');
  String get jobFormRoomsRequired => translate('jobForm.roomsRequired');
  String get jobFormRoomsInvalid => translate('jobForm.roomsInvalid');
  String get jobFormServices => translate('jobForm.services');
  String get jobFormServicesRequired => translate('jobForm.servicesRequired');
  String get jobFormSchedule => translate('jobForm.schedule');
  String get jobFormStartDate => translate('jobForm.startDate');
  String get jobFormEndDate => translate('jobForm.endDate');
  String get jobFormStartTime => translate('jobForm.startTime');
  String get jobFormEndTime => translate('jobForm.endTime');
  String get jobFormSelectDate => translate('jobForm.selectDate');
  String get jobFormSelectTime => translate('jobForm.selectTime');
  String get jobFormScheduleRequired => translate('jobForm.scheduleRequired');
  String get jobFormScheduleInvalid => translate('jobForm.scheduleInvalid');
  String get jobFormBudget => translate('jobForm.budget');
  String get jobFormBudgetAmount => translate('jobForm.budgetAmount');
  String get jobFormBudgetRequired => translate('jobForm.budgetRequired');
  String get jobFormBudgetInvalid => translate('jobForm.budgetInvalid');
  String get jobFormCategoryTitle => translate('jobForm.categoryTitle');
  String get jobFormCategorySmall => translate('jobForm.categorySmall');
  String get jobFormCategoryMedium => translate('jobForm.categoryMedium');
  String get jobFormCategoryLarge => translate('jobForm.categoryLarge');
  String get jobFormCategoryXl => translate('jobForm.categoryXl');
  String get jobFormCategoryVilla => translate('jobForm.categoryVilla');
  String get jobFormExtrasTitle => translate('jobForm.extrasTitle');
  String get jobFormExtrasSubtitle => translate('jobForm.extrasSubtitle');
  String get jobFormOptionMaterialsProvided =>
      translate('jobForm.optionMaterialsProvided');
  String get jobFormOptionMaterialsProvidedSubtitle =>
      translate('jobForm.optionMaterialsProvidedSubtitle');
  String get jobFormOptionExpress => translate('jobForm.optionExpress');
  String get jobFormOptionExpressSubtitle =>
      translate('jobForm.optionExpressSubtitle');
  String get jobFormSummaryTitle => translate('jobForm.summaryTitle');
  String get jobFormSummaryDuration => translate('jobForm.summaryDuration');
  String get jobFormSummaryEnd => translate('jobForm.summaryEnd');
  String get jobFormSummaryPrice => translate('jobForm.summaryPrice');
  String get jobFormSummaryPending => translate('jobForm.summaryPending');
  String get jobFormSummaryDisclaimer => translate('jobForm.summaryDisclaimer');
  String get jobFormExtraWindowsInside =>
      translate('jobForm.extraWindowsInside');
  String get jobFormExtraWindowsInOut => translate('jobForm.extraWindowsInOut');
  String get jobFormExtraKitchenDeep => translate('jobForm.extraKitchenDeep');
  String get jobFormExtraBathroomDeep => translate('jobForm.extraBathroomDeep');
  String get jobFormExtraLaundry => translate('jobForm.extraLaundry');
  String get jobFormExtraIroningLight => translate('jobForm.extraIroningLight');
  String get jobFormExtraIroningFull => translate('jobForm.extraIroningFull');
  String get jobFormExtraBalcony => translate('jobForm.extraBalcony');
  String get jobFormExtraOrganization => translate('jobForm.extraOrganization');
  String get jobFormNotes => translate('jobForm.notes');
  String get jobFormNotesHint => translate('jobForm.notesHint');
  String get jobFormSubmit => translate('jobForm.submit');
  String get jobFormSubmitError => translate('jobForm.submitError');
  String get jobFormLocationSaveWarning =>
      translate('jobForm.locationSaveWarning');

  // Common
  String get commonCancel => translate('common.cancel');

  // Services
  String get serviceGeneralCleaning => translate('services.generalCleaning');
  String get serviceDeepCleaning => translate('services.deepCleaning');
  String get serviceWindowCleaning => translate('services.windowCleaning');
  String get serviceCarpetCleaning => translate('services.carpetCleaning');
  String get serviceKitchenCleaning => translate('services.kitchenCleaning');
  String get serviceBathroomCleaning => translate('services.bathroomCleaning');
  String get serviceIroning => translate('services.ironing');
  String get serviceOrganization => translate('services.organization');

  // Status
  String get statusOpen => translate('status.open');
  String get statusAssigned => translate('status.assigned');
  String get statusCompleted => translate('status.completed');
  String get statusCancelled => translate('status.cancelled');

  // Leads
  String get leadInboxTitle => translate('leads.inboxTitle');
  String get leadAccept => translate('leads.accept');
  String get leadDecline => translate('leads.decline');
  String get leadAccepted => translate('leads.accepted');
  String get leadDeclined => translate('leads.declined');
  String get leadInboxEmptyTitle => translate('leads.inboxEmptyTitle');
  String get leadInboxEmptySubtitle => translate('leads.inboxEmptySubtitle');
  String get leadInboxErrorTitle => translate('leads.inboxErrorTitle');
  String leadInboxErrorDetails(String error) =>
      translate('leads.inboxErrorDetails').replaceAll('{error}', error);
  String get leadCardTitle => translate('leads.cardTitle');
  String leadCardJobId(String id) =>
      translate('leads.cardJobId').replaceAll('{id}', id);
  String get leadCardMessageLabel => translate('leads.cardMessageLabel');
  String get leadViewJob => translate('leads.viewJob');
  String get leadSnackbarAcceptSuccess =>
      translate('leads.snackbarAcceptSuccess');
  String leadSnackbarAcceptError(String error) =>
      translate('leads.snackbarAcceptError').replaceAll('{error}', error);
  String get leadSnackbarDeclineSuccess =>
      translate('leads.snackbarDeclineSuccess');
  String leadSnackbarDeclineError(String error) =>
      translate('leads.snackbarDeclineError').replaceAll('{error}', error);
  String get leadStatusPending => translate('leads.statusPending');
  String get leadInboxFallbackTitle => translate('leads.fallbackTitle');
  String get leadInboxFallbackMessage => translate('leads.fallbackMessage');
  String leadInboxFallbackError(String error) =>
      translate('leads.fallbackErrorPrefix').replaceAll('{error}', error);

  // Notification types
  String get notificationTypeLeadNew => translate('notifications.type.leadNew');
  String get notificationTypeLeadAccepted =>
      translate('notifications.type.leadAccepted');
  String get notificationTypeLeadDeclined =>
      translate('notifications.type.leadDeclined');
  String get notificationTypeJobAssigned =>
      translate('notifications.type.jobAssigned');
  String get notificationTypeJobChanged =>
      translate('notifications.type.jobChanged');
  String get notificationTypeJobCancelled =>
      translate('notifications.type.jobCancelled');
  String get notificationTypeReminder24h =>
      translate('notifications.type.reminder24h');
  String get notificationTypeReminder1h =>
      translate('notifications.type.reminder1h');
  String get notificationTypePaymentCaptured =>
      translate('notifications.type.paymentCaptured');
  String get notificationTypePaymentReleased =>
      translate('notifications.type.paymentReleased');
  String get notificationTypePaymentRefunded =>
      translate('notifications.type.paymentRefunded');
  String get notificationTypeDisputeOpened =>
      translate('notifications.type.disputeOpened');
  String get notificationTypeDisputeResponse =>
      translate('notifications.type.disputeResponse');
  String get notificationTypeDisputeDecision =>
      translate('notifications.type.disputeDecision');
  String get notificationTypeChatMessage =>
      translate('notifications.type.chatMessage');

  // Errors
  String get emailRequired => translate('errors.emailRequired');
  String get invalidEmail => translate('errors.invalidEmail');
  String get passwordRequired => translate('errors.passwordRequired');
  String get passwordTooShort => translate('errors.passwordTooShort');
  String get passwordsNotMatch => translate('errors.passwordsNotMatch');
  String get confirmPasswordRequired =>
      translate('errors.confirmPasswordRequired');
  String get fieldRequired => translate('errors.fieldRequired');
  String get genericError => translate('errors.generic');

  // Success
  String get saved => translate('success.saved');
}
