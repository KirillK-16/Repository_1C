
Функция ЕстьЗаписи(Период, ИнформационнаяБаза, ПакетЦентраМониторинга) Экспорт
    
    Запрос = Новый Запрос;
    Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
                   |	ОперацииБизнесСтатистикиБуфер.ИнформационнаяБаза КАК ИнформационнаяБаза
                   |ИЗ
                   |	РегистрСведений.ОперацииБизнесСтатистикиБуфер КАК ОперацииБизнесСтатистикиБуфер
                   |ГДЕ
                   |	ОперацииБизнесСтатистикиБуфер.Период = &Период
                   |	И ОперацииБизнесСтатистикиБуфер.ИнформационнаяБаза = &ИнформационнаяБаза
                   |	И ОперацииБизнесСтатистикиБуфер.ПакетЦентраМониторинга = &ПакетЦентраМониторинга";
    
    Запрос.УстановитьПараметр("Период", Период);
    Запрос.УстановитьПараметр("ИнформационнаяБаза", ИнформационнаяБаза);
    Запрос.УстановитьПараметр("ПакетЦентраМониторинга", ПакетЦентраМониторинга);
    
    Результат = Запрос.Выполнить();
    
    Возврат НЕ Результат.Пустой();
    
КонецФункции

Процедура ПеренестиБизнесСтатистикуИзБуфера() Экспорт
	
	МинимальныйПериод = Константы.МинимальныйПериодХраненияДанныхВБуфереОперацийБизнесСтатистики.Получить();
	ГлубинаХранения = Константы.ГлубинаХраненияБуфераОперацийБизнесСтатистики.Получить();
	НовыйПериод = НачалоДня(ТекущаяДатаСеанса()) - ГлубинаХранения * 86400;
	Если МинимальныйПериод < НовыйПериод Тогда
		Константы.МинимальныйПериодХраненияДанныхВБуфереОперацийБизнесСтатистики.Установить(НовыйПериод);
	КонецЕсли;    		
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ОперацииБизнесСтатистикиБуфер.Период КАК Период
	                      |ИЗ
	                      |	РегистрСведений.ОперацииБизнесСтатистикиБуфер КАК ОперацииБизнесСтатистикиБуфер
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ОперацииБизнесСтатистикиБуфер.Период
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Период");
	ВыборкаПериоды = Запрос.Выполнить().Выбрать();
	Пока ВыборкаПериоды.Следующий() Цикл
		
		Запрос = Новый Запрос(ТекстЗапроса_ВыборкаИБПоПериоду());
		Запрос.УстановитьПараметр("Период", ВыборкаПериоды.Период);
		ВыборкаИБ = Запрос.Выполнить().Выбрать();
		Пока ВыборкаИБ.Следующий() Цикл
			
			Запрос = Новый Запрос(ТекстЗапроса_ВыборкаДанныхПоПериодуИИнформационнойБазе());
			Запрос.УстановитьПараметр("Период", ВыборкаПериоды.Период);
			Запрос.УстановитьПараметр("ИнформационнаяБаза", ВыборкаИБ.ИнформационнаяБаза);
			ТаблицаЗаписей = Запрос.Выполнить().Выгрузить();
			
			НаборЗаписей = РегистрыСведений.ОперацииБизнесСтатистики.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Период.Установить(ВыборкаПериоды.Период);
			НаборЗаписей.Отбор.ИнформационнаяБаза.Установить(ВыборкаИБ.ИнформационнаяБаза);
			НаборЗаписей.Загрузить(ТаблицаЗаписей);
			
			Если ВыборкаПериоды.Период < НовыйПериод Тогда
				НаборЗаписейКУдалению = РегистрыСведений.ОперацииБизнесСтатистикиБуфер.СоздатьНаборЗаписей();
				НаборЗаписейКУдалению.Отбор.Период.Установить(ВыборкаПериоды.Период);
				НаборЗаписейКУдалению.Отбор.ИнформационнаяБаза.Установить(ВыборкаИБ.ИнформационнаяБаза);
			КонецЕсли;		
			
			НачатьТранзакцию();
			Попытка
				НаборЗаписей.Записать();
				Если ВыборкаПериоды.Период < НовыйПериод Тогда
					НаборЗаписейКУдалению.Записать();				
				КонецЕсли;
			Исключение
				ОписаниеОшибки = ОписаниеОшибки();
				ЗаписьЖурналаРегистрации("ОперацииБизнесСтатистики.ПереносБуфера", УровеньЖурналаРегистрации.Ошибка, Метаданные.РегистрыСведений.ОперацииБизнесСтатистикиБуфер, , ОписаниеОшибки); 
				ОтменитьТранзакцию();
			КонецПопытки;
			ЗафиксироватьТранзакцию();
			
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Функция ТекстЗапроса_ВыборкаДанныхПоПериодуИИнформационнойБазе()
	Возврат "ВЫБРАТЬ
	        |	ОперацииБизнесСтатистикиБуфер.Период КАК Период,
	        |	ОперацииБизнесСтатистикиБуфер.ОперацияБизнесСтатистики КАК ОперацияБизнесСтатистики,
	        |	ОперацииБизнесСтатистикиБуфер.ИнформационнаяБаза КАК ИнформационнаяБаза,
	        |	СУММА(ОперацииБизнесСтатистикиБуфер.КоличествоЗначений) КАК КоличествоЗначений,
	        |	СУММА(ОперацииБизнесСтатистикиБуфер.СуммаЗначений) КАК СуммаЗначений
	        |ИЗ
	        |	РегистрСведений.ОперацииБизнесСтатистикиБуфер КАК ОперацииБизнесСтатистикиБуфер
	        |ГДЕ
	        |	ОперацииБизнесСтатистикиБуфер.Период = &Период
	        |	И ОперацииБизнесСтатистикиБуфер.ИнформационнаяБаза = &ИнформационнаяБаза
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ОперацииБизнесСтатистикиБуфер.ОперацияБизнесСтатистики,
	        |	ОперацииБизнесСтатистикиБуфер.ИнформационнаяБаза,
	        |	ОперацииБизнесСтатистикиБуфер.Период";
КонецФункции

Функция ТекстЗапроса_ВыборкаИБПоПериоду()
	Возврат "ВЫБРАТЬ
	        |	ОперацииБизнесСтатистикиБуфер.ИнформационнаяБаза КАК ИнформационнаяБаза
	        |ИЗ
	        |	РегистрСведений.ОперацииБизнесСтатистикиБуфер КАК ОперацииБизнесСтатистикиБуфер
	        |ГДЕ
	        |	ОперацииБизнесСтатистикиБуфер.Период = &Период
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ОперацииБизнесСтатистикиБуфер.ИнформационнаяБаза";
КонецФункции
