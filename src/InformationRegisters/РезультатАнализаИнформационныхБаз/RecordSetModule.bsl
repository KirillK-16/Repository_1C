
Процедура ПередЗаписью(Отказ, Замещение)
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Запись.НеИзменятьСтатус Тогда
			НаборЗаписей = РегистрыСведений.СтатусИнформационнойБазы.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ИнформационнаяБаза.Установить(Запись.ИнформационнаяБаза);
			ЗаписьСтатус = НаборЗаписей.Добавить();
			ЗаписьСтатус.ИнформационнаяБаза = Запись.ИнформационнаяБаза;
			ЗаписьСтатус.Статус = Запись.Статус;
			НаборЗаписей.Записать();
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
