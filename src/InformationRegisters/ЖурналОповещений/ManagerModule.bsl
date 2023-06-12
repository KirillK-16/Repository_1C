#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция УдалитьУстаревшиеДанные(КрайняяДатаЗаписи) Экспорт
	
	ЕстьУдаление = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Период КАК Период
	|ИЗ
	|	(ВЫБРАТЬ ПЕРВЫЕ 1000
	|		ЖурналОповещений.Период КАК Период
	|	ИЗ
	|		РегистрСведений.ЖурналОповещений КАК ЖурналОповещений
	|	ГДЕ
	|		ЖурналОповещений.Период < &КрайняяДатаЗаписи
	|	УПОРЯДОЧИТЬ ПО
	|		ЖурналОповещений.Период ВОЗР
	|	) КАК Выборка
	|";
	
	Запрос.УстановитьПараметр("КрайняяДатаЗаписи", КрайняяДатаЗаписи);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		ЕстьУдаление = Истина;
		
		НаборЗаписей = РегистрыСведений.ЖурналОповещений.СоздатьНаборЗаписей();
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			НаборЗаписей.Отбор.Период.Установить(Выборка.Период);
			НаборЗаписей.Записать(Истина);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ЕстьУдаление;
	
КонецФункции

#КонецЕсли