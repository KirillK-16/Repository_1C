
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ПустаяСтрока(ЭтотОбъект.НаименованиеНастройки) Тогда
		ЭтотОбъект.НаименованиеНастройки = "Новая настройка";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНастройку(Команда)
	УИДНоваяНастройка = ЗагрузитьНавигационнуюСсылкуПрофильНаСервере(Объект.Ссылка, ЭтотОбъект.НавигационнаяСсылкаДляЗагрузки, ЭтотОбъект.НаименованиеНастройки);
	ЭтотОбъект.Закрыть();
	ОповеститьОВыборе(УИДНоваяНастройка);
	
	Оповестить("Мониторинг_СозданаНастройка", УИДНоваяНастройка, ЭтотОбъект);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗагрузитьНавигационнуюСсылкуПрофильНаСервере(ТекущийПрофиль, РезультатВвода, НаименованиеНастройки)
	УИДНоваяНастройка = Неопределено;
	
	Результат = Справочники.ПрофильМониторинга.РазобратьНавигационнуюСсылку(РезультатВвода);
	Если Результат <> Неопределено Тогда
		УИДНоваяНастройка = СоздатьНовуюНастройку(ТекущийПрофиль, Результат.СсылкаНаПрофиль, Результат.СсылкаНастройка, НаименованиеНастройки);	
	КонецЕсли;
		
	Возврат УИДНоваяНастройка;
КонецФункции

&НаСервереБезКонтекста
Функция СоздатьНовуюНастройку(ТекущийПрофиль, Профиль, Настройка, НаименованиеНастройки)
	ТекущийПрофильОбъект = ТекущийПрофиль.ПолучитьОбъект();
	
	УИДНоваяНастройка = ТекущийПрофильОбъект.КопироватьПоказатели(Профиль, Новый УникальныйИдентификатор(Настройка), НаименованиеНастройки);
	ТекущийПрофильОбъект.ТекущаяНастройка = УИДНоваяНастройка;
	ТекущийПрофильОбъект.Записать();
	
	Возврат УИДНоваяНастройка;
КонецФункции

