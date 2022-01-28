import 'dart:io';
import 'dart:convert';

void main(List<String> args) async {
  String JambRegNumber;
  List<String?> choosenSubjects = ['', '', '', ''];
  List<String> scores = ['0', '0', '0', '0'];
  print('\n\n\n\n'
      '===>WELCOME TO JAMB RESULT FORMATTER!<===\n\n\n'
      'Please fill in your details carefully as wrong details would lead to a wrong result\n\n');
  if (confirm()) {
    String JambRegNo = regNoVerification();
    if (JambRegNo == '*#00019~#')
      exitprogram();
    else {
      JambRegNumber = JambRegNo;
      jambSubjects();
      stdout.write(
          '\nPlease input in the subject\'s code\n\n');
      for (var i = 0; i <= 3; i++) {
        stdout.write('Subject ${i + 1} ');
        String? nullEnteredSubject = stdin.readLineSync();
        String enteredSubject =
            verifiedSubject(nullEnteredSubject!, choosenSubjects);
        if (enteredSubject == '') {
          stdout.write('\nPlease enter a Subject code!!!');
          i--;
          continue;
        } else if (enteredSubject == '*#000015#') {
          stdout.write('\nIncorrect Subject Code! Enter a valid one!!!');
          i--;
          continue;
        } else if (enteredSubject == '00000') {
          stdout.write('\nAlready Choosen! Enter a new one!!!');
          i--;
          continue;
        } else {
          choosenSubjects[i] = enteredSubject;
          stdout.write('\nEnter Score from 0 — 100  ');
          String? nullScore = stdin.readLineSync();
          String score = nullScore!;
          scores[i] = scoreCheck(score);
        }
      }
    }
    print(JambRegNo);
    for (var i = 0; i < 3; i++) {
      stdout.write('Subject \'${choosenSubjects[i]}\' Score \'${scores[i]}\' ');
    }
  } else
    exitprogram();
}

void exitprogram() {
  print('\n\n\n\THANK YOU FOR YOUR RESPONSE!!! SEE YOU ANOTHER TIME!!');
  exit(0);
}

String scoreCheck(String score) {
  while (true) {
    try {
      int scr = int.parse(score);
      if (scr > 100) {
        stdout.write('\nPlease Enter Score between 1 - 100 ');
        String? nullscore = stdin.readLineSync();
        score = nullscore!;
        continue;
      } else {
        score = scr.toString();
        return score;
      }
    } catch (err) {
      stdout.write('\nInvalid Score!! Enter a valid score ');
      String? nullscore = stdin.readLineSync();
      score = nullscore!;
      continue;
    }
  }
}

String regNoVerification() {
  String jambRegNo;
  stdout.write('''\n\n
NOTE: Your Jamb Registration number must be 10 characters long with the
      first 8 characters as numbers and the remaining two as letters.
      Anything other than this will not allowed!!!\n\n''');
  stdout.write(
      '\nPlease enter a valid JAMB registration Number (Or press \'C\' to cancle):  ');
  while (true) {
    String? regNo = stdin.readLineSync();
    String regno = regNo!;
    if (regno == 'c' || regno == 'C') {
      return '*#00019~#';
    } else if ((regno.isNotEmpty) && (regno.runes.length == 10)) {
      regno = regno.toUpperCase();
      if (regNoValidation(regno)) {
        jambRegNo = regno;
        break;
      } else {
        stdout.write(
            '\nInvalid Registration Number!!! Try again!!! (Or press \'C\' to cancle)  ');
        continue;
      }
    } else {
      stdout.write(
          '\nInvalid Registration Number!!! Try again!!! (Or press \'C\' to cancle)  ');
      continue;
    }
  }
  stdout.write('\nYour Registration Number is $jambRegNo \n');
  return jambRegNo;
}

bool regNoValidation(String regno) {
  bool value = false;
  for (var i = 0; i <= 9; i++) {
    if ((i <= 7) && isNumber(regno[i])) {
      value = true;
      continue;
    } else if ((i >= 8) && isAlphabet(regno[i])) {
      value = true;
      continue;
    } else {
      value = false;
      break;
    }
  }
  return value;
}

String capitalize(String string) {
  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}

bool confirm() {
  stdout.write('\nWould you like to continue YES(Y) / NO (N) ');
  while (true) {
    String? answer = stdin.readLineSync();
    if (answer == 'Y' || answer == 'y')
      return true;
    else if (answer == 'N' || answer == 'n')
      return false;
    else {
      stdout.write('\nPlease enter a valid response ');
      continue;
    }
  }
}

