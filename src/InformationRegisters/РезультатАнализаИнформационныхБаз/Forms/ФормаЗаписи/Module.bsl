
&НаКлиенте
Процедура ИсходныеДанные(Команда)
	ИсходныеДанныеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ИсходныеДанныеНаСервере()
	
	Настройки = ПолучитьНастройки(Запись.ИнформационнаяБаза);
	
	СравнительныеДанные.Очистить();
	ОтклоненияПоНеделям.Очистить();
	СравнениеПоНеделям.Очистить();
	КорреляцияПоНеделям.Очистить();
	ПриростМетаданных.Очистить();

	
	Если Настройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
			
	Результат = Справочники.НастройкиАнализаСостоянияИнформационнойБазы.АнализАктивностиПользователей(Настройки, Запись.ИнформационнаяБаза, Запись.ДатаПроведенияАнализа);
	СравнительныеДанные.Загрузить(Результат.СравнительныеДанные);
	ОтклоненияПоНеделям.Загрузить(Результат.ОтклоненияПоНеделям);
	
	Результат = Справочники.НастройкиАнализаСостоянияИнформационнойБазы.АнализПриростДанных(Настройки, Запись.ИнформационнаяБаза, Запись.ДатаПроведенияАнализа);
	ТаблицаМетаданных.Загрузить(Результат.ТаблицаМетаданных);
	
	// Построение диаграммы СравнениеПоНеделям.
	
	СравнениеПоНеделям.Очистить();
	СравнениеПоНеделям.ТипДиаграммы = ТипДиаграммы.График;
	СравнениеПоНеделям.Обновление = Ложь;
	СравнениеПоНеделям.Анимация = АнимацияДиаграммы.НеИспользовать;
	
	// Выбор уникальных точек и их сортировка
	Список = Новый СписокЗначений;
	Для Каждого ТекСтрока Из СравнительныеДанные Цикл   				
		Если Список.НайтиПоЗначению(ТекСтрока.Период) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Список.Добавить(ТекСтрока.Период);      			
	КонецЦикла; 	
	Список.СортироватьПоЗначению();
	
	СерииДиаграммы = Новый Соответствие;
	ТочкиДиаграммы = Новый Соответствие;
	Для Каждого ЭлементСписка Из Список Цикл
		Если ТочкиДиаграммы[ЭлементСписка.Значение] = Неопределено Тогда 
			НоваяТочка = СравнениеПоНеделям.Точки.Добавить(Формат(ЭлементСписка.Значение));
			ТочкиДиаграммы.Вставить(ЭлементСписка.Значение, НоваяТочка); 
		КонецЕсли;	
	КонецЦикла; 
	
	Для Каждого Стр Из СравнительныеДанные Цикл 
		Если СерииДиаграммы[Стр.Неделя] = Неопределено Тогда 
			НоваяСерия = СравнениеПоНеделям.Серии.Добавить("Неделя "+ Формат(Стр.Неделя));
			НоваяСерия.Маркер = ТипМаркераДиаграммы.Нет;
			СерииДиаграммы.Вставить(Стр.Неделя, НоваяСерия); 
		КонецЕсли;
		СравнениеПоНеделям.УстановитьЗначение(ТочкиДиаграммы[Стр.Период], СерииДиаграммы[Стр.Неделя], Стр.Количество);
	КонецЦикла;
	
	// Построение диаграммы КорреляцияПоНеделям.
	
	СерииДиаграммыКорр = Новый Соответствие;
	ТочкиДиаграммыКорр = Новый Соответствие;
	КорреляцияПоНеделям.ТипДиаграммы = ТипДиаграммы.График;
	КорреляцияПоНеделям.Обновление = Ложь;
	КорреляцияПоНеделям.Анимация = АнимацияДиаграммы.НеИспользовать;
	Для Каждого Стр Из ОтклоненияПоНеделям Цикл 
		Если СерииДиаграммыКорр["Корр"] = Неопределено Тогда 
			НоваяСерия = КорреляцияПоНеделям.Серии.Добавить("Коэффициент корреляции");
			НоваяСерия.Маркер = ТипМаркераДиаграммы.Нет;
			СерииДиаграммыКорр.Вставить("Корр", НоваяСерия); 
		КонецЕсли;
		Если ТочкиДиаграммыКорр[Стр.Неделя] = Неопределено Тогда 
			НоваяТочка = КорреляцияПоНеделям.Точки.Добавить(Формат(Стр.Неделя));
			ТочкиДиаграммыКорр.Вставить(Стр.Неделя, НоваяТочка); 
		КонецЕсли;
		
		КорреляцияПоНеделям.УстановитьЗначение(ТочкиДиаграммыКорр[Стр.Неделя], СерииДиаграммыКорр["Корр"], Стр.КоэффициентКорреляции);
	КонецЦикла;
	
	// Построение диаграммы ПриростМетаданных.
	
	// Выбор уникальных точек и их сортировка
	Список = Новый СписокЗначений;
	Для Каждого ТекСтрока Из ТаблицаМетаданных Цикл   				
		Если Список.НайтиПоЗначению(ТекСтрока.Период) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Список.Добавить(ТекСтрока.Период);      			
	КонецЦикла; 	
	Список.СортироватьПоЗначению();
	
	СерииДиаграммы = Новый Соответствие;
	ТочкиДиаграммы = Новый Соответствие;
	Для Каждого ЭлементСписка Из Список Цикл
		Если ТочкиДиаграммы[ЭлементСписка.Значение] = Неопределено Тогда 
			НоваяТочка = ПриростМетаданных.Точки.Добавить(Формат(ЭлементСписка.Значение));
			ТочкиДиаграммы.Вставить(ЭлементСписка.Значение, НоваяТочка); 
		КонецЕсли;	
	КонецЦикла; 
	
	ПриростМетаданных.ТипДиаграммы = ТипДиаграммы.График;
	ПриростМетаданных.Обновление = Ложь;
	ПриростМетаданных.Анимация = АнимацияДиаграммы.НеИспользовать;
	Для Каждого Стр Из ТаблицаМетаданных Цикл 
		Если СерииДиаграммы[Стр.ОбъектМетаданных] = Неопределено Тогда 
			НоваяСерия = ПриростМетаданных.Серии.Добавить(Строка(Стр.ОбъектМетаданных));
			НоваяСерия.Маркер = ТипМаркераДиаграммы.Нет;
			СерииДиаграммы.Вставить(Стр.ОбъектМетаданных, НоваяСерия); 
		КонецЕсли;
			
		ПриростМетаданных.УстановитьЗначение(ТочкиДиаграммы[Стр.Период], СерииДиаграммы[Стр.ОбъектМетаданных], Стр.Значение);
	КонецЦикла;	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНастройки(ИнформационнаяБаза)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	НастройкиАнализаСостоянияИнформационнойБазыКонфигурации.Ссылка КАК Ссылка,
	                      |	НастройкиАнализаСостоянияИнформационнойБазыКонфигурации.Ссылка.ИспользоватьВесовыеКоэффициенты КАК ИспользоватьВесовыеКоэффициенты,
	                      |	НастройкиАнализаСостоянияИнформационнойБазыКонфигурации.Ссылка.ГлубинаАнализаДанных КАК ГлубинаАнализаДанных,
	                      |	НастройкиАнализаСостоянияИнформационнойБазыКонфигурации.Ссылка.ОбщийКоэффициентКорреляцииПрироста КАК ОбщийКоэффициентКорреляцииПрироста,
	                      |	НастройкиАнализаСостоянияИнформационнойБазыКонфигурации.Ссылка.КоэффициентКорреляцииПользовательскойАктивности КАК КоэффициентКорреляцииПользовательскойАктивности,
	                      |	НастройкиАнализаСостоянияИнформационнойБазыКонфигурации.Ссылка.ГлубинаАнализаАктивности КАК ГлубинаАнализаАктивности,
	                      |	НастройкиАнализаСостоянияИнформационнойБазыКонфигурации.Ссылка.МетодАнализаАктивности КАК МетодАнализаАктивности,
	                      |	НастройкиАнализаСостоянияИнформационнойБазыКонфигурации.Ссылка.МинимальнаяПользовательскаяАктивность КАК МинимальнаяПользовательскаяАктивность
	                      |ИЗ
	                      |	РегистрСведений.ИнформацияСрезПоследних КАК ИнформацияСрезПоследних
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НастройкиАнализаСостоянияИнформационнойБазы.Конфигурации КАК НастройкиАнализаСостоянияИнформационнойБазыКонфигурации
	                      |		ПО ИнформацияСрезПоследних.Конфигурация = НастройкиАнализаСостоянияИнформационнойБазыКонфигурации.Конфигурация
	                      |			И (ИнформацияСрезПоследних.ИнформационнаяБаза = &ИнформационнаяБаза)");
	Запрос.УстановитьПараметр("ИнформационнаяБаза", ИнформационнаяБаза);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Настройки = Новый Структура("ИспользоватьВесовыеКоэффициенты,КоэффициентКорреляцииПользовательскойАктивности,ГлубинаАнализаДанных,ОбщийКоэффициентКорреляцииПрироста,
			|ГлубинаАнализаАктивности,МетодАнализаАктивности,МинимальнаяПользовательскаяАктивность,Конфигурации,ПриростДанных");
		ЗаполнитьЗначенияСвойств(Настройки, Выборка);
		ОбъектНастройки = Выборка.Ссылка.ПолучитьОбъект();		
		Настройки.Вставить("Конфигурации", ОбъектНастройки.Конфигурации.Выгрузить());
		Настройки.Вставить("ПриростДанных", ОбъектНастройки.ПриростДанных.Выгрузить());
		
		Возврат Настройки;
	КонецЕсли;
	
	Возврат Неопределено

КонецФункции

