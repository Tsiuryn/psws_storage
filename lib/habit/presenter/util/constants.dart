import 'package:intl/intl.dart';

const dbTitle = 'Habit_Database';
const dbHabitsList = 'CURRENT_HABIT_LIST';
const dbDates = 'START_DATE';

const dialogHintText = 'Введите название привычки';
final dateFormatter = DateFormat('dd-MM-yyyy');
final timeFormatter = DateFormat('HH:mm');

const dialogBtnCancel = 'Отмена';
const dialogBtnSave = 'Сохранить';
const dialogBtnOk = '👌';

const resultDialogHeightEmpty = 100.0;
const resultDialogHeightFull = 150.0;
const resultDialogEmpty = 'В этот день ничего не сделано!';
