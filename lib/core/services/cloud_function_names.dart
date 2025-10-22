/// Cloud Functions callable names - aligned with backend exports
class CloudFunctionNames {
  // Payments & Escrow
  static const createPaymentIntent = 'createPaymentIntent';
  static const purchaseCredits = 'purchaseCredits';
  static const releaseTransfer = 'releaseTransfer';
  static const partialRefund = 'partialRefund';
  static const createConnectOnboarding = 'createConnectOnboarding';

  // Jobs & Leads
  static const acceptLeadCF = 'acceptLeadCF';
  static const declineLeadCF = 'declineLeadCF';

  // Offers & Requests
  static const searchProOffersCF = 'searchProOffersCF';
  static const createOfferRequestCF = 'createOfferRequestCF';

  // Legal & Compliance
  static const setUserConsentCF = 'setUserConsentCF';
  static const getLegalStatsCF = 'getLegalStatsCF';
  static const publishLegalDocumentCF = 'publishLegalDocumentCF';

  // Admin & Disputes
  static const openDisputeCF = 'openDisputeCF';
  static const exportMyTransfersCsvCF = 'exportMyTransfersCsvCF';

  // Calendar & ETA
  static const eta = 'eta';

  // HTTP endpoints (for reference)
  static const stripeWebhook = 'stripeWebhook';
  static const generateIcs = 'generateIcs';
  static const ensureIcsToken = 'ensureIcsToken';
}
