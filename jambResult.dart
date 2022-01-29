import 'dart:io';
import 'dart:convert';

void main(List<String> args) async {
  String fullName = '';
  String JambRegNumber = '';
  List<String> choosenSubjects = ['', '', '', ''];
  List<String> scores = ['0', '0', '0', '0'];
  print('\n\n\n\n'
      '===>WELCOME TO JAMB RESULT FORMATTER!<===\n\n\n'
      'Please fill in your details carefully as wrong details would lead to a wrong result\n\n');

  ///Procede with the program if the user agree to continue or end the program
  if (confirm()) {
    //validate inputed full name and return it and store in fullName variable
    fullName = fullNameValidation();
    String JambRegNo = regNoVerification(); //Validate Reg No then return it
    //if RegNo is '*#00019~#' end program, else continue
    if (JambRegNo == '*#00019~#')
      exitprogram();
    else {
      JambRegNumber = JambRegNo; //store validated RegNo in JambRegNumber
      jambSubjects(); //Display all jamb subject and their code
      stdout.write('\nPlease input in the subject\'s code\n');
      //Loop 4 times to ask for 4 subjects and their associated score
      for (var i = 0; i <= 3; i++) {
        stdout.write('\n\nSubject ${i + 1} ');
        String? nullEnteredSubject = stdin.readLineSync();
        //Validate the user inputed subject and return a result
        String enteredSubject =
            verifiedSubject(nullEnteredSubject!, choosenSubjects);
        //if empty value is returned, ask for a value.
        if (enteredSubject == '') {
          stdout.write('\n\nPlease enter a Subject code!!!');
          i--;
          continue;
          //if '*#000015#' is returned, ask for a valid subject code
        } else if (enteredSubject == '*#000015#') {
          stdout.write('\n\nIncorrect Subject Code! Enter a valid one!!!');
          i--;
          continue;
          //if '00000' is returned, already choosen, ask for a new one
        } else if (enteredSubject == '00000') {
          stdout.write('\n\nAlready Choosen! Enter a new one!!!');
          i--;
          continue;
          //else, store the verified subject in the choosenSubjects list
        } else {
          choosenSubjects[i] = enteredSubject;
          stdout.write('\n\n$enteredSubject');
          // Enter Score
          stdout.write('   Enter Score from 0 — 100  ');
          String? nullScore = stdin.readLineSync();
          String score = nullScore!;
          //validate the score and store in the scores list accordingly
          scores[i] = scoreCheck(score);
        }
      }
    }
    //calculate the total accumulated scores
    int totalScore = calculatingScore(scores);
    //get the legth of the longest string of the choosen subject
    int length = subjectLength(choosenSubjects);
    //wait for about 3 seconds
    await processingResult();
    //print a formated output of the full name, regNo, subjects & scores, and
    //the total scores
    print('''
    FULL NAME: $fullName

    REGISTRATION NUMBER: $JambRegNumber

    Subject Taken and Associated Scores:
    ———————${'—'.padRight(length + 8, '—')}
    | 1. | ${choosenSubjects[0].padRight(length)} — ${scores[0].padLeft(3)} |
    |————|—${'—'.padRight(length + 7, '—')}|
    | 2. | ${choosenSubjects[1].padRight(length)} — ${scores[1].padLeft(3)} | 
    |————|—${'—'.padRight(length + 7, '—')}|
    | 3. | ${choosenSubjects[2].padRight(length)} — ${scores[2].padLeft(3)} | 
    |————|—${'—'.padRight(length + 7, '—')}|
    | 4. | ${choosenSubjects[3].padRight(length)} — ${scores[3].padLeft(3)} | 
    ———————${'—'.padRight(length + 8, '—')}
    ${''.padLeft(length + 15 - 29, ' ')}Cummulative Score = $totalScore / 400
    ''');
  } else
    exitprogram();
}

//A function that takes a min of 3-second to execute
Future processingResult() async {
  stdout.write('\n\nProcessing result');
  for (var i = 0; i <= 3; i++) {
    await displayDots();
    if (i == 3) break;
    stdout.write(' . ');
  }
  print('\n\n');
  return Future.delayed(Duration(seconds: 0));
}

