#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПриЗаписи(Отказ, Замещение)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекСтрока из ЭтотОбъект Цикл
		
		КонтрольнаяПроцедура = ТекСтрока.КонтрольнаяПроцедура;
		Если ТипЗнч(КонтрольнаяПроцедура) = Тип("СправочникСсылка.КонтрольныеПроцедуры") Тогда
			ОбъектКонтроля = КонтрольнаяПроцедура.ОбъектКонтроля;
			Параметры = Новый Структура;
			Параметры.Вставить("АнализВызововКластера1С", Новый Массив);
			ТехнологическийЖурнал.ОбновитьФайлНастроекТехнологическогоЖурнала(ОбъектКонтроля, Новый Структура("КодыКонтрольныхПроцедур",Параметры));
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецЕсли