#Область ПрограммныйИнтерфейс

// Возвращает сохраненное расписание контрольной процедуры
//
// Параметры:
//  ОбъектСсылка - СправочникСсылка.КонтрольныеПроцедуры или СправочникСсылка.ВидыКонтрольныхПроцедур.
//
// Возвращаемое значение:
//  РасписаниеРегламентногоЗадания
//
Функция ПолучитьРасписание(ОбъектСсылка) Экспорт
	Возврат ОбъектСсылка.Расписание.Получить(); 
КонецФункции

// Сохраняет расписание контрольной процедуры
//
// Параметры:
//  Форма - УправляемаяФорма
//  ОбъектСсылка - СправочникСсылка.КонтрольныеПроцедуры или СправочникСсылка.ВидыКонтрольныхПроцедур.
//  АдресВременногоХранилищаРасписания - Строка
//
// Возвращаемое значение:
//  РасписаниеРегламентногоЗадания
//
Процедура СохранитьРасписание(Форма, ОбъектСсылка, АдресВременногоХранилищаРасписания) Экспорт
	Если ПустаяСтрока(АдресВременногоХранилищаРасписания) Тогда 
		// значит настройка выполнена не была и нового расписания установлено не было
		Возврат;
	КонецЕсли;	
	РасписаниеЗадания = ПолучитьИзВременногоХранилища(АдресВременногоХранилищаРасписания);
	Если РасписаниеЗадания <> Неопределено Тогда
		ОбъектСРасписанием = ОбъектСсылка.ПолучитьОбъект();
		ОбъектСРасписанием.Расписание = Новый ХранилищеЗначения(РасписаниеЗадания, Новый СжатиеДанных(9));
		ОбъектСРасписанием.Записать();
		
		Форма.Прочитать();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
