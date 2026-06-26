import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/settings_state.dart';

extension TranslationExtension on String {
  String tr(BuildContext context) {
    final language = Provider.of<SettingsState>(context).language;
    return Translations.get(this, language);
  }
}

class Translations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'SafeReach': {
      'EN': 'SafeReach',
      'KH': 'SafeReach',
    },
    'Emergency Response Hub': {
      'EN': 'Emergency Response Hub',
      'KH': 'មជ្ឈមណ្ឌលសង្គ្រោះបន្ទាន់',
    },
    'IN AN EMERGENCY': {
      'EN': 'IN AN EMERGENCY',
      'KH': 'ក្នុងស្ថានភាពអាសន្ន',
    },
    'Press the SOS button below to call for help': {
      'EN': 'Press the SOS button below to call for help',
      'KH': 'ចុចប៊ូតុង SOS ខាងក្រោមដើម្បីហៅរកជំនួយ',
    },
    'Activates 3s confirmation window before calling': {
      'EN': 'Activates 3s confirmation window before calling',
      'KH': 'ដំណើរការរយៈពេល ៣វិនាទី មុនពេលហៅទូរស័ព្ទ',
    },
    'Search hospitals, police, rescue stations...': {
      'EN': 'Search hospitals, police, rescue stations...',
      'KH': 'ស្វែងរកមន្ទីរពេទ្យ ប៉ូលីស ស្ថានីយសង្គ្រោះ...',
    },
    'Primary Emergency Services': {
      'EN': 'Primary Emergency Services',
      'KH': 'សេវាសង្គ្រោះបន្ទាន់ចម្បង',
    },
    'Additional Helplines': {
      'EN': 'Additional Helplines',
      'KH': 'ខ្សែទូរស័ព្ទជំនួយបន្ថែម',
    },
    'Safety Tip: Update your personal contacts and input critical medical information like your blood group and allergies in Settings.': {
      'EN': 'Safety Tip: Update your personal contacts and input critical medical information like your blood group and allergies in Settings.',
      'KH': 'គន្លឹះសុវត្ថិភាព៖ ធ្វើបច្ចុប្បន្នភាពទំនាក់ទំនងផ្ទាល់ខ្លួន និងបញ្ចូលព័ត៌មានវេជ្ជសាស្ត្រសំខាន់ៗដូចជាក្រុមឈាម និងប្រតិកម្មអាឡែស៊ីនៅក្នុងការកំណត់។',
    },
    'Nearest Help Points': {
      'EN': 'Nearest Help Points',
      'KH': 'ចំណុចជំនួយដែលនៅជិតបំផុត',
    },
    'Your Saved Services': {
      'EN': 'Your Saved Services',
      'KH': 'សេវាកម្មដែលបានរក្សាទុក',
    },
    'No services found': {
      'EN': 'No services found',
      'KH': 'រកមិនឃើញសេវាកម្មទេ',
    },
    'We could not find emergency services in your area.': {
      'EN': 'We could not find emergency services in your area.',
      'KH': 'យើងរកមិនឃើញសេវាសង្គ្រោះបន្ទាន់នៅក្នុងតំបន់របស់អ្នកឡើយ។',
    },
    'Unable to load services': {
      'EN': 'Unable to load services',
      'KH': 'មិនអាចទាញយកសេវាកម្មបានទេ',
    },
    'Please check your connection and try again.': {
      'EN': 'Please check your connection and try again.',
      'KH': 'សូមពិនិត្យមើលការតភ្ជាប់របស់អ្នក រួចព្យាយាមម្តងទៀត។',
    },
    'Dark mode': {
      'EN': 'Dark mode',
      'KH': 'របៀបងងឹត',
    },
    'Language': {
      'EN': 'Language',
      'KH': 'ភាសា',
    },
    'Medical info': {
      'EN': 'Medical info',
      'KH': 'ព័ត៌មានវេជ្ជសាស្ត្រ',
    },
    'Save medical info': {
      'EN': 'Save medical info',
      'KH': 'រក្សាទុកព័ត៌មានវេជ្ជសាស្ត្រ',
    },
    'Medical info saved': {
      'EN': 'Medical info saved',
      'KH': 'បានរក្សាទុកព័ត៌មានវេជ្ជសាស្ត្រ',
    },
    'Use a valid blood group like A+, O-, or AB+': {
      'EN': 'Use a valid blood group like A+, O-, or AB+',
      'KH': 'សូមប្រើក្រុមឈាមត្រឹមត្រូវដូចជា A+, O-, ឬ AB+',
    },
    'Blood group': {
      'EN': 'Blood group',
      'KH': 'ក្រុមឈាម',
    },
    'Allergies': {
      'EN': 'Allergies',
      'KH': 'អាឡែស៊ី',
    },
    'About SafeReach': {
      'EN': 'About SafeReach',
      'KH': 'អំពី SafeReach',
    },
    'Emergency response, locations, and tips.': {
      'EN': 'Emergency response, locations, and tips.',
      'KH': 'ការឆ្លើយតបបន្ទាន់ ទីតាំង និងគន្លឹះផ្សេងៗ។',
    },
    'Save contact': {
      'EN': 'Save contact',
      'KH': 'រក្សាទុកទំនាក់ទំនង',
    },
    'Update contact': {
      'EN': 'Update contact',
      'KH': 'ធ្វើបច្ចុប្បន្នភាពទំនាក់ទំនង',
    },
    'Personal Contacts': {
      'EN': 'Personal Contacts',
      'KH': 'ទំនាក់ទំនងផ្ទាល់ខ្លួន',
    },
    'Personal contacts': {
      'EN': 'Personal Contacts',
      'KH': 'ទំនាក់ទំនងផ្ទាល់ខ្លួន',
    },
    'No emergency contacts': {
      'EN': 'No emergency contacts',
      'KH': 'មិនមានទំនាក់ទំនងអាសន្នទេ',
    },
    'Add family or friends for quick access.': {
      'EN': 'Add family or friends for quick access.',
      'KH': 'បន្ថែមក្រុមគ្រួសារ ឬមិត្តភក្តិដើម្បីទំនាក់ទំនងរហ័ស។',
    },
    'Name': {
      'EN': 'Name',
      'KH': 'ឈ្មោះ',
    },
    'Relationship': {
      'EN': 'Relationship',
      'KH': 'ទំនាក់ទំនង',
    },
    'Phone number': {
      'EN': 'Phone number',
      'KH': 'លេខទូរស័ព្ទ',
    },
    'Relationship (e.g. Family, Doctor)': {
      'EN': 'Relationship (e.g. Family, Doctor)',
      'KH': 'ទំនាក់ទំនង (ឧ. គ្រួសារ, គ្រូពេទ្យ)',
    },
    'Add Contact': {
      'EN': 'Add Contact',
      'KH': 'បន្ថែមទំនាក់ទំនង',
    },
    'Edit Contact': {
      'EN': 'Edit Contact',
      'KH': 'កែសម្រួលទំនាក់ទំនង',
    },
    'Map': {
      'EN': 'Map',
      'KH': 'ផែនទី',
    },
    'Nearby': {
      'EN': 'Nearby',
      'KH': 'នៅជិតៗ',
    },
    'Favorites': {
      'EN': 'Favorites',
      'KH': 'សំណព្វ',
    },
    'Contacts': {
      'EN': 'Contacts',
      'KH': 'ទំនាក់ទំនង',
    },
    'Settings': {
      'EN': 'Settings',
      'KH': 'ការកំណត់',
    },
    'Home': {
      'EN': 'Home',
      'KH': 'ទំព័រដើម',
    },
    'First-aid tips': {
      'EN': 'First-aid tips',
      'KH': 'គន្លឹះសង្គ្រោះបឋម',
    },
    'Service Details': {
      'EN': 'Service Details',
      'KH': 'ព័ត៌មានលម្អិតសេវាកម្ម',
    },
    'About Service': {
      'EN': 'About Service',
      'KH': 'អំពីសេវាកម្ម',
    },
    'CALL NOW': {
      'EN': 'CALL NOW',
      'KH': 'ហៅទូរស័ព្ទឥឡូវនេះ',
    },
    'Reviews & Ratings': {
      'EN': 'Reviews & Ratings',
      'KH': 'ការវាយតម្លៃ និងចំណាត់ថ្នាក់',
    },
    'Write a review': {
      'EN': 'Write a review',
      'KH': 'សរសេរការវាយតម្លៃ',
    },
    'Submit Emergency Review': {
      'EN': 'Submit Emergency Review',
      'KH': 'បញ្ជូនមតិវាយតម្លៃអាសន្ន',
    },
    'Rate your experience': {
      'EN': 'Rate your experience',
      'KH': 'វាយតម្លៃបទពិសោធន៍របស់អ្នក',
    },
    'Your Name': {
      'EN': 'Your Name',
      'KH': 'ឈ្មោះរបស់អ្នក',
    },
    'Describe your emergency experience': {
      'EN': 'Describe your emergency experience',
      'KH': 'រៀបរាប់ពីបទពិសោធន៍សង្គ្រោះបន្ទាន់របស់អ្នក',
    },
    'SUBMIT REVIEW': {
      'EN': 'SUBMIT REVIEW',
      'KH': 'បញ្ជូនមតិវាយតម្លៃ',
    },
    'No reviews posted yet. Be the first to share your experience!': {
      'EN': 'No reviews posted yet. Be the first to share your experience!',
      'KH': 'មិនទាន់មានការវាយតម្លៃនៅឡើយទេ។ ក្លាយជាអ្នកដំបូងគេដែលចែករំលែកបទពិសោធន៍របស់អ្នក!',
    },
    'TRIGGERING SOS ALARM': {
      'EN': 'TRIGGERING SOS ALARM',
      'KH': 'កំពុងកេះសំឡេងអាសន្ន SOS',
    },
    'Connecting you to emergency response and transmitting details.': {
      'EN': 'Connecting you to emergency response and transmitting details.',
      'KH': 'កំពុងភ្ជាប់ទៅកាន់ការឆ្លើយតបបន្ទាន់ និងបញ្ជូនព័ត៌មានលម្អិត។',
    },
    'SENDING GPS COORDINATES': {
      'EN': 'SENDING GPS COORDINATES',
      'KH': 'កំពុងផ្ញើកូអរដោនេ GPS',
    },
    'EMERGENCY SERVICES': {
      'EN': 'EMERGENCY SERVICES',
      'KH': 'សេវាសង្គ្រោះបន្ទាន់',
    },
    'CANCEL SOS': {
      'EN': 'CANCEL SOS',
      'KH': 'បោះបង់ SOS',
    },
    'SOS ALARM SENT': {
      'EN': 'SOS ALARM SENT',
      'KH': 'សំឡេងអាសន្ន SOS ត្រូវបានផ្ញើ',
    },
    'Dialing dispatch at Calmette Emergency Care (+855 23 218 878) and routing response vehicle.': {
      'EN': 'Dialing dispatch at Calmette Emergency Care (+855 23 218 878) and routing response vehicle.',
      'KH': 'កំពុងហៅទូរស័ព្ទទៅផ្នែកសង្គ្រោះបន្ទាន់កាល់ម៉ែត (+៨៥៥ ២៣ ២១៨ ៨៧៨) និងបញ្ជូនឡានសង្គ្រោះ។',
    },
    'Mock dispatch status: Ambulance en-route (ETA: 4 mins). Stay where you are.': {
      'EN': 'Mock dispatch status: Ambulance en-route (ETA: 4 mins). Stay where you are.',
      'KH': 'ស្ថានភាពសង្គ្រោះសាកល្បង៖ ឡានពេទ្យកំពុងធ្វើដំណើរ (រង់ចាំ ៤ នាទី)។ សូមស្នាក់នៅកន្លែងដដែល។',
    },
    'DIAL DISPATCH': {
      'EN': 'DIAL DISPATCH',
      'KH': 'ហៅទៅផ្នែកសង្គ្រោះ',
    },
    'DISMISS OVERLAY': {
      'EN': 'DISMISS OVERLAY',
      'KH': 'បិទផ្ទាំងនេះ',
    },
    'Get started': {
      'EN': 'Get started',
      'KH': 'ចាប់ផ្តើម',
    },
    'Next': {
      'EN': 'Next',
      'KH': 'បន្ទាប់',
    },
    'Skip': {
      'EN': 'Skip',
      'KH': 'រំលង',
    },
    'Instant Emergency Help': {
      'EN': 'Instant Emergency Help',
      'KH': 'ជំនួយសង្គ្រោះបន្ទាន់ភ្លាមៗ',
    },
    'Find the nearest police, hospital, fire station, or ambulance in seconds.': {
      'EN': 'Find the nearest police, hospital, fire station, or ambulance in seconds.',
      'KH': 'ស្វែងរកប៉ូលីស មន្ទីរពេទ្យ ស្ថានីយពន្លត់អគ្គីភ័យ ឬឡានពេទ្យដែលនៅជិតបំផុតក្នុងរយៈពេលប៉ុន្មានវិនាទី។',
    },
    'One-Tap SOS': {
      'EN': 'One-Tap SOS',
      'KH': 'ចុច SOS តែម្តងគត់',
    },
    'Hit the big SOS button to quickly access critical contacts.': {
      'EN': 'Hit the big SOS button to quickly access critical contacts.',
      'KH': 'ចុចប៊ុង SOS ធំ ដើម្បីចូលទៅកាន់ទំនាក់ទំនងសំខាន់ៗបានយ៉ាងរហ័ស។',
    },
    'Preparedness Tips': {
      'EN': 'Preparedness Tips',
      'KH': 'គន្លឹះនៃការត្រៀមខ្លួន',
    },
    'Learn first-aid steps and store personal emergency contacts.': {
      'EN': 'Learn first-aid steps and store personal emergency contacts.',
      'KH': 'ស្វែងយល់ពីជំហានសង្គ្រោះបឋម និងរក្សាទុកទំនាក់ទំនងអាសន្នផ្ទាល់ខ្លួន។',
    },
    'Open now': {
      'EN': 'Open now',
      'KH': 'បើកទ្វារឥឡូវនេះ',
    },
    '≤ 3 km': {
      'EN': '≤ 3 km',
      'KH': '≤ ៣ គីឡូម៉ែត្រ',
    },
    '4.5+ rating': {
      'EN': '4.5+ rating',
      'KH': 'ការវាយតម្លៃ ៤.៥ឡើង',
    },
    'Nearby services': {
      'EN': 'Nearby Services',
      'KH': 'សេវាកម្មនៅជិតៗ',
    },
    'No nearby services': {
      'EN': 'No nearby services',
      'KH': 'មិនមានសេវាកម្មនៅជិតៗទេ',
    },
    'Adjust filters to see more results.': {
      'EN': 'Adjust filters to see more results.',
      'KH': 'កែតម្រូវតម្រងដើម្បីមើលលទ្ធផលបន្ថែម។',
    },
    'Save Contact': {
      'EN': 'Save Contact',
      'KH': 'រក្សាទុកទំនាក់ទំនង',
    },
    'Update Contact': {
      'EN': 'Update Contact',
      'KH': 'ធ្វើបច្ចុប្បន្នភាពទំនាក់ទំនង',
    },
    'Phone Number': {
      'EN': 'Phone Number',
      'KH': 'លេខទូរស័ព្ទ',
    },
    'Hospital': {
      'EN': 'Hospital',
      'KH': 'មន្ទីរពេទ្យ',
    },
    'Police': {
      'EN': 'Police',
      'KH': 'ប៉ូលីស',
    },
    'Fire Station': {
      'EN': 'Fire Station',
      'KH': 'ពន្លត់អគ្គីភ័យ',
    },
    'Ambulance': {
      'EN': 'Ambulance',
      'KH': 'ឡានសង្គ្រោះបន្ទាន់',
    },
    'Women Support': {
      'EN': 'Women Support',
      'KH': 'ជំនួយស្ត្រី',
    },
    'Disaster Relief': {
      'EN': 'Disaster Relief',
      'KH': 'សង្គ្រោះគ្រោះមហន្តរាយ',
    },
    'hospital': {
      'EN': 'Hospital',
      'KH': 'មន្ទីរពេទ្យ',
    },
    'police': {
      'EN': 'Police',
      'KH': 'ប៉ូលីស',
    },
    'fire': {
      'EN': 'Fire Station',
      'KH': 'ពន្លត់អគ្គីភ័យ',
    },
    'ambulance': {
      'EN': 'Ambulance',
      'KH': 'ឡានសង្គ្រោះបន្ទាន់',
    },
    'women': {
      'EN': 'Women Support',
      'KH': 'ជំនួយស្ត្រី',
    },
    'disaster': {
      'EN': 'Disaster Relief',
      'KH': 'សង្គ្រោះគ្រោះមហន្តរាយ',
    },
    'Hospitals': {
      'EN': 'Hospitals',
      'KH': 'មន្ទីរពេទ្យ',
    },
    'Police Stations': {
      'EN': 'Police Stations',
      'KH': 'ប៉ូលីស',
    },
    'Fire Stations': {
      'EN': 'Fire Stations',
      'KH': 'ពន្លត់អគ្គីភ័យ',
    },
    'Ambulances': {
      'EN': 'Ambulances',
      'KH': 'ឡានសង្គ្រោះបន្ទាន់',
    },
    'Women Help': {
      'EN': 'Women Help',
      'KH': 'ជំនួយស្ត្រី',
    },
    'Disaster': {
      'EN': 'Disaster',
      'KH': 'គ្រោះមហន្តរាយ',
    },
    'English': {
      'EN': 'English',
      'KH': 'អង់គ្លេស',
    },
    'Khmer': {
      'EN': 'Khmer',
      'KH': 'ខ្មែរ',
    },
    'e.g. A+, O-': {
      'EN': 'e.g. A+, O-',
      'KH': 'ឧ. A+, O-',
    },
    'List any allergies': {
      'EN': 'List any allergies',
      'KH': 'រៀបរាប់ពីប្រតិកម្មអាឡែស៊ី',
    },
    'Unable to load favorites': {
      'EN': 'Unable to load favorites',
      'KH': 'មិនអាចផ្ទុកសំណព្វបានទេ',
    },
    'Please try again.': {
      'EN': 'Please try again.',
      'KH': 'សូមព្យាយាមម្តងទៀត។',
    },
    'No favorites saved': {
      'EN': 'No favorites saved',
      'KH': 'មិនទាន់មានសំណព្វត្រូវបានរក្សាទុកទេ',
    },
    'Tap the heart icon to save emergency services.': {
      'EN': 'Tap the heart icon to save emergency services.',
      'KH': 'ចុចលើរូបបេះដូងដើម្បីរក្សាទុកសេវាសង្គ្រោះបន្ទាន់។',
    },
    'Unable to load tips': {
      'EN': 'Unable to load tips',
      'KH': 'មិនអាចផ្ទុកគន្លឹះសង្គ្រោះបឋមបានទេ',
    },
    'Please try again later.': {
      'EN': 'Please try again later.',
      'KH': 'សូមព្យាយាមម្តងទៀតនៅពេលក្រោយ។',
    },
    'No tips available': {
      'EN': 'No tips available',
      'KH': 'មិនមានគន្លឹះសង្គ្រោះបឋមទេ',
    },
    'Please check back later for first-aid guidance.': {
      'EN': 'Please check back later for first-aid guidance.',
      'KH': 'សូមពិនិត្យមើលឡើងវិញនៅពេលក្រោយសម្រាប់ព័ត៌មានណែនាំសង្គ្រោះបឋម។',
    },
    'CPR': {
      'EN': 'CPR',
      'KH': 'សង្គ្រោះបេះដូង (CPR)',
    },
    'Keep blood flowing until help arrives.': {
      'EN': 'Keep blood flowing until help arrives.',
      'KH': 'រក្សាលំហូរឈាមរហូតដល់ជំនួយមកដល់។',
    },
    'Check responsiveness and call emergency services.': {
      'EN': 'Check responsiveness and call emergency services.',
      'KH': 'ពិនិត្យមើលការឆ្លើយតប និងហៅទូរស័ព្ទទៅសេវាសង្គ្រោះបន្ទាន់។',
    },
    'Place hands at the center of the chest.': {
      'EN': 'Place hands at the center of the chest.',
      'KH': 'ដាក់ដៃនៅចំកណ្តាលទ្រូង។',
    },
    'Push hard and fast at 100-120 compressions per minute.': {
      'EN': 'Push hard and fast at 100-120 compressions per minute.',
      'KH': 'សង្កត់ឱ្យខ្លាំង និងលឿនពី ១០០ ទៅ ១២០ ដងក្នុងមួយនាទី។',
    },
    'Continue until help arrives or the person recovers.': {
      'EN': 'Continue until help arrives or the person recovers.',
      'KH': 'បន្តរហូតដល់ជំនួយមកដល់ ឬអ្នកជំងឺដឹងខ្លួនឡើងវិញ។',
    },
    'Burns': {
      'EN': 'Burns',
      'KH': 'រលាកភ្លើង',
    },
    'Cool the burn and protect the skin.': {
      'EN': 'Cool the burn and protect the skin.',
      'KH': 'ធ្វើឱ្យកន្លែងរលាកត្រជាក់ និងការពារស្បែក។',
    },
    'Remove the source of heat.': {
      'EN': 'Remove the source of heat.',
      'KH': 'យកប្រភពកំដៅចេញ។',
    },
    'Cool the burn under running water for 10 minutes.': {
      'EN': 'Cool the burn under running water for 10 minutes.',
      'KH': 'លាងសម្អាតកន្លែងរលាកក្រោមទឹកហូររយៈពេល ១០ នាទី។',
    },
    'Cover with a clean, non-stick cloth.': {
      'EN': 'Cover with a clean, non-stick cloth.',
      'KH': 'គ្របដោយក្រណាត់ស្អាត និងមិនស្អិត។',
    },
    'Seek medical care for severe burns.': {
      'EN': 'Seek medical care for severe burns.',
      'KH': 'ស្វែងរកការថែទាំវេជ្ជសាស្ត្រសម្រាប់ការរលាកធ្ងន់ធ្ងរ។',
    },
    'Bleeding': {
      'EN': 'Bleeding',
      'KH': 'ហូរឈាម',
    },
    'Stop the bleeding and prevent shock.': {
      'EN': 'Stop the bleeding and prevent shock.',
      'KH': 'បញ្ឈប់ការហូរឈាម និងការពារការខ្យល់គរ។',
    },
    'Apply direct pressure with a clean cloth.': {
      'EN': 'Apply direct pressure with a clean cloth.',
      'KH': 'សង្កត់ដោយផ្ទាល់ដោយប្រើក្រណាត់ស្អាត។',
    },
    'Keep the injured area elevated if possible.': {
      'EN': 'Keep the injured area elevated if possible.',
      'KH': 'លើកកន្លែងរបួសឱ្យខ្ពស់ប្រសិនបើអាចធ្វើទៅបាន។',
    },
    'Maintain pressure until bleeding stops.': {
      'EN': 'Maintain pressure until bleeding stops.',
      'KH': 'រក្សាសម្ពាធសង្កត់រហូតដល់ឈាមឈប់ហូរ។',
    },
    'Call for emergency help if bleeding is severe.': {
      'EN': 'Call for emergency help if bleeding is severe.',
      'KH': 'ហៅរកជំនួយសង្គ្រោះបន្ទាន់ប្រសិនបើឈាមហូរខ្លាំង។',
    },
    'Snake Bite': {
      'EN': 'Snake Bite',
      'KH': 'ពស់ចឹក',
    },
    'Stay calm and reduce movement.': {
      'EN': 'Stay calm and reduce movement.',
      'KH': 'រក្សាភាពស្ងប់ស្ងាត់ និងកាត់បន្ថយការផ្លាស់ទី។',
    },
    'Keep the person calm and still.': {
      'EN': 'Keep the person calm and still.',
      'KH': 'ធ្វើឱ្យអ្នករងគ្រោះស្ងប់ស្ងាត់ និងមិនធ្វើចលនា។',
    },
    'Position the bite below heart level.': {
      'EN': 'Position the bite below heart level.',
      'KH': 'ដាក់ទីតាំងរបួសចឹកឱ្យទាបជាងកម្រិតបេះដូង។',
    },
    'Remove tight items like rings or watches.': {
      'EN': 'Remove tight items like rings or watches.',
      'KH': 'ដោះរបស់របរដែលតឹងៗដូចជាចិញ្ចៀន ឬនាឡិកាចេញ។',
    },
    'Seek emergency medical help immediately.': {
      'EN': 'Seek emergency medical help immediately.',
      'KH': 'ស្វែងរកជំនួយវេជ្ជសាស្ត្របន្ទាន់ជាបន្ទាន់។',
    },
    'Choking': {
      'EN': 'Choking',
      'KH': 'ស្លាក់',
    },
    'Clear the airway quickly.': {
      'EN': 'Clear the airway quickly.',
      'KH': 'សម្អាតផ្លូវដង្ហើមឱ្យបានលឿន។',
    },
    'Encourage coughing if the person can breathe.': {
      'EN': 'Encourage coughing if the person can breathe.',
      'KH': 'លើកទឹកចិត្តឱ្យក្អកប្រសិនបើអ្នកជំងឺអាចដកដង្ហើមបាន។',
    },
    'Give 5 back blows between the shoulder blades.': {
      'EN': 'Give 5 back blows between the shoulder blades.',
      'KH': 'ទះខ្នង ៥ ដងនៅចន្លោះឆ្អឹងស្លាបប្រចៀវ។',
    },
    'Perform abdominal thrusts if needed.': {
      'EN': 'Perform abdominal thrusts if needed.',
      'KH': 'ធ្វើការសង្កត់ពោះ (Abdominal thrusts) ប្រសិនបើចាំបាច់។',
    },
    'Call emergency services if obstruction remains.': {
      'EN': 'Call emergency services if obstruction remains.',
      'KH': 'ហៅទូរស័ព្ទទៅសេវាសង្គ្រោះបន្ទាន់ប្រសិនបើនៅតែស្លាក់។',
    },
    'SAVE CONTACT': {
      'EN': 'SAVE CONTACT',
      'KH': 'រក្សាទុកទំនាក់ទំនង',
    },
    'UPDATE CONTACT': {
      'EN': 'UPDATE CONTACT',
      'KH': 'ធ្វើបច្ចុប្បន្នភាពទំនាក់ទំនង',
    },
    'Name and phone are required.': {
      'EN': 'Name and phone are required.',
      'KH': 'ឈ្មោះ និងលេខទូរស័ព្ទគឺចាំបាច់ត្រូវបំពេញ។',
    },
    'Contact': {
      'EN': 'Contact',
      'KH': 'ទំនាក់ទំនង',
    },
    'Emergency Map': {
      'EN': 'Emergency Map',
      'KH': 'ផែនទីសង្គ្រោះបន្ទាន់',
    },
    'Unable to load map': {
      'EN': 'Unable to load map',
      'KH': 'មិនអាចផ្ទុកផែនទីបានទេ',
    },
    'CALL': {
      'EN': 'CALL',
      'KH': 'ហៅទូរស័ព្ទ',
    },
    'DIRECTIONS': {
      'EN': 'DIRECTIONS',
      'KH': 'ទិសដៅ',
    },
    'Fire': {
      'EN': 'Fire',
      'KH': 'ពន្លត់អគ្គីភ័យ',
    },
    'Calmette Hospital': {
      'EN': 'Calmette Hospital',
      'KH': 'មន្ទីរពេទ្យកាល់ម៉ែត',
    },
    'Royal Phnom Penh Hospital': {
      'EN': 'Royal Phnom Penh Hospital',
      'KH': 'មន្ទីរពេទ្យរ៉ូយ៉ាល់ភ្នំពេញ',
    },
    'Phnom Penh Municipal Police': {
      'EN': 'Phnom Penh Municipal Police',
      'KH': 'ស្នងការដ្ឋាននគរបាលរាជធានីភ្នំពេញ',
    },
    'BKK1 Police Post': {
      'EN': 'BKK1 Police Post',
      'KH': 'ប៉ុស្តិ៍នគរបាលរដ្ឋបាលបឹងកេងកងទី១',
    },
    'Phnom Penh Fire Department HQ': {
      'EN': 'Phnom Penh Fire Department HQ',
      'KH': 'ទីស្នាក់ការកណ្តាលពន្លត់អគ្គីភ័យភ្នំពេញ',
    },
    'Toul Kork Fire Station': {
      'EN': 'Toul Kork Fire Station',
      'KH': 'ស្ថានីយពន្លត់អគ្គីភ័យទួលគោក',
    },
    'National Emergency Ambulance': {
      'EN': 'National Emergency Ambulance',
      'KH': 'រថយន្តសង្គ្រោះបន្ទាន់ជាតិ',
    },
    'City Ambulance Response': {
      'EN': 'City Ambulance Response',
      'KH': 'សេវារថយន្តសង្គ្រោះបន្ទាន់ទីក្រុង',
    },
    'Women\'s Helpline Cambodia': {
      'EN': 'Women\'s Helpline Cambodia',
      'KH': 'ខ្សែទូរស័ព្ទជំនួយស្ត្រីកម្ពុជា',
    },
    'Safe Shelter Hotline': {
      'EN': 'Safe Shelter Hotline',
      'KH': 'ខ្សែទូរស័ព្ទជម្រកសុវត្ថិភាព',
    },
    'National Disaster Relief Center': {
      'EN': 'National Disaster Relief Center',
      'KH': 'គណៈកម្មាធិការជាតិគ្រប់គ្រងគ្រោះមហន្តរាយ',
    },
    'Rapid Relief Team': {
      'EN': 'Rapid Relief Team',
      'KH': 'ក្រុមសង្គ្រោះបន្ទាន់រហ័ស',
    },
    'Monivong Blvd, Phnom Penh': {
      'EN': 'Monivong Blvd, Phnom Penh',
      'KH': 'មហាវិថីព្រះមុនីវង្ស ភ្នំពេញ',
    },
    'Russian Federation Blvd, Phnom Penh': {
      'EN': 'Russian Federation Blvd, Phnom Penh',
      'KH': 'មហាវិថីសហព័ន្ធរុស្ស៊ី ភ្នំពេញ',
    },
    'Street 132, Phnom Penh': {
      'EN': 'Street 132, Phnom Penh',
      'KH': 'ផ្លូវលេខ ១៣២ ភ្នំពេញ',
    },
    'Street 360, BKK1': {
      'EN': 'Street 360, BKK1',
      'KH': 'ផ្លូវលេខ ៣៦០ បឹងកេងកងទី១',
    },
    'Street 134, Phnom Penh': {
      'EN': 'Street 134, Phnom Penh',
      'KH': 'ផ្លូវលេខ ១៣៤ ភ្នំពេញ',
    },
    'Street 315, Toul Kork': {
      'EN': 'Street 315, Toul Kork',
      'KH': 'ផ្លូវលេខ ៣១៥ ទួលគោក',
    },
    'Street 118, Phnom Penh': {
      'EN': 'Street 118, Phnom Penh',
      'KH': 'ផ្លូវលេខ ១១៨ ភ្នំពេញ',
    },
    'Street 271, Phnom Penh': {
      'EN': 'Street 271, Phnom Penh',
      'KH': 'ផ្លូវលេខ ២៧១ ភ្នំពេញ',
    },
    'Street 68, Phnom Penh': {
      'EN': 'Street 68, Phnom Penh',
      'KH': 'ផ្លូវលេខ ៦៨ ភ្នំពេញ',
    },
    'Street 95, Phnom Penh': {
      'EN': 'Street 95, Phnom Penh',
      'KH': 'ផ្លូវលេខ ៩៥ ភ្នំពេញ',
    },
    'Street 386, Phnom Penh': {
      'EN': 'Street 386, Phnom Penh',
      'KH': 'ផ្លូវលេខ ៣៨៦ ភ្នំពេញ',
    },
    'Street 502, Phnom Penh': {
      'EN': 'Street 502, Phnom Penh',
      'KH': 'ផ្លូវលេខ ៥០២ ភ្នំពេញ',
    },
    'Unable to load nearby': {
      'EN': 'Unable to load nearby',
      'KH': 'មិនអាចផ្ទុកសេវាកម្មនៅជិតៗបានទេ',
    },
    'Police nearby': {
      'EN': 'Police nearby',
      'KH': 'ប៉ូលីសនៅជិតៗ',
    },
    'Hospital nearby': {
      'EN': 'Hospital nearby',
      'KH': 'មន្ទីរពេទ្យនៅជិតៗ',
    },
    'Fire nearby': {
      'EN': 'Fire nearby',
      'KH': 'ពន្លត់អគ្គីភ័យនៅជិតៗ',
    },
    'Ambulance nearby': {
      'EN': 'Ambulance nearby',
      'KH': 'ឡានសង្គ្រោះបន្ទាន់នៅជិតៗ',
    },
    'Women Help nearby': {
      'EN': 'Women Help nearby',
      'KH': 'ជំនួយស្ត្រីនៅជិតៗ',
    },
    'Disaster Relief nearby': {
      'EN': 'Disaster Relief nearby',
      'KH': 'សង្គ្រោះគ្រោះមហន្តរាយនៅជិតៗ',
    },
    'No Police services': {
      'EN': 'No Police services',
      'KH': 'មិនមានសេវាប៉ូលីសទេ',
    },
    'No Hospital services': {
      'EN': 'No Hospital services',
      'KH': 'មិនមានសេវាមន្ទីរពេទ្យទេ',
    },
    'No Fire services': {
      'EN': 'No Fire services',
      'KH': 'មិនមានសេវាពន្លត់អគ្គីភ័យទេ',
    },
    'No Ambulance services': {
      'EN': 'No Ambulance services',
      'KH': 'មិនមានសេវារថយន្តសង្គ្រោះទេ',
    },
    'No Women Help services': {
      'EN': 'No Women Help services',
      'KH': 'មិនមានសេវាជំនួយស្ត្រីទេ',
    },
    'No Disaster Relief services': {
      'EN': 'No Disaster Relief services',
      'KH': 'មិនមានសេវាសង្គ្រោះគ្រោះមហន្តរាយទេ',
    },
    'Try another category or check back soon.': {
      'EN': 'Try another category or check back soon.',
      'KH': 'សូមសាកល្បងប្រភេទផ្សេងទៀត ឬពិនិត្យមើលឡើងវិញក្នុងពេលឆាប់ៗ។',
    },
    'Unable to load details': {
      'EN': 'Unable to load details',
      'KH': 'មិនអាចផ្ទុកសេវាកម្មលម្អិតបានទេ',
    },
    'Service not found': {
      'EN': 'Service not found',
      'KH': 'រកមិនឃើញសេវាកម្មឡើយ',
    },
    'This emergency service is unavailable.': {
      'EN': 'This emergency service is unavailable.',
      'KH': 'សេវាកម្មសង្គ្រោះបន្ទាន់នេះមិនអាចប្រើប្រាស់បានទេ។',
    },
    'reviews': {
      'EN': 'reviews',
      'KH': 'ការវាយតម្លៃ',
    },
    'review': {
      'EN': 'review',
      'KH': 'ការវាយតម្លៃ',
    },
    'Removed from favorites': {
      'EN': 'Removed from favorites',
      'KH': 'បានលុបចេញពីបញ្ជីសំណព្វ',
    },
    'Saved to favorites': {
      'EN': 'Saved to favorites',
      'KH': 'បានរក្សាទុកក្នុងបញ្ជីសំណព្វ',
    },
    'National Road 1, Phnom Penh': {
      'EN': 'National Road 1, Phnom Penh',
      'KH': 'ផ្លូវជាតិលេខ ១ ភ្នំពេញ',
    },
    'Street 2010, Phnom Penh': {
      'EN': 'Street 2010, Phnom Penh',
      'KH': 'ផ្លូវលេខ ២០១០ ភ្នំពេញ',
    },
    'Central emergency hospital with trauma and ICU services.': {
      'EN': 'Central emergency hospital with trauma and ICU services.',
      'KH': 'មន្ទីរពេទ្យសង្គ្រោះបន្ទាន់កណ្តាលដែលមានសេវាកម្មព្យាបាលរបួសធ្ងន់ធ្ងរ និង ICU។',
    },
    'Major public hospital with surgery and emergency care.': {
      'EN': 'Major public hospital with surgery and emergency care.',
      'KH': 'មន្ទីរពេទ្យសាធារណៈធំមួយដែលមានសេវាវះកាត់ និងសង្គ្រោះបន្ទាន់។',
    },
    'Modern emergency facility with pediatric support.': {
      'EN': 'Modern emergency facility with pediatric support.',
      'KH': 'កន្លែងសង្គ្រោះបន្ទាន់ទំនើបជាមួយសេវាគាំទ្រកុមារ។',
    },
    'Private hospital with advanced emergency response.': {
      'EN': 'Private hospital with advanced emergency response.',
      'KH': 'មន្ទីរពេទ្យឯកជនដែលមានសេវាឆ្លើយតបគ្រោះអាសន្នជឿនលឿន។',
    },
    'Emergency and critical care with Japanese standards.': {
      'EN': 'Emergency and critical care with Japanese standards.',
      'KH': 'ការថែទាំសង្គ្រោះបន្ទាន់ និងសង្គ្រោះបន្ទាន់កម្រិតធ្ងន់ស្របតាមស្តង់ដារជប៉ុន។',
    },
    'Urgent care clinic with extended hours.': {
      'EN': 'Urgent care clinic with extended hours.',
      'KH': 'គ្លីនិកថែទាំបន្ទាន់ដែលមានម៉ោងធ្វើការបន្ថែម។',
    },
    'Community clinic offering urgent care and labs.': {
      'EN': 'Community clinic offering urgent care and labs.',
      'KH': 'គ្លីនិកសហគមន៍ផ្តល់ជូនការថែទាំបន្ទាន់ និងមន្ទីរពិសោធន៍។',
    },
    'Teaching hospital with 24-hour emergency services.': {
      'EN': 'Teaching hospital with 24-hour emergency services.',
      'KH': 'មន្ទីរពេទ្យសាកលវិទ្យាល័យបង្រៀនដែលមានសេវាសង្គ្រោះបន្ទាន់ ២៤ ម៉ោង។',
    },
    'Primary police headquarters for city-wide response.': {
      'EN': 'Primary police headquarters for city-wide response.',
      'KH': 'ស្នងការដ្ឋាននគរបាលចម្បងសម្រាប់ការឆ្លើយតបទូទាំងទីក្រុង។',
    },
    'Local police post serving BKK1 neighborhood.': {
      'EN': 'Local police post serving BKK1 neighborhood.',
      'KH': 'ប៉ុស្តិ៍នគរបាលមូលដ្ឋានបម្រើតំបន់បឹងកេងកងទី១។',
    },
    'Rapid response police post for Toul Kork.': {
      'EN': 'Rapid response police post for Toul Kork.',
      'KH': 'ប៉ុស្តិ៍នគរបាលឆ្លើយតបរហ័សសម្រាប់តំបន់ទួលគោក។',
    },
    'Police station covering Sen Sok district.': {
      'EN': 'Police station covering Sen Sok district.',
      'KH': 'អធិការដ្ឋាននគរបាលគ្របដណ្តប់ខណ្ឌសែនសុខ។',
    },
    'Police post for Chbar Ampov area.': {
      'EN': 'Police post for Chbar Ampov area.',
      'KH': 'ប៉ុស្តិ៍នគរបាលសម្រាប់តំបន់ច្បារអំពៅ។',
    },
    'Emergency response post for Dangkor.': {
      'EN': 'Emergency response post for Dangkor.',
      'KH': 'ប៉ុស្តិ៍ឆ្លើយតបគ្រោះអាសន្នសម្រាប់តំបន់ដង្កោ។',
    },
    'Main fire response headquarters.': {
      'EN': 'Main fire response headquarters.',
      'KH': 'ទីស្នាក់ការកណ្តាលពន្លត់អគ្គីភ័យចម្បង។',
    },
    'Fire station serving Toul Kork.': {
      'EN': 'Fire station serving Toul Kork.',
      'KH': 'ស្ថានីយពន្លត់អគ្គីភ័យបម្រើតំបន់ទួលគោក។',
    },
    'Fire station covering Sen Sok.': {
      'EN': 'Fire station covering Sen Sok.',
      'KH': 'ស្ថានីយពន្លត់អគ្គីភ័យគ្របដណ្តប់តំបន់សែនសុខ។',
    },
    'Fire station for Chbar Ampov area.': {
      'EN': 'Fire station for Chbar Ampov area.',
      'KH': 'ស្ថានីយពន្លត់អគ្គីភ័យសម្រាប់តំបន់ច្បារអំពៅ។',
    },
    'Citywide ambulance dispatch center.': {
      'EN': 'Citywide ambulance dispatch center.',
      'KH': 'មជ្ឈមណ្ឌលបញ្ជូនរថយន្តសង្គ្រោះបន្ទាន់ទូទាំងទីក្រុង។',
    },
    'Rapid ambulance response with paramedic teams.': {
      'EN': 'Rapid ambulance response with paramedic teams.',
      'KH': 'ការឆ្លើយតបរថយន្តសង្គ្រោះបន្ទាន់រហ័សជាមួយក្រុមគ្រូពេទ្យជំនាញ។',
    },
    'Ambulance unit stationed near the riverside.': {
      'EN': 'Ambulance unit stationed near the riverside.',
      'KH': 'អង្គភាពរថយន្តសង្គ្រោះបន្ទាន់ប្រចាំការនៅជិតមាត់ទន្លេ។',
    },
    'Emergency response unit serving the airport.': {
      'EN': 'Emergency response unit serving the airport.',
      'KH': 'អង្គភាពឆ្លើយតបគ្រោះអាសន្នបម្រើការនៅព្រលានយន្តហោះ។',
    },
    '24/7 hotline for women in crisis.': {
      'EN': '24/7 hotline for women in crisis.',
      'KH': 'ខ្សែទូរស័ព្ទជំនួយ ២៤/៧ សម្រាប់ស្ត្រីជួបវិបត្តិ។',
    },
    'Hotline with shelter referrals and legal guidance.': {
      'EN': 'Hotline with shelter referrals and legal guidance.',
      'KH': 'ខ្សែទូរស័ព្ទជំនួយជាមួយការបញ្ជូនទៅជម្រកសុវត្ថិភាព និងការណែនាំផ្លូវច្បាប់។',
    },
    'Crisis center offering counseling and shelter.': {
      'EN': 'Crisis center offering counseling and shelter.',
      'KH': 'មជ្ឈមណ្ឌលវិបត្តិផ្តល់ជូនការប្រឹក្សាយោបល់ និងជម្រកសុវត្ថិភាព។',
    },
    'Support desk for gender-based violence reporting.': {
      'EN': 'Support desk for gender-based violence reporting.',
      'KH': 'តុគាំទ្រសម្រាប់ការរាយការណ៍អំពីអំពើហិង្សាលើស្ត្រី។',
    },
    'Central relief coordination for disasters.': {
      'EN': 'Central relief coordination for disasters.',
      'KH': 'សម្របសម្រួលសង្គ្រោះកណ្តាលសម្រាប់គ្រោះមហន្តរាយ។',
    },
    'Specialized unit for flood emergencies.': {
      'EN': 'Specialized unit for flood emergencies.',
      'KH': 'អង្គភាពជំនាញសម្រាប់គ្រោះអាសន្នទឹកជំនន់។',
    },
    'Emergency shelter with medical support.': {
      'EN': 'Emergency shelter with medical support.',
      'KH': 'ជម្រកសង្គ្រោះបន្ទាន់ដែលមានការគាំទ្រផ្នែកវេជ្ជសាស្ត្រ។',
    },
    'Rapid deployment relief team with supplies.': {
      'EN': 'Rapid deployment relief team with supplies.',
      'KH': 'ក្រុមការងារសង្គ្រោះរហ័សជាមួយការផ្គត់ផ្គង់គ្រឿងឧបភោគបរិភោគ។',
    },
    'Unable to open external app.': {
      'EN': 'Unable to open external app.',
      'KH': 'មិនអាចបើកកម្មវិធីខាងក្រៅបានទេ។',
    },
  };

  static String get(String key, String language) {
    final Map<String, String>? translations = _localizedValues[key];
    if (translations != null) {
      return translations[language] ?? key;
    }
    return key;
  }
}