bool isNumber(String numba) {
  List<int> numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  bool value = false;
  for (var no in numbers) {
    try {
      int number = int.parse(numba);
      if (no == number) {
        value = true;
        break;
      }
    } catch (err) {
      return value;
    }
  }
  return value;
}

void jambSubjects() {
  print(
      '''\n\nLIST OF AVAILABLE JAMB SUBJECTS AND THEIR SUBJECT CODE (please select any four subject combination code)
—————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
| Accounting - (ACCT)           | Agricultural Science - (AGRIC)      | Applied Mathematics - (AMATH) | Biology - (BIO)            | Botany - (BOT)                         |
|                               |                                     |                               |                            |                                        |
| Chemistry - (CHEM)            | Christian Religious Studies - (CRS) | Civic Education - (CIV)       | Commerce - (COM)           | Economics - (ECO)                      |
|                               |                                     |                               |                            |                                        |
| English Language - (ENG)      | Fine and Applied Arts - (ART)       | Food and Nutrition - (FNUT)   | Food Science - (FST)       | French - (FRN)                         |
|                               |                                     |                               |                            |                                        |
| Geography - (GEO)             | Geology - (GLY)                     | Government - (GOV)            | Hausa - (HAU)              | Health Science - (HET)                 |
|                               |                                     |                               |                            |                                        |
| History - (HIST)              | Hygiene - (HYG)                     | Igbo - (IGB)                  | Integrated Science - (IGT) | Islamic Religious Studies - (IRS)      |
|                               |                                     |                               |                            |                                        |
| Literature in English - (LIT) | Mathematics - (MATH)                | Music - (MUS)                 | Physics - (PHY)            | Pure and Applied Mathematics - (PMATH) |
|                               |                                     |                               |                            |                                        |
| Statistics - (STAT)           | Yoruba - (YOR)                      | Zoology - (ZOO)               |                            |                                        |
—————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————''');
}

String verifiedSubject(String subj, List choosenSubjects) {
  if (subj == '')
    return '';
  else {
    bool subValue = false;
    late String subName;
    String upperSubj = subj.toUpperCase();
    List<String> sub = [
      'ACCT',
      'CHEM',
      'ENG',
      'GEO',
      'HIST',
      'LIT',
      'STAT',
      'AGRIC',
      'CRS',
      'ART',
      'GLY',
      'HYG',
      'MATH',
      'YOR',
      'AMATH',
      'CIV',
      'FNUT',
      'GOV',
      'IGB',
      'MUS',
      'ZOO',
      'BIO',
      'COM',
      'FST',
      'HAU',
      'IGT',
      'PHY',
      'BOT',
      'ECO',
      'FRN',
      'HET',
      'IRS',
      'PMATH'
    ];
    List<String> subjects = [
      'ACCOUNTING',
      'CHEMISTRY',
      'ENGLISH',
      'GEOGRAPHY',
      'HISTORY',
      'LITERATURE IN ENGLISH',
      'STATISTICS',
      'AGRICULTURAL SCIENCE',
      'CHRISTIAN RELIGIOUS STUDIES',
      'FINE AND APPLIED ART',
      'GEOLOGY',
      'HYGIENE',
      'MATHEMATICS',
      'YORUBA',
      'APPLIED MATHEMETICS',
      'CIVIC EDUCATION',
      'FOOD AND NUTRITION',
      'GOVERNMENT',
      'IGBO',
      'MUSIC',
      'ZOOLOGY',
      'BIOLOGY',
      'COMMERCE',
      'FOOD SCIENCE',
      'HAUSA',
      'INTEGRATED SCIENCE',
      'PHYSICS',
      'BOTANY',
      'ECONOMICS',
      'FRENCH',
      'HEALTH SCIENCE',
      'ISLAMIC RELIGIOUS STUDIES',
      'PURE AND APPLIED MATHEMATICS'
    ];
    for (var i = 0; i < 32; i++) {
      if (upperSubj == sub[i]) {
        subValue = true;
        subName = subjects[i];
        break;
      }
    }
    if (subValue == false)
      return '*#000015#';
    else if (choosenSubjects.contains(subName)) {
      return '00000';
    } else
      return subName;
  }
}

bool isAlphabet(String alpha) {
  List<String> alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  bool value = false;
  for (var string in alphabet) {
    if (string == alpha) {
      value = true;
      break;
    }
  }
  return value;
}