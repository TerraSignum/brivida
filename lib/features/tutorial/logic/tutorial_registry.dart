import '../models/tutorial_context.dart';
import '../models/tutorial_step.dart';

/// Identifier for the screens supported by the tutorial engine.
enum TutorialScreen {
  home,
  jobForm,
  jobList,
  jobDetail,
  jobCompletion,
  offerSearch,
  jobFeed,
  finance,
  proOffers,
  leadInbox,
  chat,
  calendar,
  settings,
}

extension TutorialScreenX on TutorialScreen {
  String get id {
    switch (this) {
      case TutorialScreen.home:
        return 'home';
      case TutorialScreen.jobForm:
        return 'jobForm';
      case TutorialScreen.jobList:
        return 'jobList';
      case TutorialScreen.jobDetail:
        return 'jobDetail';
      case TutorialScreen.jobCompletion:
        return 'jobCompletion';
      case TutorialScreen.offerSearch:
        return 'offerSearch';
      case TutorialScreen.jobFeed:
        return 'jobFeed';
      case TutorialScreen.finance:
        return 'finance';
      case TutorialScreen.proOffers:
        return 'proOffers';
      case TutorialScreen.leadInbox:
        return 'leadInbox';
      case TutorialScreen.chat:
        return 'chat';
      case TutorialScreen.calendar:
        return 'calendar';
      case TutorialScreen.settings:
        return 'settings';
    }
  }
}

/// Central registry that maps each screen to its tutorial steps.
class TutorialRegistry {
  const TutorialRegistry._();

  static List<TutorialStep> stepsFor(
    TutorialScreen screen,
    TutorialContext context,
  ) {
    final steps = _definitions[screen] ?? const <TutorialStep>[];
    return steps.where((step) => step.shouldDisplay(context)).toList();
  }

