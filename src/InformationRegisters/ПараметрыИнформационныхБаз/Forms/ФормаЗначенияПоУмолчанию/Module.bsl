
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьОтветственных();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОтветственных()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ВидКонтрольнойПроцедуры,
	|	РольПользователя
	|ИЗ
	|	РегистрСведений.ОтветственныеЗаНастройкуПроцедур
	|ГДЕ
	|	ОбъектКонтроля = &ВидОбъектаКонтроля
	|	И ВидКонтрольнойПроцедуры В (&ВидыКонтрольныхПроцедур)
	|";
	
	КонтрольВыполненияРегламентныхЗаданий = Справочники.ВидыКонтрольныхПроцедур.НайтиПоНаименованию("Контроль выполнения регламентных заданий");
	КонтрольНагрузочныхТестов = Справочники.ВидыКонтрольныхПроцедур.НайтиПоНаименованию("Контроль нагрузочных тестов");
	КонтрольПодключений = Справочники.ВидыКонтрольныхПроцедур.НайтиПоНаименованию("Контроль подключений");
	КонтрольПроизводительностиСсылка = Справочники.ВидыКонтрольныхПроцедур.НайтиПоНаименованию("Контроль производительности");
	ОценкаПользователей = Справочники.ВидыКонтрольныхПроцедур.НайтиПоНаименованию("Оценка пользователей");
	
	ВидыКонтрольныхПроцедур = Новый Массив;
	ВидыКонтрольныхПроцедур.Добавить(КонтрольВыполненияРегламентныхЗаданий);
	ВидыКонтрольныхПроцедур.Добавить(КонтрольНагрузочныхТестов);
	ВидыКонтрольныхПроцедур.Добавить(КонтрольПодключений);
	ВидыКонтрольныхПроцедур.Добавить(КонтрольПроизводительностиСсылка);
	ВидыКонтрольныхПроцедур.Добавить(ОценкаПользователей);
	
	Запрос.УстановитьПараметр("ВидОбъектаКонтроля", Справочники.ВидыОбъектовКонтроля.ИнформационнаяБаза);
	Запрос.УстановитьПараметр("ВидыКонтрольныхПроцедур", ВидыКонтрольныхПроцедур);
	
	КонтрольныеПроцедуры = Новый Соответствие;
	КонтрольныеПроцедуры.Вставить(КонтрольВыполненияРегламентныхЗаданий, Неопределено);
	КонтрольныеПроцедуры.Вставить(КонтрольНагрузочныхТестов, Неопределено);
	КонтрольныеПроцедуры.Вставить(КонтрольПодключений, Неопределено);
	КонтрольныеПроцедуры.Вставить(КонтрольПроизводительностиСсылка, Неопределено);
	КонтрольныеПроцедуры.Вставить(ОценкаПользователей, Неопределено);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		КонтрольныеПроцедуры[Выборка.ВидКонтрольнойПроцедуры] = Выборка.РольПользователя;
	КонецЦикла;
	
	Для Каждого ТекКонтрольнаяПроцедура Из КонтрольныеПроцедуры Цикл
		НовСтрока = ЭтотОбъект.ОтветственныеЗаНастройкуКонтрольныхПроцедур.Добавить();
		НовСтрока.ВидКонтрольнойПроцедуры = ТекКонтрольнаяПроцедура.Ключ;
		НовСтрока.РольПользователя = ТекКонтрольнаяПроцедура.Значение;
	КонецЦикла;
			
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Для Каждого ТекСтрока Из ЭтотОбъект.ОтветственныеЗаНастройкуКонтрольныхПроцедур Цикл
		МенеджерЗаписи = РегистрыСведений.ОтветственныеЗаНастройкуПроцедур.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ОбъектКонтроля = Справочники.ВидыОбъектовКонтроля.ИнформационнаяБаза;
		МенеджерЗаписи.ВидКонтрольнойПроцедуры = ТекСтрока.ВидКонтрольнойПроцедуры;
		МенеджерЗаписи.РольПользователя = ТекСтрока.РольПользователя;
		МенеджерЗаписи.Записать(Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ПроверяемыеРеквизиты.Очистить();
КонецПроцедуры