//a function that takes 1-second to execute
Future displayDots() {
  return Future.delayed(Duration(seconds: 1));
}

//a function that ask for full name, validates it and ensure it is more than
//one name. then returns a validated full name
String fullNameValidation() {
  stdout.write('\n\nPlease Enter your full name: ');
  String? nullname = stdin.readLineSync();
  while (true) {
    String fullName = nullname!.toUpperCase();
    var splited = fullName.split(" ");
    if (splited.length >= 2)
      return fullName;
    else {
      stdout.write('\nPlease Enter more than one name ');
      nullname = stdin.readLineSync();
      continue;
    }
  }
}

//a function that receives a list of string integers and returns the total as int
int calculatingScore(List<String> scores) {
  int total = 0;
  for (var i = 0; i <= 3; i++) {
    total += int.parse(scores[i]);
  }
  return total;
}

//a function that receives a list of subjects and returns the lenght of the
// longest subject as int
int subjectLength(List<String> choosenSubject) {
  int length = 0;
  String subject;
  for (var i = 0; i <= 3; i++) {
    subject = choosenSubject[i];
    if (length < subject.length) length = subject.length;
  }
  return length;
}

//a function that displays a final message and quits the program
void exitprogram() {
  print('\n\n\n\THANK YOU FOR YOUR RESPONSE!!! SEE YOU ANOTHER TIME!!');
  exit(0);
}

// a function that receives a string score, validates it to ensure it is a number
//between 0 - 100 and returns it as string
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

//a function that validates jamb regNo to fulfill program specifications
//and returns a coded output or the validated regNo
String regNoVerification() {
  String jambRegNo;
  stdout.write('''\n\n
NOTE: Your JAMB Registration Number Should be in this format 0 1 2 3 4 5 6 7 T H
      10 Integers Immdiately Followed by Two Alphabets.\n\n''');
  stdout.write(
      '\nPlease enter a valid JAMB registration Number (Or press \'C\' to quite):  ');
  while (true) {
    String? regNo = stdin.readLineSync();
    String regno = regNo!;
    //if user pressed 'c'to quite, then return '*#00019~#', else continue
    if (regno == 'c' || regno == 'C') {
      return '*#00019~#';
      //if input is not empty and it has a length of 10
    } else if ((regno.isNotEmpty) && (regno.runes.length == 10)) {
      regno = regno.toUpperCase();
      //ensure the 10characters has first 8-numbers and last 2-alphabets
      //if so, the break the while loop
      if (regNoValidation(regno)) {
        jambRegNo = regno;
        break;
        //else print invalid regNo. Try again
      } else {
        stdout.write(
            '\nInvalid Registration Number. Try again (Or press \'C\' to quite)  ');
        continue;
      }
      //else print invalid regNo and try again
    } else {
      stdout.write(
          '\nInvalid Registration Number. Try again (Or press \'C\' to quite)  ');
      continue;
    }
  }
  //if all condition are satisfied, print regNo received and return the regNo
  stdout.write('\nJAMB Registration Number Received...');
  return jambRegNo;
}

//a function that receives regno as string and returns true if it is
//10characters with 8numbers and last 2-alphabets, else false
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

// a function that confirms if the user wants to continue and returns true if so
// else return false
bool confirm() {
  stdout.write('\nWould you like to continue YES(Y) / NO (N) ');
  while (true) {
    String? answer = stdin.readLineSync();
    if (answer == 'Y' || answer == 'y')
      return true;
    else if (answer == 'N' || answer == 'n')
      return false;
    else {
      stdout.write('\n\nPlease enter a valid response ');
      continue;
    }
  }
}

//a function that accept a string and returns true if the string is a number
//else return false
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

// a function that displays the list of available jamb subject and their code
void jambSubjects() {
  stdout.write(
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

//a function that accepts a string(subject code) and a list and ensures that
//the string is a valid subject code. it also checks if the subject of
// the subject code is not already in the list. it returns the subject if so.
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
    for (var i = 0; i <= 32; i++) {
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

// a function that accepts a string and returns true if it is an alphabet
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
