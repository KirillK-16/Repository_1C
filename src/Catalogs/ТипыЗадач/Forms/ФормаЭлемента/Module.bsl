&НаКлиенте
Процедура ПолучитьШаблонВосстановления(Команда)
	Объект.ШаблонВосстановления = ПолучитьШаблонВосстановленияНаСервере(Объект.Ссылка);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьШаблонВосстановленияНаСервере(Ссылка)
	Если Ссылка = Справочники.ТипыЗадач.ВосстановлениеРаботоспособоностиКонтрольнойПроцедуры Тогда
		Возврат Справочники.ТипыЗадач.ПолучитьШаблонВосстановления();
	КонецЕсли;
КонецФункции


