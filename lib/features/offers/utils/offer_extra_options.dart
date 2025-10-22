import '../../../core/models/pro_offer.dart';

class OfferExtraOption {
  const OfferExtraOption({required this.id, required this.labelKey});

  final String id;
  final String labelKey;
}

const List<OfferExtraOption> offerExtraOptions = [
  OfferExtraOption(
    id: 'windows_inside',
    labelKey: 'jobForm.extraWindowsInside',
  ),
  OfferExtraOption(id: 'windows_in_out', labelKey: 'jobForm.extraWindowsInOut'),
  OfferExtraOption(id: 'kitchen_deep', labelKey: 'jobForm.extraKitchenDeep'),
  OfferExtraOption(id: 'bathroom_deep', labelKey: 'jobForm.extraBathroomDeep'),
  OfferExtraOption(id: 'laundry', labelKey: 'jobForm.extraLaundry'),
  OfferExtraOption(id: 'ironing_light', labelKey: 'jobForm.extraIroningLight'),
  OfferExtraOption(id: 'ironing_full', labelKey: 'jobForm.extraIroningFull'),
  OfferExtraOption(id: 'balcony', labelKey: 'jobForm.extraBalcony'),
  OfferExtraOption(id: 'organization', labelKey: 'jobForm.extraOrganization'),
];

OfferExtras buildOfferExtrasFromSelection(Set<String> selected) {
  return OfferExtras(
    windowsInside: selected.contains('windows_inside'),
    windowsInOut: selected.contains('windows_in_out'),
    kitchenDeep: selected.contains('kitchen_deep'),
    bathroomDeep: selected.contains('bathroom_deep'),
    laundry: selected.contains('laundry'),
    ironingLight: selected.contains('ironing_light'),
    ironingFull: selected.contains('ironing_full'),
    balcony: selected.contains('balcony'),
    organization: selected.contains('organization'),
  );
}

Map<String, bool> buildExtrasMapFromSelection(Set<String> selected) {
  return {
    for (final option in offerExtraOptions)
      option.id: selected.contains(option.id),
  };
}

Set<String> selectedExtrasFromOffer(OfferExtras extras) {
  final selected = <String>{};
  if (extras.windowsInside) selected.add('windows_inside');
  if (extras.windowsInOut) selected.add('windows_in_out');
  if (extras.kitchenDeep) selected.add('kitchen_deep');
  if (extras.bathroomDeep) selected.add('bathroom_deep');
  if (extras.laundry) selected.add('laundry');
  if (extras.ironingLight) selected.add('ironing_light');
  if (extras.ironingFull) selected.add('ironing_full');
  if (extras.balcony) selected.add('balcony');
  if (extras.organization) selected.add('organization');
  return selected;
}