  static final Map<TutorialScreen, List<TutorialStep>> _definitions = {
    TutorialScreen.home: [
      TutorialStep(
        titleKey: 'tutorial.home.step1.title',
        bodyKey: 'tutorial.home.step1.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.home.step2.title',
        bodyKey: 'tutorial.home.step2.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.home.step3.title',
        bodyKey: 'tutorial.home.step3.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.home.step4.title',
        bodyKey: 'tutorial.home.step4.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.home.step5.title',
        bodyKey: 'tutorial.home.step5.body',
      ),
    ],
    TutorialScreen.jobForm: [
      TutorialStep(
        titleKey: 'tutorial.jobForm.step1.title',
        bodyKey: 'tutorial.jobForm.step1.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobForm.step2.title',
        bodyKey: 'tutorial.jobForm.step2.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobForm.step3.title',
        bodyKey: 'tutorial.jobForm.step3.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobForm.step4.title',
        bodyKey: 'tutorial.jobForm.step4.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobForm.step5.title',
        bodyKey: 'tutorial.jobForm.step5.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobForm.step6.title',
        bodyKey: 'tutorial.jobForm.step6.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobForm.step7.title',
        bodyKey: 'tutorial.jobForm.step7.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobForm.step8.title',
        bodyKey: 'tutorial.jobForm.step8.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobForm.step9.title',
        bodyKey: 'tutorial.jobForm.step9.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobForm.step10.title',
        bodyKey: 'tutorial.jobForm.step10.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobForm.step11.title',
        bodyKey: 'tutorial.jobForm.step11.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
    ],
    TutorialScreen.jobList: [
      TutorialStep(
        titleKey: 'tutorial.jobList.step1.title',
        bodyKey: 'tutorial.jobList.step1.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobList.step2.title',
        bodyKey: 'tutorial.jobList.step2.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobList.step3.title',
        bodyKey: 'tutorial.jobList.step3.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobList.step4.title',
        bodyKey: 'tutorial.jobList.step4.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobList.step5.title',
        bodyKey: 'tutorial.jobList.step5.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
    ],
    TutorialScreen.jobDetail: [
      TutorialStep(
        titleKey: 'tutorial.jobDetail.step1.title',
        bodyKey: 'tutorial.jobDetail.step1.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.jobDetail.step2.title',
        bodyKey: 'tutorial.jobDetail.step2.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.jobDetail.step3.title',
        bodyKey: 'tutorial.jobDetail.step3.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.jobDetail.step4.title',
        bodyKey: 'tutorial.jobDetail.step4.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.jobDetail.step5.title',
        bodyKey: 'tutorial.jobDetail.step5.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobDetail.step6.title',
        bodyKey: 'tutorial.jobDetail.step6.body',
        predicate: (context) => context.isPro,
      ),
    ],
    TutorialScreen.jobCompletion: [
      TutorialStep(
        titleKey: 'tutorial.jobCompletion.step1.title',
        bodyKey: 'tutorial.jobCompletion.step1.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.jobCompletion.step2.title',
        bodyKey: 'tutorial.jobCompletion.step2.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.jobCompletion.step3.title',
        bodyKey: 'tutorial.jobCompletion.step3.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.jobCompletion.step4.title',
        bodyKey: 'tutorial.jobCompletion.step4.body',
        predicate: (context) => context.isCustomer,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobCompletion.step5.title',
        bodyKey: 'tutorial.jobCompletion.step5.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobCompletion.step6.title',
        bodyKey: 'tutorial.jobCompletion.step6.body',
        isCompletion: true,
      ),
    ],
    TutorialScreen.offerSearch: [
      TutorialStep(
        titleKey: 'tutorial.offerSearch.step1.title',
        bodyKey: 'tutorial.offerSearch.step1.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.offerSearch.step2.title',
        bodyKey: 'tutorial.offerSearch.step2.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.offerSearch.step3.title',
        bodyKey: 'tutorial.offerSearch.step3.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.offerSearch.step4.title',
        bodyKey: 'tutorial.offerSearch.step4.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.offerSearch.step5.title',
        bodyKey: 'tutorial.offerSearch.step5.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.offerSearch.step6.title',
        bodyKey: 'tutorial.offerSearch.step6.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.offerSearch.step7.title',
        bodyKey: 'tutorial.offerSearch.step7.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.offerSearch.step8.title',
        bodyKey: 'tutorial.offerSearch.step8.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
      TutorialStep(
        titleKey: 'tutorial.offerSearch.step9.title',
        bodyKey: 'tutorial.offerSearch.step9.body',
        predicate: (context) => context.isCustomer || context.isAdmin,
      ),
    ],
    TutorialScreen.jobFeed: [
      TutorialStep(
        titleKey: 'tutorial.jobFeed.step1.title',
        bodyKey: 'tutorial.jobFeed.step1.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobFeed.step2.title',
        bodyKey: 'tutorial.jobFeed.step2.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobFeed.step3.title',
        bodyKey: 'tutorial.jobFeed.step3.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobFeed.step4.title',
        bodyKey: 'tutorial.jobFeed.step4.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobFeed.step5.title',
        bodyKey: 'tutorial.jobFeed.step5.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobFeed.step6.title',
        bodyKey: 'tutorial.jobFeed.step6.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.jobFeed.step7.title',
        bodyKey: 'tutorial.jobFeed.step7.body',
        predicate: (context) => context.isPro,
      ),
    ],
    TutorialScreen.finance: [
      TutorialStep(
        titleKey: 'tutorial.finance.step1.title',
        bodyKey: 'tutorial.finance.step1.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.finance.step2.title',
        bodyKey: 'tutorial.finance.step2.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.finance.step3.title',
        bodyKey: 'tutorial.finance.step3.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.finance.step4.title',
        bodyKey: 'tutorial.finance.step4.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.finance.step5.title',
        bodyKey: 'tutorial.finance.step5.body',
        predicate: (context) => context.isPro,
      ),
    ],
    TutorialScreen.proOffers: [
      TutorialStep(
        titleKey: 'tutorial.proOffers.step1.title',
        bodyKey: 'tutorial.proOffers.step1.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.proOffers.step2.title',
        bodyKey: 'tutorial.proOffers.step2.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.proOffers.step3.title',
        bodyKey: 'tutorial.proOffers.step3.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.proOffers.step4.title',
        bodyKey: 'tutorial.proOffers.step4.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.proOffers.step5.title',
        bodyKey: 'tutorial.proOffers.step5.body',
        predicate: (context) => context.isPro,
      ),
    ],
    TutorialScreen.leadInbox: [
      TutorialStep(
        titleKey: 'tutorial.leadInbox.step1.title',
        bodyKey: 'tutorial.leadInbox.step1.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.leadInbox.step2.title',
        bodyKey: 'tutorial.leadInbox.step2.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.leadInbox.step3.title',
        bodyKey: 'tutorial.leadInbox.step3.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.leadInbox.step4.title',
        bodyKey: 'tutorial.leadInbox.step4.body',
        predicate: (context) => context.isPro,
      ),
      TutorialStep(
        titleKey: 'tutorial.leadInbox.step5.title',
        bodyKey: 'tutorial.leadInbox.step5.body',
        predicate: (context) => context.isPro,
      ),
    ],
    TutorialScreen.chat: [
      TutorialStep(
        titleKey: 'tutorial.chat.step1.title',
        bodyKey: 'tutorial.chat.step1.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.chat.step2.title',
        bodyKey: 'tutorial.chat.step2.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.chat.step3.title',
        bodyKey: 'tutorial.chat.step3.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.chat.step4.title',
        bodyKey: 'tutorial.chat.step4.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.chat.step5.title',
        bodyKey: 'tutorial.chat.step5.body',
      ),
    ],
    TutorialScreen.calendar: [
      TutorialStep(
        titleKey: 'tutorial.calendar.step1.title',
        bodyKey: 'tutorial.calendar.step1.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.calendar.step2.title',
        bodyKey: 'tutorial.calendar.step2.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.calendar.step3.title',
        bodyKey: 'tutorial.calendar.step3.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.calendar.step4.title',
        bodyKey: 'tutorial.calendar.step4.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.calendar.step5.title',
        bodyKey: 'tutorial.calendar.step5.body',
      ),
    ],
    TutorialScreen.settings: [
      TutorialStep(
        titleKey: 'tutorial.settings.step1.title',
        bodyKey: 'tutorial.settings.step1.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.settings.step2.title',
        bodyKey: 'tutorial.settings.step2.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.settings.step3.title',
        bodyKey: 'tutorial.settings.step3.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.settings.step4.title',
        bodyKey: 'tutorial.settings.step4.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.settings.step5.title',
        bodyKey: 'tutorial.settings.step5.body',
      ),
      TutorialStep(
        titleKey: 'tutorial.settings.step6.title',
        bodyKey: 'tutorial.settings.step6.body',
        isCompletion: true,
      ),
    ],
  };
}
