&НаКлиенте
Процедура ПолучитьОсновнойШаблон(Команда)
	Объект.ДополнительныйТекстПредупреждения = ПолучитьОсновнойШаблонНаСервере(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьШаблонПервойРегистрации(Команда)
	Объект.ШаблонПервойРегистрации = ПолучитьШаблонПервойРегистрацииНаСервере(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьШаблонПовторнойРегистрации(Команда)
	Объект.ШаблонПовторнойРегистрации = ПолучитьШаблонПовторнойРегистрацииНаСервере(Объект.Ссылка);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОсновнойШаблонНаСервере(Ссылка)
	Если Ссылка = Справочники.ТипыЗадачКонтрольПодключений.КонтрольПодключенийНевозможноПодключиться Тогда
		Возврат Справочники.ТипыЗадачКонтрольПодключений.ПолучитьОсновнойШаблонКонтрольПодключенийНевозможноПодключиться();
	ИначеЕсли Ссылка = Справочники.ТипыЗадачКонтрольПодключений.КонтрольПодключенийТаймаут Тогда
		Возврат Справочники.ТипыЗадачКонтрольПодключений.ПолучитьОсновнойШаблонКонтрольПодключенийТаймаут();	
	КонецЕсли;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьШаблонПервойРегистрацииНаСервере(Ссылка)
	Если Ссылка = Справочники.ТипыЗадачКонтрольПодключений.КонтрольПодключенийНевозможноПодключиться Тогда
		Возврат Справочники.ТипыЗадачКонтрольПодключений.ПолучитьШаблонПервойРегистрацииКонтрольПодключенийНевозможноПодключиться();
	ИначеЕсли Ссылка = Справочники.ТипыЗадачКонтрольПодключений.КонтрольПодключенийТаймаут Тогда
		Возврат Справочники.ТипыЗадачКонтрольПодключений.ПолучитьШаблонПервойРегистрацииКонтрольПодключенийТаймаут();
	КонецЕсли;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьШаблонПовторнойРегистрацииНаСервере(Ссылка)
	Если Ссылка = Справочники.ТипыЗадачКонтрольПодключений.КонтрольПодключенийНевозможноПодключиться Тогда
		Возврат Справочники.ТипыЗадачКонтрольПодключений.ПолучитьШаблонПовторнойРегистрацииКонтрольПодключенийНевозможноПодключиться();
	ИначеЕсли Ссылка = Справочники.ТипыЗадачКонтрольПодключений.КонтрольПодключенийТаймаут Тогда
		Возврат Справочники.ТипыЗадачКонтрольПодключений.ПолучитьШаблонПовторнойРегистрацииКонтрольПодключенийТаймаут();
	КонецЕсли;
КонецФункции





