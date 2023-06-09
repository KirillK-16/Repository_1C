
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭтотОбъект.Список.Параметры.УстановитьЗначениеПараметра("КонтрольПодключений", Справочники.ВидыКонтрольныхПроцедур.НайтиПоНаименованию("Контроль подключений"));
	ЭтотОбъект.Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДата());
    ЭтотОбъект.Список.Параметры.УстановитьЗначениеПараметра("ЦентрКонтроляКачества", Справочники.ОбъектыКонтроля.ЦентрКонтроляКачества());
	
	ЭтотОбъект.КонтрольПодключенийДопустимаяНедоступность = Константы.КонтрольПодключенийДопустимаяНедоступность.Получить();
	ЭтотОбъект.КонтрольПодключенийДопустимоНетДанных = Константы.КонтрольПодключенийДопустимоНетДанных.Получить();
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуЭлементаКонтрольПодключений(ВыбраннаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	
	ОткрытьФормуЭлементаКонтрольПодключений(Элемент.ТекущиеДанные.Ссылка);	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуЭлементаКонтрольПодключений(Ссылка)
	ПараметрыОткрытия = Новый Структура("Ключ", Ссылка);
	ОткрытьФорму("Справочник.КонтрольныеПроцедуры.Форма.ФормаЭлементаКонтрольПодключений", ПараметрыОткрытия);
КонецПроцедуры

&НаКлиенте
Процедура Возобновить(Команда)
	ВозобновитьНаСервере(ЭтотОбъект.Элементы.Список.ВыделенныеСтроки);
	Оповестить("Изменение.Справочник.КонтрольныеПроцедуры",,ЭтотОбъект);	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВозобновитьНаСервере(Знач Ссылки)
	Справочники.КонтрольныеПроцедуры.КонтрольПодключенийВозобновить(Ссылки);
КонецПроцедуры

&НаКлиенте
Процедура Пауза(Команда)
	ПаузаНаСервере(ЭтотОбъект.Элементы.Список.ВыделенныеСтроки);
	Оповестить("Изменение.Справочник.КонтрольныеПроцедуры",,ЭтотОбъект);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПаузаНаСервере(Знач Ссылки)
	Справочники.КонтрольныеПроцедуры.КонтрольПодключенийПауза(Ссылки);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Изменение.Справочник.КонтрольныеПроцедуры" Тогда
		ЭтотОбъект.Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДата());
		ЭтотОбъект.Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	Оповестить("Изменение.Справочник.КонтрольныеПроцедуры",,ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры
