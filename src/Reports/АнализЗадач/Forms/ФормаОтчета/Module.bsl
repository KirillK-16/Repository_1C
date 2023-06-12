
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Параметр = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ТекущаяДата"));
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = ТекущаяДата();
		Параметр.Использование = Истина;
	КонецЕсли;
	
	Параметр = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПериодДиаграммы")); 
	Если Параметр <> Неопределено Тогда
		Параметр.Значение.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод; 
		Параметр.Значение.ДатаНачала = НачалоДня(ТекущаяДата() - (14 * 86400));
		Параметр.Значение.ДатаОкончания = КонецДня(ТекущаяДата());
		Параметр.Использование = Истина;
	КонецЕсли;
	
	РазмерМассива = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Количество();
	Для й = 0 По (РазмерМассива - 1) Цикл 
		Если Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[й].Параметр = Новый ПараметрКомпоновкиДанных("ПериодДиаграммы") Тогда 
			Параметр = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[й];
			Параметр.Значение.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод; 
			Параметр.Значение.ДатаНачала = НачалоДня(ТекущаяДата() - (14 * 86400));
			Параметр.Значение.ДатаОкончания = КонецДня(ТекущаяДата());
			Параметр.Использование = Истина;	
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры