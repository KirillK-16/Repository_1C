
#Область ПрограммныйИнтерфейс

// Процедура - Открывает окно настройки расписания и сохраняет выбранное расписание 
// во временное хранилище
//
// Параметры:
//  Форма				 - УправляемаяФорма					- Форма из которой вызвана процедура.
//  ТекущееРасписание	 - РасписаниеРегламентногоЗадания	- Текущее расписание.
//  ОписаниеЗавершения	 - ОписаниеОповещения				- Содержит описание процедуры, которая будет вызвана
//						   после закрытия диалога со следующими параметрами: 
//								* <Расписание> - Расписание - диалог закрыли по кнопке "OK". Неопределено - в противном случае.
//								* <ДополнительныеПараметры> - значение, которое было указано при создании объекта ОписаниеОповещения.
//
Процедура НастроитьРасписаниеПоложитьВоВременноеХранилище(ОписаниеЗавершенияНастроитьРасписание) Экспорт
	
	Расписание = ОписаниеЗавершенияНастроитьРасписание.Модуль.РасписаниеЗадания;
	
	Инициализатор = ?(Расписание = Неопределено, Новый РасписаниеРегламентногоЗадания, Расписание);
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Инициализатор);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеПоложитьВоВременноеХранилищеЗавершение", ЭтотОбъект, ОписаниеЗавершенияНастроитьРасписание);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

// Процедура - Обновить расписание
//
// Параметры:
//  Форма			 - УправляемаяФорма					- Форма из которой вызвана процедура.
//  Расписание		 - РасписаниеРегламентногоЗадания	- Текущее расписание.
//  НовоеРасписание	 - РасписаниеРегламентногоЗадания	- Новое расписание.
//
Процедура ОбновитьРасписание(Форма, НовоеРасписание) Экспорт

	Форма.РасписаниеЗадания = НовоеРасписание;
	Форма.РасписаниеСтрока = ?(НовоеРасписание = Неопределено, "", Строка(НовоеРасписание)); 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьРасписаниеПоложитьВоВременноеХранилищеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	Если Расписание <> Неопределено Тогда
		Адрес = ПоместитьВоВременноеХранилище(Расписание, ДополнительныеПараметры.Модуль.УникальныйИдентификатор);
		ДополнительныеПараметры.Модуль.Модифицированность = ДополнительныеПараметры.Модуль.РасписаниеЗадания <> Расписание;
		ОбновитьРасписание(ДополнительныеПараметры.Модуль, Расписание);
	Иначе
		Адрес = Неопределено;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры, Адрес);
	
КонецПроцедуры

#КонецОбласти
