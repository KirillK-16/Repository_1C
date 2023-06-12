#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
// Создать и вернуть ссылку на соединение, параметры которого указаны в текущем объекте.
//
// Возвращаемое значение:
//  ЗащищенноеСоединениеOpenSSL - соединение на основе OpenSSL.
//  ЗащищенноеСоединениеNSS - соединение на основе NSS.
//  Неопределено - не защищенное соединение.
//
Функция СоздатьЗащищенноеСоединение() Экспорт
	
	Перем ЗащищенноеСоединение;
	Перем СертификатКлиента;
	Перем СертификатСервера;
	
	Если ВыбранныйКлиентскийСертификат = Перечисления.ТипыСертификатаЗащищенногоСоединенияДляКлиента.Файл Тогда
		СертификатКлиента = Новый СертификатКлиентаФайл(
		ФайлСертификатаКлиента,
		ПарольФайлаСертификатаКлиента);
	ИначеЕсли ВыбранныйКлиентскийСертификат = Перечисления.ТипыСертификатаЗащищенногоСоединенияДляКлиента.Windows Тогда
		СертификатКлиента = Новый СертификатКлиентаWindows(
		СпособВыбораСертификатаКлиента);
	КонецЕсли;
	
	Если ВыбранныйСерверныйСертификат = Перечисления.ТипыСертификатаЗащищенногоСоединенияДляСервера.Файл Тогда
		СертификатСервера = Новый СертификатыУдостоверяющихЦентровФайл(
		ФайлСертификатаКлиента,
		ПарольФайлаСертификатаКлиента);
	ИначеЕсли ВыбранныйСерверныйСертификат = Перечисления.ТипыСертификатаЗащищенногоСоединенияДляСервера.Windows Тогда
		СертификатСервера = Новый СертификатыУдостоверяющихЦентровWindows;
	КонецЕсли;
	
	ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL(СертификатКлиента, СертификатСервера);
	
	Возврат ЗащищенноеСоединение;
	
КонецФункции

// Проверка правильности заполнения реквищитов объекта.
//
// Проверка выполняется только для тех реквизитов. которые относятся к выбранному
// типу сертификата.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВыбранныйКлиентскийСертификат = Перечисления.ТипыСертификатаЗащищенногоСоединенияДляКлиента.Файл Тогда
		Если Не ЗначениеЗаполнено(ФайлСертификатаКлиента) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не указан файл клиентского сертификата.'");
			Сообщение.Поле = "Объект.ФайлСертификатаКлиента";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ВыбранныйКлиентскийСертификат = Перечисления.ТипыСертификатаЗащищенногоСоединенияДляКлиента.Windows Тогда
		Если Не ЗначениеЗаполнено(СпособВыбораСертификатаКлиента) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не указан способ выбора сертификата клиента.'");
			Сообщение.Поле = "Объект.СпособВыбораСертификатаКлиента";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ВыбранныйСерверныйСертификат = Перечисления.ТипыСертификатаЗащищенногоСоединенияДляСервера.Файл Тогда
		Если Не ЗначениеЗаполнено(ФайлСертификатаУдостоверяющегоЦентра) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не указан файл сертификата удостоверяющего центра.'");
			Сообщение.Поле = "Объект.ФайлСертификатаУдостоверяющегоЦентра";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли