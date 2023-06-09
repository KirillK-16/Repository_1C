
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Ключ", ПолучитьКлючЗаписиНаСервере());
	ОткрытьФорму("РегистрСведений.ПараметрыИнформационныхБаз.Форма.ФормаЗначенияПоУмолчанию", ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКлючЗаписиНаСервере()
	
	ИнформационнаяБаза = Справочники.ВидыОбъектовКонтроля.ИнформационнаяБаза.Ссылка;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОбъектКонтроля
	|ИЗ
	|	РегистрСведений.ПараметрыИнформационныхБаз
	|ГДЕ
	|	ОбъектКонтроля = &ИнформационнаяБаза
	|";
	Запрос.УстановитьПараметр("ИнформационнаяБаза", ИнформационнаяБаза);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		МенеджерЗаписи = РегистрыСведений.ПараметрыИнформационныхБаз.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ОбъектКонтроля = ИнформационнаяБаза;
		МенеджерЗаписи.Записать(Истина);
	КонецЕсли;
	
	ЗначенияКлюча = Новый Структура;
	ЗначенияКлюча.Вставить("ОбъектКонтроля", ИнформационнаяБаза); 
	
	Возврат РегистрыСведений.ПараметрыИнформационныхБаз.СоздатьКлючЗаписи(ЗначенияКлюча);
	
КонецФункции
