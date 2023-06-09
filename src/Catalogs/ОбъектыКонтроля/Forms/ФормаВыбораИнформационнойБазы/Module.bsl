////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокЗапрещенныхИнформационныхБаз = Параметры.ЗапрещенныеИнформационныеБазы;
	
	ЗапрещенныеИнформационныеБазыВМассив = Новый Массив;
	Для Каждого БазаИзСписка Из СписокЗапрещенныхИнформационныхБаз Цикл
		ЗапрещенныеИнформационныеБазыВМассив.Добавить(БазаИзСписка.Значение);
	КонецЦикла;
	
	Если НЕ Константы.ОтображатьВнутренниеЗамерыПроизводительности.Получить() Тогда
		ЗапрещенныеИнформационныеБазыВМассив.Добавить(Справочники.ОбъектыКонтроля.НайтиПоНаименованию("Центр Контроля Качества"));	
		ЗапрещенныеИнформационныеБазыВМассив.Добавить(Справочники.ОбъектыКонтроля.НайтиПоНаименованию("Центр мониторинга"));
	КонецЕсли;
		
	Список.Параметры.УстановитьЗначениеПараметра(
		"ЗапрещенныеИнформационныеБазы", ЗапрещенныеИнформационныеБазыВМассив
	);
	
	Список.Параметры.УстановитьЗначениеПараметра("ВидИнформационнаяБаза", Справочники.ВидыОбъектовКонтроля.ИнформационнаяБаза);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СписокКлючевыхОпераций

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭтотОбъект.Закрыть(ВыбраннаяСтрока);
КонецПроцедуры
