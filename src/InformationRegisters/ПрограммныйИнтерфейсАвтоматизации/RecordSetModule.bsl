
Процедура ПередЗаписью(Отказ, Замещение)
	Если Не ОбменДанными.Загрузка Тогда
		ТекДата = РаботаСоСценариямиАвтоматизацииСервер.ПолучитьТекущуюДатуСеанса();
		Для каждого Запись Из ЭтотОбъект Цикл
			Если Запись.ВерсияПоставки = "" Тогда
				Запись.ВерсияПоставки = "0.0.0.0";
			КонецЕсли;	
			Если Запись.Период = '00010101' Тогда
				Запись.Период = ТекДата;
			КонецЕсли;	
		КонецЦикла;	
	КонецЕсли;		
КонецПроцедуры
